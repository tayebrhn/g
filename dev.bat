@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM TCExam — 1-Command Development Environment (Windows)
REM ============================================================

echo ============================================================
echo   Starting TCExam Development Server...
echo ============================================================

REM Check for subcommands
if /i "%1"=="stop" (
    docker compose -f docker-compose.yml -f docker-compose.dev.yml down
    echo TCExam development containers stopped.
    exit /b 0
)
if /i "%1"=="down" (
    docker compose -f docker-compose.yml -f docker-compose.dev.yml down
    echo TCExam development containers stopped.
    exit /b 0
)
if /i "%1"=="restart" (
    docker compose -f docker-compose.yml -f docker-compose.dev.yml restart
    echo TCExam development containers restarted.
    exit /b 0
)
if /i "%1"=="status" (
    docker compose -f docker-compose.yml -f docker-compose.dev.yml ps
    exit /b 0
)
if /i "%1"=="seed" (
    echo Seeding showcase curriculum, users, and exams...
    docker compose -f docker-compose.yml -f docker-compose.dev.yml exec -T db mariadb -u root -proot_secret_pass tcexam < seed_data\showcase_seed.sql
    echo Showcase seed complete!
    exit /b 0
)
if /i "%1"=="scale" (
    set REPL=%2
    if "!REPL!"=="" set REPL=2
    echo Scaling app workers to !REPL! replicas...
    docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d --scale app=!REPL!
    exit /b 0
)

REM 1. Verify Docker is installed and running
docker info >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Docker is not running or not installed.
    echo Please start Docker Desktop and run this script again.
    echo.
    pause
    exit /b 1
)

REM 2. Ensure .env exists
if not exist ".env" (
    echo [INFO] .env not found. Creating from .env.example...
    copy ".env.example" ".env" >nul
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] Failed to copy .env.example to .env
        pause
        exit /b 1
    )
    echo [SUCCESS] Initialized .env with default development settings.
)

REM Read ports dynamically from .env
set APP_PORT=80
set DB_PORT_FORWARD=3307
for /f "usebackq tokens=1,2 delims==" %%A in (".env") do (
    set key=%%A
    set val=%%B
    for /f "tokens=*" %%k in ("!key!") do set key=%%k
    for /f "tokens=*" %%v in ("!val!") do set val=%%v
    if "!key!"=="APP_PORT" set APP_PORT=!val!
    if "!key!"=="DB_PORT_FORWARD" set DB_PORT_FORWARD=!val!
)

REM 3. Launch Docker Compose with Development overrides
echo [INFO] Launching containers (PHP-FPM, Nginx, MariaDB)...
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to start Docker containers.
    pause
    exit /b 1
)

REM 4. Wait for database and web service readiness
echo [INFO] Waiting for services to initialize on port %APP_PORT%...
set TIMEOUT=30
:WAIT_LOOP
curl --max-time 2 -s -f http://localhost:%APP_PORT%/health.txt >nul 2>&1
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
echo   TCExam Development Environment is ONLINE!
echo ============================================================
echo   Candidate Portal:    http://localhost:%APP_PORT%/public/code/index.php
echo   Admin Suite:         http://localhost:%APP_PORT%/admin/code/index.php
echo   Default Login:       Username: admin   Password: 1234
echo   Database GUI:        localhost:%DB_PORT_FORWARD%
echo                        User: tcexam      Pass: tcexam_secret_pass
echo                        Database: tcexam
echo ============================================================
echo   Hot Reloading:       ACTIVE (edits in ./ reflect immediately)
echo   Error Reporting:     VERBOSE (display_errors = On)
echo   OPcache:             INSTANT (revalidate_freq = 0)
echo ============================================================
echo   Useful Commands:
echo     View PHP logs:     docker compose logs -f app
echo     Container Shell:   docker compose exec app sh
echo     Stop Server:       docker compose down
echo ============================================================
echo.
pause
