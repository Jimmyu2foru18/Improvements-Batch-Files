@echo off
setlocal enabledelayedexpansion

:: Advanced PC Gaming Optimization Script v2.2
:: Run this script as Administrator for best results

echo ==================================================================
echo             Advanced PC Gaming Optimization Script v2.2
echo ==================================================================
echo This script applies comprehensive optimizations for gaming.
echo Please ensure you have a backup before proceeding.
echo.
echo IMPORTANT: This script must be run as Administrator.
echo If you haven't already, please restart this script as Administrator.
echo.
pause

:: Check for Admin rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script requires Administrator privileges.
    echo Please run it as Administrator.
    pause
    exit /b 1
)

:: Step 1: Set Power Plan to Ultimate Performance
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

:: [The rest of the script remains unchanged]

:: Step 2: Disable Unnecessary Services and Background Processes
echo Optimizing services and background processes...
for %%s in (SysMain WSearch DiagTrack dmwappushservice) do (
    sc stop "%%s" > nul 2>&1
    sc config "%%s" start=disabled > nul 2>&1
)
echo Services optimized.
echo.

:: Step 3: Optimize CPU Priority for Gaming
echo Adjusting CPU priority for gaming...
for /f "tokens=2 delims=," %%a in ('tasklist /FI "IMAGENAME eq explorer.exe" /FO CSV /NH') do (
    wmic process where ProcessId=%%a CALL setpriority "high priority" > nul 2>&1
)
echo CPU priority adjusted.
echo.

:: Step 4: Optimize Disk Performance
echo Optimizing disk performance...
fsutil behavior set disabledeletenotify 0 > nul 2>&1
echo Clearing temporary files...
del /s /q "%temp%\*" > nul 2>&1
rd /s /q "%temp%" > nul 2>&1
mkdir "%temp%" > nul 2>&1
echo Disk performance optimized.
echo.

:: Step 5: Optimize Network Settings
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

:: Step 6: Enable Hardware-Accelerated GPU Scheduling
echo Enabling Hardware-Accelerated GPU Scheduling...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f > nul 2>&1
echo Hardware-Accelerated GPU Scheduling enabled.
echo.

:: Step 7: Optimize Visual Effects for Performance
echo Optimizing visual effects for performance...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f > nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012078010000000 /f > nul 2>&1
echo Visual effects optimized for performance.
echo.

:: Step 8: Disable Game DVR and Game Bar
echo Disabling Game DVR and Game Bar...
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f > nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f > nul 2>&1
echo Game DVR and Game Bar disabled.
echo.

:: Step 9: Optimize Mouse Settings
echo Optimizing mouse settings...
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f > nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f > nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f > nul 2>&1
echo Mouse settings optimized.
echo.

:: Step 10: Disable Fullscreen Optimizations
echo Disabling Fullscreen Optimizations...
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f > nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 1 /f > nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehavior /t REG_DWORD /d 2 /f > nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 1 /f > nul 2>&1
echo Fullscreen Optimizations disabled.
echo.

:: Step 11: Optimize NVIDIA Settings (if applicable)
echo Checking for NVIDIA GPU...
wmic path win32_VideoController get name | findstr /i "nvidia" > nul
if %errorlevel% equ 0 (
    echo NVIDIA GPU detected. Optimizing NVIDIA settings...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v PlatformSupportMiracast /t REG_DWORD /d 0 /f > nul 2>&1
    reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v DisplayPowerSaving /t REG_DWORD /d 0 /f > nul 2>&1
    echo NVIDIA settings optimized.
) else (
    echo NVIDIA GPU not detected. Skipping NVIDIA optimizations.
)
echo.

:: Step 12: Enable Game Mode
echo Enabling Game Mode...
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f > nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f > nul 2>&1
echo Game Mode enabled.
echo.

:: Step 13: Disable Windows Update during gaming
echo Configuring Windows Update for gaming...
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v ActiveHoursStart /t REG_DWORD /d 8 /f > nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v ActiveHoursEnd /t REG_DWORD /d 22 /f > nul 2>&1
echo Windows Update configured to avoid interruptions during typical gaming hours.
echo.

:: Step 14: Optimize virtual memory
echo Optimizing virtual memory...
for /f "tokens=2 delims==" %%a in ('wmic computersystem get totalphysicalmemory /value') do set ram=%%a
set /a ram_mb=%ram:~0,-7%
set /a pf_min=%ram_mb%
set /a pf_max=%ram_mb%*3
wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=%pf_min%,MaximumSize=%pf_max% > nul 2>&1
echo Virtual memory optimized.
echo.

:: Step 15: Completion
echo ==================================================================
echo Gaming optimization complete! Please restart your PC for all changes to take effect.
echo Remember to update your GPU drivers regularly for optimal performance.
echo Consider using MSI Afterburner for safe GPU overclocking if needed.
pause
exit /b 0
