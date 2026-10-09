@echo off
REM ============================================================
REM TCExam — Apply Offline Production Patch / Update (Root Proxy)
REM Delegates execution to offline-deployment\apply-patch.bat
REM ============================================================

call "%~dp0offline-deployment\apply-patch.bat" %*
exit /b %ERRORLEVEL%
