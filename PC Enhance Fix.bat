@echo off
setlocal enabledelayedexpansion

:: Comprehensive PC Gaming Optimization Script
:: Run this script as Administrator for best results

echo ==================================================================
echo                  PC Gaming Optimization Script
echo ==================================================================
echo This script will apply optimizations for your gaming setup.
echo Assisted in development from a Chatbot.
pause

:: Step 1: Set Power Plan to High Performance
echo Setting power plan to High Performance...
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
echo Power plan set successfully.
echo.

:: Step 2: Disable Unnecessary Services
echo Disabling unnecessary background services...
for %%s in (SysMain WSearch DiagTrack) do (
    sc stop "%%s" >nul 2>&1
    sc config "%%s" start=disabled >nul 2>&1
)
echo Services optimized successfully.
echo.

:: Step 3: Optimize CPU Priority for Gaming
echo Adjusting CPU priority for gaming...
for /f "tokens=2 delims=," %%a in ('tasklist /FI "IMAGENAME eq explorer.exe" /FO CSV /NH') do (
    wmic process where ProcessId=%%a CALL setpriority "high priority" >nul 2>&1
)
echo CPU priority adjusted.
echo.

:: Step 4: Optimize Disk Performance
echo Optimizing disk performance...
fsutil behavior set disabledeletenotify 0 >nul 2>&1
echo Clearing temporary files...
del /s /q "%temp%\*" >nul 2>&1
rd /s /q "%temp%" >nul 2>&1
mkdir "%temp%" >nul 2>&1
echo Disk performance optimized.
echo.

:: Step 5: Optimize Network Settings for Gaming
echo Optimizing network settings...
for /f "tokens=1* delims=:" %%i in ('ipconfig /all ^| findstr /C:"Ethernet adapter"') do (
    for /f "tokens=2 delims=(" %%a in ("%%j") do (
        set "adapter=%%a"
        set "adapter=!adapter:~1!"
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\!adapter!" /v TcpAckFrequency /t REG_DWORD /d 1 /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\!adapter!" /v TCPNoDelay /t REG_DWORD /d 1 /f >nul 2>&1
    )
)
echo Network optimized for low latency.
echo.

:: Step 6: Enable Hardware-Accelerated GPU Scheduling
echo Enabling Hardware-Accelerated GPU Scheduling (if supported)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul 2>&1
echo Hardware-Accelerated GPU Scheduling enabled.
echo.

:: Step 7: Disable Visual Effects for Performance
echo Disabling unnecessary visual effects...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
echo Visual effects disabled for better performance.
echo.

:: Step 8: Optimize Game Mode and Game Bar
echo Optimizing Game Mode and Game Bar...
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
echo Game Mode enabled and Game DVR disabled.
echo.

:: Step 9: Optimize Nvidia Control Panel Settings
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

:: Step 10: Reminder for XMP Profile and BIOS Updates
echo Remember to enable XMP Profile in BIOS to maximize RAM performance.
echo Check Gigabyte's website for BIOS updates for the Z390 AORUS ELITE.
echo.

:: Step 11: Reminder for GPU Updates
echo Ensure NVIDIA drivers are updated for both GTX 1660 SUPER and RTX 3050.
echo Use NVIDIA GeForce Experience for driver updates.
echo.

:: Completion
echo ==================================================================
echo Gaming optimization complete! Restart your PC for all changes to take effect.
pause
exit
