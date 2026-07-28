@echo off
setlocal
cd /d "%~dp0"
if exist "%~dp0runtime\node.exe" (
  set "NODE_EXE=%~dp0runtime\node.exe"
) else (
  set "NODE_EXE=node.exe"
)
if not exist "%ProgramData%\Dideban\logs" mkdir "%ProgramData%\Dideban\logs"
"%NODE_EXE%" "%~dp0camera.js" >> "%ProgramData%\Dideban\logs\service-output.log" 2>&1
endlocal
