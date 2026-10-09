@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

REM Ensure backup directory exists
if not exist "backups" mkdir backups

REM Get current timestamp (YYYYMMDD_HHMMSS)
set TIMESTAMP=
for /f %%a in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss" 2^>nul') do set TIMESTAMP=%%a
if "!TIMESTAMP!"=="" (
    set TIMESTAMP=%date:~-4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
    set TIMESTAMP=!TIMESTAMP: =0!
)
set BACKUP_FILE=backups\tcexam_backup_%TIMESTAMP%.sql

echo ============================================================
echo   Backing up TCExam database to %BACKUP_FILE%...
echo ============================================================

docker compose exec -T db mariadb-dump -u root -proot_secret_pass --single-transaction --routines --triggers tcexam > "%BACKUP_FILE%"

if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Backup completed successfully!
    echo File: %BACKUP_FILE%
) else (
    echo [ERROR] Database backup failed. Ensure containers are running.
)
echo ============================================================
pause
