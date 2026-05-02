@echo off
echo Building server...
call "%~dp0\tools\build\build.bat" --wait-on-error
if %ERRORLEVEL% neq 0 (
    echo Build failed!
    pause
    exit /b 1
)
echo Build complete.

:restart
echo Starting server...
start "" "C:\Program Files (x86)\BYOND\bin\dreamdaemon.exe" "%~dp0tgstation.dmb" 3000 -trusted -invisible
echo Server started. Monitoring...
timeout /t 30 /nobreak
goto check_server

:check_server
tasklist /FI "IMAGENAME eq dreamdaemon.exe" 2>NUL | find /I /N "dreamdaemon.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo Server is still running. Checking again in 30 seconds...
    timeout /t 30 /nobreak >nul
    goto check_server
) else (
    echo Server crashed or closed. Force killing any remaining processes...
    taskkill /f /im dreamdaemon.exe >nul 2>&1
    taskkill /f /im dm.exe >nul 2>&1
    echo Waiting 15 seconds before restart...
    timeout /t 15 /nobreak
    goto restart
)
