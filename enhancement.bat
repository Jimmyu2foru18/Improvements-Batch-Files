@echo off
:: Ensure the script runs as administrator
NET SESSION >nul 2>&1
if %errorlevel% neq 0 (
    echo This script must be run as an administrator. Relaunching with elevated privileges...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

:: Keep Game Bar and skip disabling it
echo Keeping Game Bar features as per your request.

:: Enable Game Mode
echo Enabling Game Mode...
reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 1 /f >nul

:: Optimize visual effects for gaming performance
echo Setting visual effects for best performance...
reg add "HKEY_CURRENT_USER\Control Panel\Performance\Visual Effects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f >nul

:: Disable unnecessary services (SysMain and Windows Search)
echo Disabling unused services (SysMain and Windows Search)...
sc stop SysMain >nul 2>&1
sc config SysMain start= disabled >nul 2>&1
sc stop WSearch >nul 2>&1
sc config WSearch start= disabled >nul 2>&1

:: Clear temporary files
echo Clearing temporary files...
rd /s /q "%TEMP%" >nul 2>&1
md "%TEMP%" >nul 2>&1
del /s /q "C:\Windows\Temp\*" >nul 2>&1
del /s /q "%SystemRoot%\Prefetch\*" >nul 2>&1

:: Optimize power settings for high performance
echo Setting power plan to High Performance...
powercfg /setactive SCHEME_MIN >nul

:: Optimize drives (skip SSDs)
echo Optimizing HDDs...
for /f "tokens=1,2 delims=," %%i in ('wmic diskdrive get MediaType^,DeviceID /format:csv') do (
    if /i "%%i"=="Hard Disk Drive" (
        echo Defragmenting drive %%j...
        defrag %%j /O >nul
    ) else (
        echo Skipping drive %%j (Not an HDD)...
    )
)

:: Final message
echo Optimization complete! Please restart your PC for full effect.
pause
exit
