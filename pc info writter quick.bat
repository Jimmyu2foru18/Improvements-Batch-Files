@echo off
:: Set the output file
set output_file=pc_info.txt

:: Start logging
echo Collecting system information... > %output_file%
echo ---------------------------------- >> %output_file%

:: Get system information
echo [System Information] >> %output_file%
systeminfo >> %output_file%
echo. >> %output_file%

:: List all GPUs
echo [Installed GPUs] >> %output_file%
wmic path win32_videocontroller get caption,driverversion >> %output_file%
echo. >> %output_file%

:: Check power configuration
echo [Power Configuration] >> %output_file%
powercfg /q >> %output_file%
echo. >> %output_file%

:: Check primary display
echo [Primary Display] >> %output_file%
wmic path win32_videocontroller where "currentrefreshrate > 0" get caption, currentrefreshrate >> %output_file%
echo. >> %output_file%

:: List all installed programs
echo [Installed Programs] >> %output_file%
wmic product get name, version >> %output_file%
echo. >> %output_file%

:: Notify user
echo System information collected in %output_file%.
echo Open the file to review details and proceed with manual adjustments.
pause
