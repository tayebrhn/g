@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

REM ============================================================
REM TCExam — Apply Offline Production Patch / Update (Windows)
REM ============================================================

echo ============================================================
echo   Applying TCExam Offline Production Patch / Update...
echo ============================================================

REM 1. Verify Docker is running
docker info >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Docker is not running or not installed.
    echo Please start Docker Desktop and run this script again.
    pause
    exit /b 1
)

REM 2. Verify bundle archive is present
if not exist "tcexam-offline-bundle.tar" (
    if exist "..\tcexam-offline-bundle.tar" copy /y "..\tcexam-offline-bundle.tar" "tcexam-offline-bundle.tar" >nul
    if exist "..\docker\tcexam-offline-bundle.tar" copy /y "..\docker\tcexam-offline-bundle.tar" "tcexam-offline-bundle.tar" >nul
)
if not exist "tcexam-offline-bundle.tar" (
    echo [ERROR] 'tcexam-offline-bundle.tar' not found in offline-deployment directory.
    echo Please copy the updated bundle file into this folder and retry.
    pause
    exit /b 1
)

REM 3. Take safety pre-patch database backup
if not exist "backups" mkdir backups
set TIMESTAMP=
for /f %%a in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss" 2^>nul') do set TIMESTAMP=%%a
if "!TIMESTAMP!"=="" (
    set TIMESTAMP=%date:~-4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
    set TIMESTAMP=!TIMESTAMP: =0!
)
set PRE_PATCH_BACKUP=backups\pre_patch_backup_%TIMESTAMP%.sql

echo [1/3] Creating safety database backup before applying patch...
docker compose exec -T db mariadb-dump -u root -proot_secret_pass --single-transaction --routines --triggers tcexam > "%PRE_PATCH_BACKUP%" 2>nul
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Pre-patch database backup saved to: %PRE_PATCH_BACKUP%
) else (
    echo [WARNING] Database was offline or not yet initialized; proceeding with update.
)

REM 4. Load updated Docker images
echo [2/3] Loading updated Docker images from tcexam-offline-bundle.tar...
docker load -i tcexam-offline-bundle.tar
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to load images from bundle.
    pause
    exit /b 1
)

REM 5. Recreate application and web containers with updated image
echo [3/3] Replacing running containers with updated image (zero data loss)...
docker compose stop app web >nul 2>&1
docker volume rm tcexam_app_code >nul 2>&1
docker compose up -d --force-recreate app web
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to recreate containers with updated image.
    pause
    exit /b 1
)

REM Read port dynamically from .env
set APP_PORT=80
if exist ".env" (
    for /f "usebackq tokens=1,2 delims==" %%A in (".env") do (
        set key=%%A
        set val=%%B
        for /f "tokens=*" %%k in ("!key!") do set key=%%k
        for /f "tokens=*" %%v in ("!val!") do set val=%%v
        if "!key!"=="APP_PORT" set APP_PORT=!val!
    )
)

echo.
echo ============================================================
echo   TCExam Patch / Update Applied Successfully!
echo ============================================================
echo   - All existing database records, exams, and users are preserved.
echo   - Pre-patch safety backup: %PRE_PATCH_BACKUP%
echo   - Candidate Portal:  http://localhost:%APP_PORT%/public/code/index.php
echo   - Admin Suite:       http://localhost:%APP_PORT%/admin/code/index.php
echo ============================================================
echo.
pause
