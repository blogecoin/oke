@echo off
chcp 65001 >nul
echo ============================================
echo      SETUP WINDOWS SCHEDULED TASK
echo ============================================
echo.
echo 📅 Setting up daily automated task...
echo.

cd /d "%~dp0"

python cron_job_setup.py

echo.
echo ============================================
echo         SETUP COMPLETED
echo ============================================
echo.
pause