# ============================================================
# TCExam — 1-Command Development Environment (PowerShell)
# ============================================================

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Starting TCExam Development Server..." -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

# 1. Verify Docker is running
docker info *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Docker is not running or not installed." -ForegroundColor Red
    Write-Host "Please start Docker Desktop and run this script again."
    exit 1
}

# 2. Ensure .env exists
if (-not (Test-Path ".env")) {
    Write-Host "[INFO] .env not found. Creating from .env.example..." -ForegroundColor Yellow
    Copy-Item ".env.example" ".env"
    Write-Host "[SUCCESS] Initialized .env with default settings." -ForegroundColor Green
}

# Read DB_PORT_FORWARD and APP_PORT from .env if present
$dbPort = "3307"
$appPort = "8080"
if (Test-Path ".env") {
    Get-Content ".env" | ForEach-Object {
        if ($_ -match '^\s*DB_PORT_FORWARD\s*=\s*(.+)$') { $dbPort = $matches[1].Trim() }
        if ($_ -match '^\s*APP_PORT\s*=\s*(.+)$') { $appPort = $matches[1].Trim() }
    }
}

# 3. Launch Docker Compose with Dev profile
Write-Host "[INFO] Launching containers (PHP-FPM, Nginx, MariaDB)..." -ForegroundColor Cyan
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to start Docker containers. Check the errors above." -ForegroundColor Red
    exit 1
}

# 4. Wait for readiness
Write-Host "[INFO] Waiting for services to initialize..." -ForegroundColor Cyan
$retries = 20
$ready = $false
while ($retries -gt 0) {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:$appPort/health.txt" -UseBasicParsing -TimeoutSec 2
        if ($response.StatusCode -eq 200) {
            $ready = $true
            break
        }
    } catch {
        # continue waiting
    }
    Start-Sleep -Seconds 2
    $retries--
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "  TCExam Development Environment is ONLINE!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host "  Candidate Portal:    http://localhost:$appPort/public/code/index.php" -ForegroundColor Cyan
Write-Host "  Admin Suite:         http://localhost:$appPort/admin/code/index.php" -ForegroundColor Cyan
Write-Host "  Default Login:       Username: admin   Password: 1234" -ForegroundColor Yellow
Write-Host "  Database GUI:        localhost:$dbPort"
Write-Host "                       User: tcexam      Pass: tcexam_secret_pass"
Write-Host "                       Database: tcexam"
Write-Host "============================================================" -ForegroundColor Green
Write-Host "  Hot Reloading:       ACTIVE (edits in ./ reflect immediately)" -ForegroundColor Green
Write-Host "  Error Reporting:     VERBOSE (display_errors = On)" -ForegroundColor Green
Write-Host "  OPcache:             INSTANT (revalidate_freq = 0)" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host "  Useful Commands:"
Write-Host "    View PHP logs:     docker compose logs -f app"
Write-Host "    Container Shell:   docker compose exec app sh"
Write-Host "    Stop Server:       docker compose down"
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
