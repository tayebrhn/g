# ============================================================
# TCExam — Export Offline Docker Bundle (Windows PowerShell)
# ============================================================
Param(
    [string]$OutputFile = "tcexam-offline-bundle.tar"
)

$ErrorActionPreference = "Stop"

Write-Host "==> Verifying Docker images for offline deployment..." -ForegroundColor Cyan
docker image inspect tcexam-app:latest | Out-Null
docker image inspect nginx:alpine | Out-Null
docker image inspect mariadb:10.11 | Out-Null

Write-Host "==> Packaging images into portable archive: $OutputFile" -ForegroundColor Cyan
docker save -o $OutputFile tcexam-app:latest nginx:alpine mariadb:10.11

Write-Host "==> Offline Docker bundle successfully generated: $OutputFile" -ForegroundColor Green
Write-Host ""
Write-Host "==> How to deploy on an offline / air-gapped server:" -ForegroundColor Yellow
Write-Host "    1. Copy '$OutputFile', 'docker-compose.yml', and '.env.example' to the offline server."
Write-Host "    2. On the offline server, run:"
Write-Host "       docker load -i $OutputFile"
Write-Host "       copy .env.example .env"
Write-Host "       docker compose up -d"
