@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

REM ============================================================
REM TCExam — Stop Offline Production Cluster (Windows)
REM ============================================================

echo ============================================================
echo   Stopping TCExam Production Services...
echo ============================================================

docker compose down
if %ERRORLEVEL% EQU 0 (
    echo.
    echo [SUCCESS] TCExam production cluster has been gracefully stopped.
    echo All persistent database records and exam logs remain safe on disk.
) else (
    echo.
    echo [WARNING] Encountered an issue while stopping services.
)
echo ============================================================
echo.
pause
