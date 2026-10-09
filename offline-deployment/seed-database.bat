@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

REM ============================================================
REM TCExam — 1-Click Showcase Database Seeder (Windows)
REM ============================================================

echo ============================================================
echo   TCExam Showcase Database Seeding Utility
echo ============================================================

REM 1. Verify Docker is running
docker info >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Docker is not running or not installed.
    pause
    exit /b 1
)

REM 2. Verify database container is online
docker compose exec -T db mariadb-admin ping -u root -proot_secret_pass >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Database container 'db' is not running or not accepting connections.
    echo Please start the server using start-production.bat first.
    pause
    exit /b 1
)

REM 3. Locate showcase seed SQL files
set SEED_SQL=
if exist "..\seed_data\showcase_seed.sql" set SEED_SQL=..\seed_data\showcase_seed.sql
if exist "seed_data\showcase_seed.sql" set SEED_SQL=seed_data\showcase_seed.sql
if exist "showcase_seed.sql" set SEED_SQL=showcase_seed.sql

if "!SEED_SQL!"=="" (
    echo [INFO] Extracting showcase seed from application container...
    docker compose exec -T app cat /var/www/html/seed_data/showcase_seed.sql > showcase_seed_temp.sql 2>nul
    if exist "showcase_seed_temp.sql" (
        set SEED_SQL=showcase_seed_temp.sql
    ) else (
        echo [ERROR] showcase_seed.sql could not be found.
        pause
        exit /b 1
    )
)

set SEED_RES_SQL=
if exist "..\seed_data\showcase_results_seed.sql" set SEED_RES_SQL=..\seed_data\showcase_results_seed.sql
if exist "seed_data\showcase_results_seed.sql" set SEED_RES_SQL=seed_data\showcase_results_seed.sql
if exist "showcase_results_seed.sql" set SEED_RES_SQL=showcase_results_seed.sql

if "!SEED_RES_SQL!"=="" (
    docker compose exec -T app cat /var/www/html/seed_data/showcase_results_seed.sql > showcase_res_temp.sql 2>nul
    if exist "showcase_res_temp.sql" (
        set SEED_RES_SQL=showcase_res_temp.sql
    )
)

REM 4. Determine whether to include results
set LOAD_RESULTS=1
if "%1"=="--curriculum-only" set LOAD_RESULTS=0
if "%1"=="--with-results" set LOAD_RESULTS=1
if "%1"=="" (
    set /p USER_CHOICE="Load simulated exam attempts & analytics results? [Y/n]: "
    if /i "!USER_CHOICE!"=="n" set LOAD_RESULTS=0
)

echo [INFO] Loading showcase curriculum, users, and certification exams...
docker compose exec -T db mariadb -u root -proot_secret_pass tcexam < "!SEED_SQL!"
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to execute showcase seed into database.
    if exist "showcase_seed_temp.sql" del "showcase_seed_temp.sql"
    if exist "showcase_res_temp.sql" del "showcase_res_temp.sql"
    pause
    exit /b 1
)

if "!LOAD_RESULTS!"=="1" if not "!SEED_RES_SQL!"=="" (
    echo [INFO] Loading simulated candidate exam attempts, answer logs, and scores...
    docker compose exec -T db mariadb -u root -proot_secret_pass tcexam < "!SEED_RES_SQL!"
    if %ERRORLEVEL% NEQ 0 (
        echo [WARNING] Failed to load simulated exam results.
    ) else (
        echo [INFO] Exam attempts and analytics loaded successfully.
    )
)

if exist "showcase_seed_temp.sql" del "showcase_seed_temp.sql"
if exist "showcase_res_temp.sql" del "showcase_res_temp.sql"

echo.
echo ============================================================
echo   [SUCCESS] Showcase Database Seeding Completed!
echo ============================================================
echo   Populated Entities:
echo     - 9 User Groups (Academic Registry, Proctors, Cohorts)
echo     - 21 Users across all permission tiers (Password: Password123!)
echo     - 3 Modules (Web Engineering, Cybersecurity, DevOps)
echo     - 7 Subjects & 42 Questions (Single & Multiple Choice)
echo     - 3 Pre-configured Certification Exams:
echo         * CS101: Web & Database Engineering Certification
echo         * SEC201: Cybersecurity Fundamentals & Network Defense
echo         * OPS301: Cloud Infrastructure & DevOps Readiness
if "!LOAD_RESULTS!"=="1" (
echo     - 14 Completed Student Attempts with Realistic Bell Curve
echo     - 3 Ready-to-Take Candidate Sessions (Live Exam Execution)
echo     - Full Analytics in Results -^> All Users & User Scorecards
)
echo ============================================================
echo.
pause

