<#
.SYNOPSIS
    Verifies a deployed TCExam instance (single node or through the load balancer).

.DESCRIPTION
    Runs the post-deployment smoke tests against a base URL:
      - the static liveness endpoint used by the load balancer;
      - the public info page and the public area;
      - the admin area answering with the login form for anonymous visitors;
      - optionally, a real login and the capability-gated admin pages.

    NOTE: the optional login test is subject to the login brute-force
    protection: wait a few seconds between consecutive runs using
    -TestUser, or the login is delayed by design.

.EXAMPLE
    .\verify-deployment.ps1 -BaseUrl https://exam.example.org

    .\verify-deployment.ps1 -BaseUrl https://exam.example.org -TestUser verify -TestPassword 'secret'
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$BaseUrl,
    [string]$TestUser = '',
    [string]$TestPassword = '',
    [switch]$SkipSslVerify
)

$ErrorActionPreference = 'Stop'

# Windows PowerShell 5.1 needs an explicit nudge for TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if ($SkipSslVerify) {
    # self-signed certificates only: never do this against a production CA
    Add-Type @'
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(ServicePoint sp, X509Certificate cert, WebRequest req, int problem) { return true; }
}
'@
    [Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
}

$base = $BaseUrl.TrimEnd('/')
$results = @()
$deniedText = 'You do not have permission to view this page.'

function Get-Page([uri]$Uri) {
    try {
        return Invoke-WebRequest -Uri $Uri -UseBasicParsing -TimeoutSec 20
    } catch {
        $r = New-Object PSObject -Property @{ StatusCode = -1; Content = '' }
        return $r
    }
}

function Check([string]$Label, [bool]$Condition, [string]$Detail) {
    $script:results += [pscustomobject]@{
        Test    = $Label
        Pass    = $Condition
        Detail  = $Detail
    }
    $mark = $(if ($Condition) { 'PASS' } else { 'FAIL' })
    Write-Host ('  [{0}] {1}  {2}' -f $mark, $Label, $(if ($Condition) { '' } else { $Detail }))
}

Write-Host ('verifying ' + $base)

# --- 1. liveness endpoint (the load balancer health check) -----------------
$resp = Get-Page ($base + '/health.txt')
Check 'liveness endpoint answers 200' ($resp.StatusCode -eq 200) ('HTTP ' + $resp.StatusCode)

# --- 2. public info page (level 0, no login required) -----------------------
$resp = Get-Page ($base + '/admin/code/tce_page_info.php')
Check 'public info page answers 200' ($resp.StatusCode -eq 200) ('HTTP ' + $resp.StatusCode)

# --- 3. admin area: anonymous visitors must get the login form --------------
$resp = Get-Page ($base + '/admin/code/index.php')
$hasLogin = (($resp.Content -join '') -match 'form_login')
Check 'admin login form for anonymous visitors' ($resp.StatusCode -eq 200 -and $hasLogin) ('HTTP ' + $resp.StatusCode)
$resp = Get-Page ($base + '/admin/code/tce_update.php')
Check 'system update page protected' ((($resp.Content -join '') -match 'form_login') -or (($resp.Content -join '') -match [regex]::Escape($deniedText))) ('HTTP ' + $resp.StatusCode)

# --- 4. public test-taker area ----------------------------------------------
$resp = Get-Page ($base + '/public/code/index.php')
Check 'public area answers 200' ($resp.StatusCode -eq 200) ('HTTP ' + $resp.StatusCode)

# --- 5. optional: real login + capability-gated pages ------------------------
if ($TestUser -ne '' -and $TestPassword -ne '') {
    $loginBody = @{ logaction = 'login'; xuser_name = $TestUser; xuser_password = $TestPassword }
    $login = $null
    $redirected = $false
    try {
        # a successful login answers with a redirect to the entered page
        # (K_REDIRECT_LOGIN_MODE); do not follow it: the Location header
        # is built from K_PATH_HOST and may point at a different hostname.
        # -MaximumRedirection 0 makes PowerShell 5.1 emit a non-terminating
        # error while still returning the 3xx response object, so the
        # error is silenced here and only the status code is inspected.
        $login = Invoke-WebRequest -Uri ($base + '/admin/code/index.php') -Method Post -Body $loginBody -SessionVariable websession -UseBasicParsing -TimeoutSec 30 -MaximumRedirection 0 -ErrorAction SilentlyContinue
        if ($null -ne $login -and [int]$login.StatusCode -ge 300 -and [int]$login.StatusCode -lt 400) {
            $redirected = $true
        }
    } catch {
        # other PowerShell versions raise instead of returning the 3xx
        $resp = $_.Exception.Response
        if ($null -ne $resp) {
            $code = [int]$resp.StatusCode
            if ($code -ge 300 -and $code -lt 400) {
                $redirected = $true
            }
        }
    }

    # a failed login answers HTTP 200 with the login form and a warning;
    # a successful one answers with the redirect checked above
    Check 'test account can log in' $redirected 'login failed (wrong credentials, or brute-force delay: wait a few seconds and retry)'

    if ($redirected) {
        # the per-request refresh makes the session valid immediately;
        # a fresh GET on the original host reuses the cookie
        $admin = Invoke-WebRequest -Uri ($base + '/admin/code/index.php') -WebSession $websession -UseBasicParsing -TimeoutSec 20
        $adminContent = $admin.Content -join ''
        $loggedIn = ($adminContent -notmatch 'form_login')
        Check 'admin area opens for the test account' ($admin.StatusCode -eq 200 -and $loggedIn) ('HTTP ' + $admin.StatusCode)

        $logout = Invoke-WebRequest -Uri ($base + '/public/code/index.php') -WebSession $websession -UseBasicParsing -TimeoutSec 20
        Check 'public area opens for the test account' ($logout.StatusCode -eq 200) ('HTTP ' + $logout.StatusCode)
    }
}

# --- report ------------------------------------------------------------------
$failed = @($results | Where-Object { -not $_.Pass })
if ($failed.Count -gt 0) {
    Write-Host ''
    Write-Host ('FAILED: {0} of {1} checks' -f $failed.Count, $results.Count) -ForegroundColor Red
    exit 1
}
Write-Host ''
Write-Host ('PASSED: all {0} checks' -f $results.Count) -ForegroundColor Green
