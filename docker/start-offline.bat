@echo off
REM ============================================================
REM TCExam — Start Offline Server (Windows)
REM ============================================================

IF EXIST "tcexam-offline-bundle.tar" (
    echo Loading offline Docker images from tcexam-offline-bundle.tar...
    docker load -i tcexam-offline-bundle.tar
)

IF NOT EXIST ".env" (
    echo Initializing environment from .env.example...
    copy .env.example .env
)

echo Starting TCExam offline services...
docker compose up -d

echo.
echo ============================================================
echo TCExam is running in offline mode!
echo Candidate Portal:     http://localhost:8080/public/code/index.php
echo Administrator Suite:  http://localhost:8080/admin/code/index.php
echo Default Credentials:  Username: admin  Password: 1234
echo ============================================================
pause
