@echo off
setlocal EnableDelayedExpansion

:: Create timestamp for filename
set "DATETIME=%date:~-4%-%date:~3,2%-%date:~0,2%_%time:~0,2%-%time:~3,2%"
set "OUTPUT=Gaming_System_Analysis_%DATETIME%.txt"

:: Create report header
echo ===================================== > "%OUTPUT%"
echo      GAMING SYSTEM ANALYSIS REPORT     >> "%OUTPUT%"
echo ===================================== >> "%OUTPUT%"
echo Generated: %date% %time%               >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: System Information
echo === SYSTEM INFORMATION === >> "%OUTPUT%"
systeminfo | findstr /C:"OS" /C:"System Manufacturer" /C:"System Model" /C:"System Type" /C:"Processor" /C:"Memory" >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: CPU Information
echo === CPU INFORMATION === >> "%OUTPUT%"
for /f "tokens=2 delims==" %%a in ('wmic cpu get name /value') do (
    echo CPU: %%a >> "%OUTPUT%"
)
for /f "tokens=2 delims==" %%a in ('wmic cpu get numberofcores /value') do (
    echo Cores: %%a >> "%OUTPUT%"
)
for /f "tokens=2 delims==" %%a in ('wmic cpu get maxclockspeed /value') do (
    echo Max Speed (MHz): %%a >> "%OUTPUT%"
)
echo. >> "%OUTPUT%"

:: GPU Information
echo === GPU INFORMATION === >> "%OUTPUT%"
for /f "tokens=2 delims==" %%a in ('wmic path win32_VideoController get name /value') do (
    echo GPU Name: %%a >> "%OUTPUT%"
)
for /f "tokens=2 delims==" %%a in ('wmic path win32_VideoController get driverversion /value') do (
    echo Driver Version: %%a >> "%OUTPUT%"
)
echo. >> "%OUTPUT%"

:: Memory Information
echo === MEMORY INFORMATION === >> "%OUTPUT%"
for /f "tokens=2 delims==" %%a in ('wmic ComputerSystem get TotalPhysicalMemory /value') do (
    set /a "RAM=%%a/1024/1024/1024"
    echo Total RAM: !RAM! GB >> "%OUTPUT%"
)
echo. >> "%OUTPUT%"

:: Disk Information
echo === STORAGE INFORMATION === >> "%OUTPUT%"
wmic diskdrive get model,size >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: Network Information
echo === NETWORK INFORMATION === >> "%OUTPUT%"
ipconfig | findstr /C:"IPv4" /C:"Subnet" /C:"Default Gateway" >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: Gaming Services Status
echo === GAMING SERVICES === >> "%OUTPUT%"
echo Steam Client Service Status: >> "%OUTPUT%"
sc query "Steam Client Service" >> "%OUTPUT%" 2>nul
echo. >> "%OUTPUT%"
echo Xbox Services Status: >> "%OUTPUT%"
sc query "XboxNetApiSvc" >> "%OUTPUT%" 2>nul
sc query "XblAuthManager" >> "%OUTPUT%" 2>nul
echo. >> "%OUTPUT%"

:: DirectX Version
echo === DIRECTX INFORMATION === >> "%OUTPUT%"
dxdiag /t dxdiag_temp.txt >nul
timeout /t 3 /nobreak >nul
findstr "DirectX Version" dxdiag_temp.txt >> "%OUTPUT%" 2>nul
del dxdiag_temp.txt >nul 2>&1
echo. >> "%OUTPUT%"

:: Power Plan
echo === POWER PLAN === >> "%OUTPUT%"
powercfg /list >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: Gaming Performance Test
echo === NETWORK GAMING PERFORMANCE === >> "%OUTPUT%"
echo Testing connection to gaming servers... >> "%OUTPUT%"
echo Steam Servers: >> "%OUTPUT%"
ping -n 4 steampowered.com | findstr "Average" >> "%OUTPUT%" 2>nul
echo Epic Games: >> "%OUTPUT%"
ping -n 4 epicgames.com | findstr "Average" >> "%OUTPUT%" 2>nul
echo. >> "%OUTPUT%"

:: Display Settings
echo === DISPLAY SETTINGS === >> "%OUTPUT%"
for /f "tokens=2 delims==" %%a in ('wmic path win32_VideoController get CurrentRefreshRate /value') do (
    echo Refresh Rate: %%a Hz >> "%OUTPUT%"
)
for /f "tokens=2 delims==" %%a in ('wmic path win32_VideoController get VideoModeDescription /value') do (
    echo Resolution: %%a >> "%OUTPUT%"
)
echo. >> "%OUTPUT%"

:: Running Game Processes
echo === ACTIVE GAMING PROCESSES === >> "%OUTPUT%"
tasklist | findstr /I "steam epic galaxy battle" >> "%OUTPUT%" 2>nul
echo. >> "%OUTPUT%"

:: Audio Devices
echo === AUDIO DEVICES === >> "%OUTPUT%"
for /f "tokens=2 delims==" %%a in ('wmic sounddev get name /value') do (
    echo %%a >> "%OUTPUT%"
)
echo. >> "%OUTPUT%"

:: Report Complete
echo ===================================== >> "%OUTPUT%"
echo Report generation complete! >> "%OUTPUT%"
echo File saved as: %OUTPUT%
echo.
echo Press any key to view the report...
pause >nul
start notepad "%OUTPUT%"