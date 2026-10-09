@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

REM ============================================================
REM TCExam — Horizontal Scale & Load Balancing (Windows)
REM ============================================================

echo ============================================================
echo   TCExam Application Replica Scaling & Load Balancing
echo ============================================================

REM 1. Verify Docker is running
docker info >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Docker is not running or not installed.
    pause
    exit /b 1
)

REM 2. Read requested replica count
set REPLICAS=%1
if "!REPLICAS!"=="" (
    set /p REPLICAS="Enter desired number of app worker replicas [1-8]: "
)

REM Sanitize input
if "!REPLICAS!"=="" set REPLICAS=2
if !REPLICAS! LSS 1 (
    echo [ERROR] Replicas must be at least 1.
    pause
    exit /b 1
)
if !REPLICAS! GTR 16 (
    echo [ERROR] Maximum supported replicas is 16.
    pause
    exit /b 1
)

echo [INFO] Scaling application service to !REPLICAS! replicas...
docker compose up -d --scale app=!REPLICAS!
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Scaling failed.
    pause
    exit /b 1
)

echo [INFO] Verifying updated cluster state...
ping 127.0.0.1 -n 3 >nul
docker compose ps app

echo.
echo ============================================================
echo   [SUCCESS] Scaled to !REPLICAS! Application Replicas!
echo ============================================================
echo   Nginx is now actively load-balancing incoming requests
echo   across all !REPLICAS! container instances with automatic
echo   failover on timeout or error.
echo ============================================================
echo.
pause
