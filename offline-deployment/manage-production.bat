@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

REM ============================================================
REM TCExam — Production Offline Maintainer Console (Windows)
REM ============================================================

:MENU
cls
echo ============================================================
echo           TCExam Production Maintainer Console
echo ============================================================
echo   [1]  Start Cluster          - Boot services and verify health
echo   [2]  Stop Cluster           - Gracefully halt all containers
echo   [3]  Restart Cluster        - Cycle containers and reload
echo   [4]  Cluster Status         - Health probes and metrics
echo   [5]  Scale App Replicas     - Load-balance FastCGI workers
echo   [6]  Seed Showcase Data     - Populate demo users and exams
echo   [7]  Backup Database        - Snapshot database to backups/
echo   [8]  Restore Database       - Restore from existing backup
echo   [9]  Follow Live Logs       - Tail container output (Ctrl+C to quit)
echo   [10] Apply Patch/Update     - Upgrade container images safely
echo   [0]  Exit Console
echo ============================================================

set /p OPTION="Select option [0-10]: "

if "%OPTION%"=="1" (
    call start-production.bat
    goto MENU
)
if "%OPTION%"=="2" (
    call stop-production.bat
    goto MENU
)
if "%OPTION%"=="3" (
    call restart-production.bat
    goto MENU
)
if "%OPTION%"=="4" (
    call status-production.bat
    goto MENU
)
if "%OPTION%"=="5" (
    call scale-production.bat
    goto MENU
)
if "%OPTION%"=="6" (
    call seed-database.bat
    goto MENU
)
if "%OPTION%"=="7" (
    call backup-database.bat
    goto MENU
)
if "%OPTION%"=="8" (
    call restore-database.bat
    goto MENU
)
if "%OPTION%"=="9" (
    echo [INFO] Following logs from all containers. Press Ctrl+C to return to menu.
    docker compose logs -f
    goto MENU
)
if "%OPTION%"=="10" (
    call apply-patch.bat
    goto MENU
)
if "%OPTION%"=="0" (
    echo Exiting console.
    exit /b 0
)

echo [ERROR] Invalid selection.
pause
goto MENU
