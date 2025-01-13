@echo off
title PC Optimization for Gaming
echo Optimizing PC for maximum gaming performance...

:: Enable Ultimate Performance power plan
powercfg /s SCHEME_ULTIMATE

:: Set CPU Priority for Games
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\YourGame.exe\PerfOptions" /v CpuPriority /t REG_DWORD /d 3 /f

:: Disable unnecessary background services
echo Disabling unnecessary services...
sc config "DiagTrack" start= disabled
sc stop "DiagTrack"
sc config "SysMain" start= disabled
sc stop "SysMain"
sc config "WSearch" start= disabled
sc stop "WSearch"

:: Disable Xbox Game Bar
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 0 /f

:: Disable visual effects for performance
echo Configuring visual effects for performance...
reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d 9012018012000000 /f
reg add "HKCU\Control Panel\Performance" /v "VisualEffects" /t REG_DWORD /d 2 /f

:: Optimize network settings for low latency
echo Optimizing network settings...
netsh int tcp set global autotuninglevel=disabled
netsh int tcp set global rss=enabled
netsh int tcp set global chimney=enabled
netsh advfirewall set allprofiles state off

:: Clear DNS cache
echo Flushing DNS cache...
ipconfig /flushdns

:: Kill unnecessary background apps
echo Closing unnecessary background applications...
taskkill /f /im OneDrive.exe
taskkill /f /im Teams.exe
taskkill /f /im Skype.exe
taskkill /f /im Cortana.exe

:: Clean temporary files
echo Cleaning temporary files...
del /s /q "%temp%\*" >nul 2>&1
rd /s /q "%temp%" >nul 2>&1
mkdir "%temp%"

:: Set GPU preference to high performance (NVIDIA)
echo Configuring GPU settings for high performance...
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\YourGame.exe\PerfOptions" /v GpuPriority /t REG_DWORD /d 8 /f

:: Display optimization complete message
echo Optimization complete! You can now launch your game.
pause
