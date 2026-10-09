@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

REM ============================================================
REM TCExam — Production Database Restoration Utility (Windows)
REM ============================================================

echo ============================================================
echo   TCExam Production Database Restoration Utility
echo ============================================================

REM 1. Verify Docker is running
docker info >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Docker is not running or not installed.
    pause
    exit /b 1
)

REM 2. Verify backups directory exists and has files
if not exist "backups" (
    echo [ERROR] No 'backups' directory found.
    echo Run backup-database.bat to create a backup first.
    pause
    exit /b 1
)

REM 3. List available backup files
echo Available Database Backups in 'backups/':
echo ------------------------------------------------------------
set COUNT=0
for /f "delims=" %%F in ('dir /b /o-d backups\*.sql 2^>nul') do (
    set /a COUNT+=1
    set "FILE_!COUNT!=%%F"
    echo   [!COUNT!] %%F
)

if %COUNT% EQU 0 (
    echo [ERROR] No .sql backup files found in 'backups/' directory.
    pause
    exit /b 1
)
echo ------------------------------------------------------------

set /p CHOICE="Select backup number to restore [1-%COUNT%]: "
if "!CHOICE!"=="" (
    echo [INFO] Restoration cancelled.
    pause
    exit /b 0
)

set "SELECTED_FILE=!FILE_%CHOICE%!"
if "!SELECTED_FILE!"=="" (
    echo [ERROR] Invalid selection number.
    pause
    exit /b 1
)

echo.
echo [WARNING] You are about to restore: backups\!SELECTED_FILE!
echo Existing data in the database will be replaced.
set /p CONFIRM="Are you sure you want to proceed? [y/N]: "
if /i not "!CONFIRM!"=="y" (
    echo [INFO] Restoration cancelled by user.
    pause
    exit /b 0
)

REM 4. Take a safety snapshot before restore
set TIMESTAMP=
for /f %%a in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss" 2^>nul') do set TIMESTAMP=%%a
if "!TIMESTAMP!"=="" (
    set TIMESTAMP=%date:~-4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
    set TIMESTAMP=!TIMESTAMP: =0!
)
set SAFETY_BACKUP=backups\pre_restore_safety_%TIMESTAMP%.sql

echo [INFO] Creating pre-restore safety backup: %SAFETY_BACKUP%...
docker compose exec -T db mariadb-dump -u root -proot_secret_pass --single-transaction --routines --triggers tcexam > "%SAFETY_BACKUP%" 2>nul

echo [INFO] Restoring database from: backups\!SELECTED_FILE!...
docker compose exec -T db mariadb -u root -proot_secret_pass tcexam < "backups\!SELECTED_FILE!"
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Database restoration failed.
    echo Your previous state was saved to: %SAFETY_BACKUP%
    pause
    exit /b 1
)

echo.
echo ============================================================
echo   [SUCCESS] Database Restored Successfully!
echo ============================================================
echo   Restored File:       backups\!SELECTED_FILE!
echo   Safety Snapshot:     %SAFETY_BACKUP%
echo ============================================================
echo.
pause
