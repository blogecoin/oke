@echo off
chcp 65001 >nul
echo ============================================
echo         DAILY COMMIT SCRIPT
echo ============================================
echo.
echo 🚀 Running daily commit...
echo.

cd /d "%~dp0"

python daily_commit.py

echo.
echo ============================================
echo           SCRIPT COMPLETED
echo ============================================
echo.
pause