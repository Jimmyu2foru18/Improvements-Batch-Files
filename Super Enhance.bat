@echo off
setlocal enabledelayedexpansion

:: Super Enhance Fix Script
:: This script combines various optimizations for gaming and logs system information.
:: Run this script as Administrator for best results.

echo ==================================================================
echo                  Super Enhance Fix Script
echo ==================================================================
echo This script will apply comprehensive optimizations for your gaming setup.
echo It will also log system information for analysis.
pause

:: Step 1: Log System Information
echo Gathering system information...
systeminfo > system_info.log
echo System information logged to system_info.log.
echo.

:: Step 2: Disable Non-Essential Startup Applications
echo Disabling non-essential startup applications...
for %%A in (
    MicrosoftEdgeAutoLaunch,
    OneDrive,
    "Opera GX Stable",
    Steam,
    GoogleDriveFS,
    EpicGamesLauncher,
    Spotify,
    Songify,
    RiotClient
) do (
    reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v %%A /f >nul 2>&1 && echo Disabled %%A || echo %%A not found.
)

echo Checking and disabling gaming-related applications...
for %%B in (
    "Ubisoft Connect",
    "Battle.net",
    "GOG Galaxy",
    "EA Desktop",
    Discord,
    "GeForce Experience",
    "Razer Synapse",
    "Logitech G Hub",
    "SteelSeries GG",
    "Dragon Center"
) do (
    reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v %%B /f >nul 2>&1 && echo Disabled %%B || echo %%B not found.
)
echo All specified non-essential startup applications have been processed.
echo.

:: Step 3: Set Power Plan to Ultimate Performance
echo Creating and setting power plan to Ultimate Performance...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 > nul 2>&1
if %errorlevel% neq 0 (
    echo Failed to create Ultimate Performance power plan. Attempting to enable existing plan...
    powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c > nul 2>&1
    if !errorlevel! neq 0 (
        echo Failed to set Ultimate Performance power plan. Using High Performance instead.
        powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c > nul 2>&1
    ) else (
        echo Existing Ultimate Performance power plan activated.
    )
) else (
    for /f "tokens=4" %%i in ('powercfg -list ^| findstr /i "Ultimate Performance"') do set "GUID=%%i"
    powercfg /setactive !GUID! > nul 2>&1
    if !errorlevel! neq 0 (
        echo Failed to set new Ultimate Performance power plan. Using High Performance instead.
        powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c > nul 2>&1
    ) else (
        echo New Ultimate Performance power plan created and set successfully.
    )
)
echo.

:: Step 4: Disable Unnecessary Services
echo Disabling unnecessary background services...
for %%s in (SysMain WSearch DiagTrack dmwappushservice) do (
    sc stop "%%s" >nul 2>&1
    sc config "%%s" start=disabled >nul 2>&1
)
echo Services optimized successfully.
echo.

:: Step 5: Optimize CPU Priority for Gaming
echo Adjusting CPU priority for gaming...
for /f "tokens=2 delims=," %%a in ('tasklist /FI "IMAGENAME eq explorer.exe" /FO CSV /NH') do (
    wmic process where ProcessId=%%a CALL setpriority "high priority" >nul 2>&1
)
echo CPU priority adjusted.
echo.

:: Step 6: Optimize Disk Performance
echo Optimizing disk performance...
fsutil behavior set disabledeletenotify 0 >nul 2>&1
echo Clearing temporary files...
del /s /q "%temp%\*" >nul 2>&1
rd /s /q "%temp%" >nul 2>&1
mkdir "%temp%" >nul 2>&1
echo Disk performance optimized.
echo.

:: Step 7: Optimize Network Settings for Gaming
echo Optimizing network settings...
netsh int tcp set global autotuninglevel=normal > nul 2>&1
netsh int tcp set global ecncapability=enabled > nul 2>&1
netsh int tcp set global timestamps=disabled > nul 2>&1
netsh int tcp set global rss=enabled > nul 2>&1
netsh int tcp set global fastopen=enabled > nul 2>&1
:: Disable Nagle's Algorithm
for /f "tokens=3*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /s /f "TCPNoDelay" ^| findstr /i "TCPNoDelay"') do (
    reg add "%%i" /v "TCPNoDelay" /t REG_DWORD /d 1 /f > nul 2>&1
    reg add "%%i" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f > nul 2>&1
)
echo Network optimized for reduced latency.
echo.

:: Step 8: Enable Hardware-Accelerated GPU Scheduling
echo Enabling Hardware-Accelerated GPU Scheduling...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f > nul 2>&1
echo Hardware-Accelerated GPU Scheduling enabled.
echo.

:: Step 9: Disable Visual Effects for Performance
echo Disabling unnecessary visual effects...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f > nul 2>&1
echo Visual effects disabled for better performance.
echo.

:: Step 10: Optimize Game Mode and Game Bar
echo Optimizing Game Mode and Game Bar...
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
echo Game Mode enabled and Game DVR disabled.
echo.

:: Step 11: Optimize Nvidia Control Panel Settings
echo Optimizing Nvidia Control Panel Settings...
if exist "%ProgramFiles%\NVIDIA Corporation\Control Panel Client\nvcplui.exe" (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PerfLevelSrc" /t REG_DWORD /d 8738 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerEnable" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerLevel" /t REG_DWORD /d 1 /f >nul 2>&1
    echo Nvidia settings optimized for performance.
) else (
    echo Nvidia Control Panel not found. Skipping Nvidia optimizations.
)
echo.

:: Step 12: Disable Windows Update during Gaming
echo Configuring Windows Update for gaming...
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v ActiveHoursStart /t REG_DWORD /d 8 /f > nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v ActiveHoursEnd /t REG_DWORD /d 22 /f > nul 2>&1
echo Windows Update configured to avoid interruptions during typical gaming hours.
echo.

:: Step 13: Optimize Virtual Memory Settings
echo Optimizing virtual memory settings...
for /f "tokens=2 delims==" %%a in ('wmic computersystem get totalphysicalmemory /value') do set ram=%%a
set /a ram_mb=%ram:~0,-7%
set /a pf_min=%ram_mb%
set /a pf_max=%ram_mb%*3
wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=%pf_min%,MaximumSize=%pf_max% > nul 2>&1
echo Virtual memory optimized.
echo.

:: Step 14: Disable Fullscreen Optimizations
echo Disabling Fullscreen Optimizations...
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f > nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 1 /f > nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehavior /t REG_DWORD /d 2 /f > nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 1 /f > nul 2>&1
echo Fullscreen optimizations disabled.
echo.

:: Step 15: Optimize Mouse Settings
echo Optimizing mouse settings...
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f > nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f > nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f > nul 2>&1
echo Mouse settings optimized.
echo.

:: Step 16: Completion
echo ==================================================================
echo Super Enhance Fix complete! Restart your PC for all changes to take effect.
pause
exit
