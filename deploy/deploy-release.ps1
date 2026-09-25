<#
.SYNOPSIS
    Deploys a new TCExam release on this node (zero-downtime junction switch).

.DESCRIPTION
    Copies the new release into C:\tcexam\releases\<tag>, carries over the
    per-deployment configuration and the shared-media junctions from the
    currently active release, flips the "current" junction, restarts the
    nginx and php-cgi services and waits for the health endpoint.
    Run it on one node at a time (the load balancer serves the others).

    IMPORTANT: if the new release contains a newer database upgrade script
    under install\upgrade\, apply it to the database BEFORE switching the
    code (see DEPLOYMENT.md section 5). The TCExam code degrades gracefully
    against a not-yet-migrated schema, but apply the migration in the same
    maintenance window.

.EXAMPLE
    .\deploy-release.ps1 -SourceDir C:\build\tcexam-abc123 -Tag abc123
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$SourceDir,
    [string]$TcexamHome = 'C:\tcexam',
    [Parameter(Mandatory = $true)][string]$Tag,
    [string]$NginxDir = 'C:\nginx',
    [string]$NssmExe = 'C:\tools\nssm.exe',
    [int]$HealthCheckPort = 80,
    [int]$HealthTimeoutSec = 60
)

$ErrorActionPreference = 'Stop'

function Assert-Condition([bool]$Condition, [string]$Message) {
    if (-not $Condition) {
        throw $Message
    }
}

function Invoke-Robocopy {
    param([string]$Source, [string]$Destination, [string[]]$ExtraArgs = @())
    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    $null = robocopy $Source $Destination /E /R:2 /W:2 @ExtraArgs
    Assert-Condition ($LASTEXITCODE -lt 8) "robocopy failed (exit $LASTEXITCODE): $Source -> $Destination"
}

function Get-JunctionTarget([string]$Link) {
    if (-not (Test-Path -LiteralPath $Link)) {
        return ''
    }

    try {
        return (Get-Item -LiteralPath $Link).Target
    } catch {
        return ''
    }
}

# ---------------------------------------------------------------------------
# 0. checks
# ---------------------------------------------------------------------------
$currentLink = Join-Path $TcexamHome 'current'
Assert-Condition (Test-Path -LiteralPath $SourceDir) "source directory not found: $SourceDir"
Assert-Condition (Test-Path -LiteralPath $currentLink) "no active release found at $currentLink (run install-node.ps1 first)"

$currentRelease = (Get-Item -LiteralPath $currentLink).Target
Assert-Condition ($null -ne $currentRelease -and $currentRelease -ne '') "cannot resolve the current release"
Write-Host ('current release: ' + $currentRelease)

$newRelease = Join-Path $TcexamHome ('releases\' + $Tag)
Assert-Condition (-not (Test-Path -LiteralPath $newRelease)) "release tag already exists: $newRelease (use rollback-release.ps1 to switch to it, or pass a new -Tag)"

# ---------------------------------------------------------------------------
# 1. copy the new release
# ---------------------------------------------------------------------------
Write-Host ('==> copying the release to ' + $newRelease)
Invoke-Robocopy $SourceDir $newRelease @('/XD', '.git')
if (Test-Path -LiteralPath (Join-Path $newRelease 'install')) {
    Remove-Item -LiteralPath (Join-Path $newRelease 'install') -Recurse -Force
    Write-Host '    install/ removed from the release'
}

# ---------------------------------------------------------------------------
# 2. carry over the per-deployment configuration
# ---------------------------------------------------------------------------
Write-Host '==> carrying over the deployment configuration from the current release'

# admin/config and public/config: everything except the tracked tce_auth.php
foreach ($area in @('admin', 'public')) {
    $src = Join-Path $currentRelease ($area + '\config')
    if (Test-Path -LiteralPath $src) {
        Invoke-Robocopy $src (Join-Path $newRelease ($area + '\config')) @('/XF', 'tce_auth.php')
    }
}

# shared/config is entirely deployment-owned (database, paths, security seed, language)
$sharedSrc = Join-Path $currentRelease 'shared\config'
Assert-Condition (Test-Path -LiteralPath $sharedSrc) 'current release has no shared\config'
Invoke-Robocopy $sharedSrc (Join-Path $newRelease 'shared\config')

# pre-generated language cache (avoids regeneration on the first requests)
$langCache = Join-Path $currentRelease 'cache\lang'
if (Test-Path -LiteralPath $langCache) {
    Invoke-Robocopy $langCache (Join-Path $newRelease 'cache\lang')
}

# sanity: the security seed and the paths must be present in the new release
Assert-Condition (Test-Path -LiteralPath (Join-Path $newRelease 'shared\config\tce_general_constants.php')) 'carried-over configuration incomplete'

# ---------------------------------------------------------------------------
# 3. shared media junctions
# ---------------------------------------------------------------------------
Write-Host '==> recreating the shared media junctions'
foreach ($sub in @('uid', 'backup')) {
    $existing = Get-JunctionTarget (Join-Path $currentRelease ('cache\' + $sub))
    if ($existing -ne '') {
        $null = cmd /c mklink /J (Join-Path $newRelease ('cache\' + $sub)) "$existing"
        Assert-Condition ($LASTEXITCODE -eq 0) ("could not create the media junction for cache\" + $sub)
        Write-Host ("    cache\" + $sub + ' -> ' + $existing)
    }
}

# ---------------------------------------------------------------------------
# 4. switch the junction
# ---------------------------------------------------------------------------
Write-Host '==> switching the release'
& $NssmExe stop TCexamNGINX | Out-Null
& $NssmExe stop TCexamPHP 2>$null
& $NssmExe stop TCexamPHP | Out-Null

$null = cmd /c rmdir "$currentLink"
$null = cmd /c mklink /J "$currentLink" "$newRelease"
Assert-Condition ($LASTEXITCODE -eq 0) 'could not flip the current junction'

Push-Location $NginxDir
try {
    $null = & "$NginxDir\nginx.exe" -t 2>&1
    Assert-Condition ($LASTEXITCODE -eq 0) 'nginx -t rejected the configuration'
} finally {
    Pop-Location
}

& $NssmExe start TCexamPHP | Out-Null
& $NssmExe start TCexamNGINX | Out-Null
Write-Host ('    current -> ' + $newRelease)

# ---------------------------------------------------------------------------
# 5. health check
# ---------------------------------------------------------------------------
Write-Host '==> waiting for the health endpoint'
$deadline = (Get-Date).AddSeconds($HealthTimeoutSec)
$healthy = $false
while ((Get-Date) -lt $deadline) {
    try {
        $resp = Invoke-WebRequest -Uri ('http://127.0.0.1:' + $HealthCheckPort + '/health.txt') -UseBasicParsing -TimeoutSec 5
        if ($resp.StatusCode -eq 200) {
            $healthy = $true
            break
        }
    } catch {
        Start-Sleep -Seconds 2
    }
}

Assert-Condition $healthy ('health check failed after ' + $HealthTimeoutSec + 's; inspect ' + $TcexamHome + '\logs and roll back with rollback-release.ps1 if needed')

Write-Host ''
Write-Host 'RELEASE DEPLOYED' -ForegroundColor Green
Write-Host ('    tag     : ' + $Tag)
Write-Host ('    release : ' + $newRelease)
Write-Host ''
Write-Host 'afterthoughts:'
Write-Host '  - verify the node: powershell -File deploy\verify-deployment.ps1 -BaseUrl <public url>'
Write-Host '  - previous release kept for rollback: ' + $currentRelease
Write-Host '  - if every node is switched, clean the old releases when confident'
