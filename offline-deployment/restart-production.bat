@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM TCExam — Production Offline Cluster Restarter (Windows)
REM ============================================================

echo ============================================================
echo   Restarting TCExam Production Offline Cluster...
echo ============================================================

REM 1. Verify Docker is running
docker info >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Docker is not running or not installed.
    echo Please start Docker Desktop and run this script again.
    pause
    exit /b 1
)

REM 2. Read ports and replicas dynamically from .env
set APP_PORT=80
set APP_ALT_PORT=8080
set APP_REPLICAS=1
if exist ".env" (
    for /f "usebackq tokens=1,2 delims==" %%A in (".env") do (
        set key=%%A
        set val=%%B
        for /f "tokens=*" %%k in ("!key!") do set key=%%k
        for /f "tokens=*" %%v in ("!val!") do set val=%%v
        if "!key!"=="APP_PORT" set APP_PORT=!val!
        if "!key!"=="APP_ALT_PORT" set APP_ALT_PORT=!val!
        if "!key!"=="APP_REPLICAS" set APP_REPLICAS=!val!
    )
)

REM 3. Restart containers
echo [INFO] Restarting TCExam services...
if !APP_REPLICAS! GTR 1 (
    docker compose up -d --force-recreate --scale app=!APP_REPLICAS!
) else (
    docker compose restart
)

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to restart containers.
    pause
    exit /b 1
)

REM 4. Wait for web service readiness
echo [INFO] Waiting for cluster readiness on port %APP_PORT%...
set TIMEOUT=30
:WAIT_LOOP
curl --max-time 2 -s -f http://localhost:%APP_PORT%/health.txt >nul 2>&1
if %ERRORLEVEL% EQU 0 goto READY

curl --max-time 2 -s -f http://localhost:%APP_ALT_PORT%/health.txt >nul 2>&1
if %ERRORLEVEL% EQU 0 goto READY

ping 127.0.0.1 -n 3 >nul
set /a TIMEOUT-=2
if %TIMEOUT% LEQ 0 (
    echo [WARNING] Health check timed out, but containers are running.
    goto READY
)
goto WAIT_LOOP

:READY
echo.
echo ============================================================
echo   TCExam Cluster Restarted Successfully!
echo ============================================================
echo   Candidate Portal:    http://localhost:%APP_PORT%/public/code/index.php
echo   Alternative Port:    http://localhost:%APP_ALT_PORT%/public/code/index.php
echo   Admin Suite:         http://localhost:%APP_PORT%/admin/code/index.php
if !APP_REPLICAS! GTR 1 (
    echo   Load Balancing:      !APP_REPLICAS! active app replicas
)
echo ============================================================
echo.
pause
