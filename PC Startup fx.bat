@echo off
echo Disabling non-essential startup applications...

:: General Applications
echo Checking and disabling general non-essential applications...
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

:: Gaming-Related Applications
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

:: Completion Message
echo All specified non-essential startup applications have been processed.
pause
