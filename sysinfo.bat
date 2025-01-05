@echo off
setlocal EnableDelayedExpansion

:: Batch file to gather comprehensive gaming-relevant system information
title Gaming System Analysis Tool

:: Set output file with timestamp
set "timestamp=%date:~-4%-%date:~3,2%-%date:~0,2%_%time:~0,2%-%time:~3,2%"
set "OUTPUT=Gaming_System_Analysis_%timestamp%.txt"

:: Create header
echo ================================== >> %OUTPUT%
echo    GAMING SYSTEM ANALYSIS REPORT    >> %OUTPUT%
echo ================================== >> %OUTPUT%
echo Generated on: %date% at %time% >> %OUTPUT%
echo. >> %OUTPUT%

:: Critical Gaming Components
echo ### CRITICAL GAMING COMPONENTS ### >> %OUTPUT%
echo ================================== >> %OUTPUT%

:: GPU Information (Enhanced)
echo [GPU DETAILS] >> %OUTPUT%
echo --------------- >> %OUTPUT%
wmic path win32_videocontroller get name,adapterram,driverversion,videoprocessor,videomemorytype,maxrefreshrate,currentrefreshrate,videomodedescription /format:list >> %OUTPUT%
echo. >> %OUTPUT%

:: CPU Information (Enhanced)
echo [CPU DETAILS] >> %OUTPUT%
echo --------------- >> %OUTPUT%
wmic cpu get name,numberofcores,numberoflogicalprocessors,maxclockspeed,l2cachesize,l3cachesize,virtualizationfirmwareenabled /format:list >> %OUTPUT%
echo. >> %OUTPUT%

:: RAM Information (Enhanced)
echo [MEMORY DETAILS] >> %OUTPUT%
echo ----------------- >> %OUTPUT%
wmic memorychip get capacity,speed,memorytype,manufacturer,configuredclockspeed /format:list >> %OUTPUT%
wmic pagefile get filename,initialsize,maxsize /format:list >> %OUTPUT%
echo. >> %OUTPUT%

:: Storage Performance
echo [STORAGE PERFORMANCE] >> %OUTPUT%
echo --------------------- >> %OUTPUT%
wmic diskdrive get model,size,mediatype /format:list >> %OUTPUT%
wmic volume get driveletter,capacity,freespace,filesystem /format:list >> %OUTPUT%
echo. >> %OUTPUT%

:: Gaming-Specific Services
echo ### GAMING SERVICES STATUS ### >> %OUTPUT%
echo ============================= >> %OUTPUT%
echo [GAMING SERVICES] >> %OUTPUT%
sc query "steam client service" >> %OUTPUT%
sc query "EpicOnlineServices" >> %OUTPUT%
sc query "XboxNetApiSvc" >> %OUTPUT%
sc query "XblAuthManager" >> %OUTPUT%
sc query "XboxGipSvc" >> %OUTPUT%
echo. >> %OUTPUT%

:: DirectX Diagnostic (Enhanced)
echo ### DIRECTX DIAGNOSTIC ### >> %OUTPUT%
echo ========================= >> %OUTPUT%
dxdiag /t dxdiag_temp.txt
timeout /t 5 /nobreak >nul
type dxdiag_temp.txt | findstr /i "DirectX Version Feature Level Driver Date/Size" >> %OUTPUT%
type dxdiag_temp.txt | findstr /i "Display Memory" >> %OUTPUT%
del dxdiag_temp.txt
echo. >> %OUTPUT%

:: Power Plan Analysis
echo ### POWER SETTINGS ### >> %OUTPUT%
echo ==================== >> %OUTPUT%
powercfg /list >> %OUTPUT%
powercfg /query SCHEME_BALANCED >> %OUTPUT%
echo. >> %OUTPUT%

:: Network Gaming Performance
echo ### NETWORK GAMING PERFORMANCE ### >> %OUTPUT%
echo ================================= >> %OUTPUT%
echo [PING TEST TO GAMING SERVERS] >> %OUTPUT%
ping -n 10 ea.com | findstr "Minimum Maximum Average" >> %OUTPUT%
ping -n 10 steam.com | findstr "Minimum Maximum Average" >> %OUTPUT%
ping -n 10 riot.com | findstr "Minimum Maximum Average" >> %OUTPUT%
echo. >> %OUTPUT%

:: USB Controllers
echo ### USB GAMING PERIPHERALS ### >> %OUTPUT%
echo ============================ >> %OUTPUT%
wmic path win32_usbcontroller get manufacturer,name /format:list >> %OUTPUT%
wmic path win32_usbhub get deviceid,name /format:list >> %OUTPUT%
echo. >> %OUTPUT%

:: Audio Devices
echo ### AUDIO DEVICES ### >> %OUTPUT%
echo =================== >> %OUTPUT%
wmic sounddev get name,manufacturer,status /format:list >> %OUTPUT%
echo. >> %OUTPUT%

:: Windows Gaming Features
echo ### WINDOWS GAMING FEATURES ### >> %OUTPUT%
echo ============================= >> %OUTPUT%
reg query "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /s >> %OUTPUT%
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /s >> %OUTPUT%
echo. >> %OUTPUT%

:: Running Gaming Services
echo ### ACTIVE GAMING PROCESSES ### >> %OUTPUT%
echo ============================= >> %OUTPUT%
tasklist /FI "IMAGENAME eq steam.exe" >> %OUTPUT%
tasklist /FI "IMAGENAME eq epicgameslauncher.exe" >> %OUTPUT%
tasklist /FI "IMAGENAME eq galaxyclient.exe" >> %OUTPUT%
tasklist /FI "IMAGENAME eq battle.net.exe" >> %OUTPUT%
echo. >> %OUTPUT%

:: System Performance Index (if available)
echo ### WINDOWS PERFORMANCE INDEX ### >> %OUTPUT%
echo =============================== >> %OUTPUT%
winsat formal -v >> %OUTPUT%
echo. >> %OUTPUT%

:: Network Adapter Settings
echo ### NETWORK ADAPTER CONFIGURATION ### >> %OUTPUT%
echo =================================== >> %OUTPUT%
ipconfig /all >> %OUTPUT%
netsh wlan show interfaces >> %OUTPUT%
echo. >> %OUTPUT%

:: Finish
echo Analysis complete! Report saved as: %OUTPUT%
echo Press any key to open the report...
pause >nul
start notepad %OUTPUT%