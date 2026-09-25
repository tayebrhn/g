<#
.SYNOPSIS
    Rolls this node back to a previously deployed TCExam release.

.DESCRIPTION
    Flips the C:\tcexam\current junction back to an earlier release,
    restarts the services and waits for the health endpoint.
    The database is NOT rolled back: TCExam upgrade scripts are written
    to be backward compatible, so the old code keeps running against the
    migrated schema (see DEPLOYMENT.md section 5 and UPGRADE.TXT).

.EXAMPLE
    # list the available releases
    .\rollback-release.ps1

    # roll back to a specific tag
    .\rollback-release.ps1 -Tag abc123
#>
[CmdletBinding()]
param(
    [string]$TcexamHome = 'C:\tcexam',
    [string]$Tag = '',
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

$currentLink = Join-Path $TcexamHome 'current'
Assert-Condition (Test-Path -LiteralPath $currentLink) "no active release found at $currentLink (run install-node.ps1 first)"

$releases = Get-ChildItem -LiteralPath (Join-Path $TcexamHome 'releases') -Directory |
    Sort-Object LastWriteTime -Descending |
    Select-Object -ExpandProperty Name

if ($releases.Count -eq 0) {
    throw 'no releases found under ' + $TcexamHome + '\releases'
}

if ($Tag -eq '') {
    $active = Split-Path -Leaf ((Get-Item -LiteralPath $currentLink).Target)
    Write-Host 'available releases (newest first):'
    foreach ($rel in $releases) {
        $marker = $(if ($rel -eq $active) { '  <-- active' } else { '' })
        Write-Host ('    ' + $rel + $marker)
    }

    Write-Host ''
    Write-Host 'pass -Tag <name> to roll back to that release.'
    return
}

$target = Join-Path $TcexamHome ('releases\' + $Tag)
Assert-Condition (Test-Path -LiteralPath $target) "release not found: $target"

& $NssmExe stop TCexamNGINX | Out-Null
& $NssmExe stop TCexamPHP 2>$null
& $NssmExe stop TCexamPHP | Out-Null

$null = cmd /c rmdir "$currentLink"
$null = cmd /c mklink /J "$currentLink" "$target"
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

Assert-Condition $healthy 'health check failed after rollback; inspect the service logs'

Write-Host ''
Write-Host 'ROLLBACK COMPLETE' -ForegroundColor Green
Write-Host ('    current -> ' + $target)
