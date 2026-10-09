# ============================================================
# TCExam - Build and Package Offline Production Bundle (Windows)
# ============================================================
# Run this script whenever you update code, patch bugs, or upgrade
# components on an internet-connected development machine.
# ============================================================
Param(
    [switch]$NoCache = $false,
    [string]$OutputFile = ""
)

$ErrorActionPreference = "Stop"

$RootDir = if ($PSScriptRoot) { Split-Path $PSScriptRoot -Parent } else { (Get-Location).Path }
if (-not $OutputFile) {
    $OutputFile = Join-Path $RootDir "offline-deployment\tcexam-offline-bundle.tar"
}

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  TCExam - Building and Packaging Offline Production Bundle" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

# 1. Verify Docker is running
docker info *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Docker is not running or not installed." -ForegroundColor Red
    Write-Host "Please start Docker Desktop and run this script again."
    exit 1
}

# 2. Rebuild the application image with the latest codebase
Write-Host "[1/4] Building latest tcexam-app:latest image with updated codebase..." -ForegroundColor Cyan
$buildArgs = @("build", "-t", "tcexam-app:latest")
if ($NoCache) {
    $buildArgs += "--no-cache"
    Write-Host "      (--no-cache flag enabled: full fresh rebuild)" -ForegroundColor Yellow
}
$buildArgs += $RootDir

& docker @buildArgs
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Docker build failed. Please resolve the errors above." -ForegroundColor Red
    exit 1
}
Write-Host "[SUCCESS] tcexam-app:latest built successfully." -ForegroundColor Green

# 3. Ensure supporting images are present
Write-Host "[2/4] Verifying base images (nginx:alpine, mariadb:10.11)..." -ForegroundColor Cyan
docker image inspect nginx:alpine *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "      Pulling nginx:alpine..." -ForegroundColor Yellow
    docker pull nginx:alpine
}

docker image inspect mariadb:10.11 *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "      Pulling mariadb:10.11..." -ForegroundColor Yellow
    docker pull mariadb:10.11
}

# 4. Ensure destination directory exists
$outputDir = Split-Path $OutputFile -Parent
if ($outputDir -and (-not (Test-Path $outputDir))) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

# 5. Export images to portable offline tar archive
Write-Host "[3/4] Packaging images into offline bundle archive: $OutputFile..." -ForegroundColor Cyan
Write-Host "      (This may take 30-60 seconds, archive is ~400 MB)" -ForegroundColor Yellow
docker save -o $OutputFile tcexam-app:latest nginx:alpine mariadb:10.11
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] docker save failed." -ForegroundColor Red
    exit 1
}

$fileInfo = Get-Item $OutputFile
$fileSizeMB = [math]::Round($fileInfo.Length / 1MB, 2)
Write-Host "[SUCCESS] Bundle generated: $OutputFile ($fileSizeMB MB)" -ForegroundColor Green

# 6. Summary instructions
Write-Host "[4/4] Done!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  How to Apply this Update / Patch on the Offline Server:" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  1. Copy the updated file:"
Write-Host "     '$OutputFile'"
Write-Host "     to the 'offline-deployment\' folder on your target server."
Write-Host ""
Write-Host "  2. On the offline server, run:"
Write-Host "     .\apply-patch.bat   (or .\offline-deployment\apply-patch.bat)"
Write-Host "     On Linux: ./apply-patch.sh  (or ./offline-deployment/apply-patch.sh)"
Write-Host ""
Write-Host "  3. The script will take a safety database backup, load the new"
Write-Host "     image, and recreate the app container with ZERO data loss."
Write-Host "============================================================" -ForegroundColor Cyan
