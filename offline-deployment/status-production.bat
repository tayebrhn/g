@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM TCExam — Production Offline Cluster Status Dashboard (Windows)
REM ============================================================

echo ============================================================
echo   TCExam Production Cluster Status & Health Dashboard
echo ============================================================
echo.

REM 1. Verify Docker is running
docker info >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Docker is not running or not installed.
    pause
    exit /b 1
)

REM 2. Read ports and configuration from .env
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

echo [1/4] Container Services State:
echo ------------------------------------------------------------
docker compose ps
echo.

echo [2/4] Live Resource Utilization:
echo ------------------------------------------------------------
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"
echo.

echo [3/4] Health & Connectivity Probes:
echo ------------------------------------------------------------
REM Probe Web Server
curl --max-time 3 -s -f http://localhost:%APP_PORT%/health.txt >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo   [PASS] Web Proxy (Port %APP_PORT%):   HEALTHY (HTTP 200 OK)
) else (
    curl --max-time 3 -s -f http://localhost:%APP_ALT_PORT%/health.txt >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo   [PASS] Web Proxy (Port %APP_ALT_PORT%): HEALTHY (HTTP 200 OK)
    ) else (
        echo   [FAIL] Web Proxy:             UNREACHABLE (HTTP probe failed)
    )
)

REM Probe Database Server
docker compose exec -T db mariadb-admin ping -u root -proot_secret_pass >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo   [PASS] Database Engine:        HEALTHY (Accepting SQL connections)
) else (
    echo   [FAIL] Database Engine:        UNHEALTHY or STOPPED
)
echo.

echo [4/4] Endpoints & Access URLs:
echo ------------------------------------------------------------
echo   Candidate Portal:  http://localhost:%APP_PORT%/public/code/index.php
echo   Alternative Port:  http://localhost:%APP_ALT_PORT%/public/code/index.php
echo   Admin Suite:       http://localhost:%APP_PORT%/admin/code/index.php
echo   Admin Login:       Username: admin   Password: 1234
echo ============================================================
echo.
pause
