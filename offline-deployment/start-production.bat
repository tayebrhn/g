@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM TCExam — Production Offline Server Launcher (Windows)
REM ============================================================

echo ============================================================
echo   Starting TCExam Production Offline Server...
echo ============================================================

REM 1. Verify Docker is installed and running
docker info >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Docker is not running or not installed.
    echo Please start Docker Desktop and run this script again.
    echo.
    pause
    exit /b 1
)

REM 2. Load offline images from bundle archive if present
if exist "tcexam-offline-bundle.tar" (
    docker image inspect tcexam-app:latest >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo [INFO] Loading offline Docker images from tcexam-offline-bundle.tar...
        docker load -i tcexam-offline-bundle.tar
        if %ERRORLEVEL% NEQ 0 (
            echo [ERROR] Failed to load Docker images from bundle.
            pause
            exit /b 1
        )
    ) else (
        echo [INFO] Offline Docker images already present in Docker cache.
    )
)

REM 3. Initialize production environment file
if not exist ".env" (
    echo [INFO] Initializing .env configuration from .env.example...
    copy ".env.example" ".env" >nul
)

REM Read ports dynamically from .env
set APP_PORT=80
set APP_ALT_PORT=8080
for /f "usebackq tokens=1,2 delims==" %%A in (".env") do (
    set key=%%A
    set val=%%B
    for /f "tokens=*" %%k in ("!key!") do set key=%%k
    for /f "tokens=*" %%v in ("!val!") do set val=%%v
    if "!key!"=="APP_PORT" set APP_PORT=!val!
    if "!key!"=="APP_ALT_PORT" set APP_ALT_PORT=!val!
)

REM 4. Launch containers
echo [INFO] Starting TCExam production cluster on ports %APP_PORT% and %APP_ALT_PORT%...
docker compose up -d
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to start TCExam services.
    pause
    exit /b 1
)

REM 5. Wait for web server to become ready
echo [INFO] Waiting for web server readiness on port %APP_PORT%...
set TIMEOUT=30
:WAIT_LOOP
curl --max-time 2 -s -f http://localhost:%APP_PORT%/health.txt >nul 2>&1
if %ERRORLEVEL% EQU 0 goto READY

curl --max-time 2 -s -f http://localhost:%APP_ALT_PORT%/health.txt >nul 2>&1
if %ERRORLEVEL% EQU 0 goto READY

    ping 127.0.0.1 -n 3 >nul
set /a TIMEOUT-=2
if %TIMEOUT% LEQ 0 goto READY
goto WAIT_LOOP

:READY
set DISPLAY_PORT_A=
if "%APP_PORT%"=="80" (
    set URL_PRIMARY=http://localhost/public/code/index.php
    set URL_ADMIN=http://localhost/admin/code/index.php
    set URL_LAN=http://^<SERVER_IP^>/public/code/index.php
) else (
    set URL_PRIMARY=http://localhost:%APP_PORT%/public/code/index.php
    set URL_ADMIN=http://localhost:%APP_PORT%/admin/code/index.php
    set URL_LAN=http://^<SERVER_IP^>:%APP_PORT%/public/code/index.php
)

echo.
echo ============================================================
echo   TCExam Production Offline Server is ONLINE!
echo ============================================================
echo   Candidate Portal (Port %APP_PORT%):    !URL_PRIMARY!
echo   Alternative Port (Port %APP_ALT_PORT%):  http://localhost:%APP_ALT_PORT%/public/code/index.php
echo   Administrator Suite:           !URL_ADMIN!
echo   Default Credentials:           Username: admin   Password: 1234
echo ============================================================
echo   LAN / Network Exam Delivery:
echo     Computers in this exam room can connect directly to:
echo     !URL_LAN!
echo ============================================================
echo   Management:
echo     Stop server:   stop-production.bat
echo     Backup data:   backup-database.bat
echo     Apply patch:   apply-patch.bat
echo     View logs:     docker compose logs -f
echo ============================================================
echo.
pause
