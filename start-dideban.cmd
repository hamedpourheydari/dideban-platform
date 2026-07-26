@echo off
setlocal
set "PROJECT_DIR=C:\Users\Fanpars1\Desktop\dideban-clean"

cd /d "%PROJECT_DIR%"
if errorlevel 1 (
    echo [ERROR] Project directory not found:
    echo %PROJECT_DIR%
    pause
    exit /b 1
)

echo Starting Dideban from:
cd
echo.

node camera.js

echo.
echo Dideban stopped with exit code %ERRORLEVEL%.
pause

