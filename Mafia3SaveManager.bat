@echo off
setlocal enabledelayedexpansion
title Mafia III Save Manager
color 0A

:: Set the script directory
set "SCRIPT_DIR=%~dp0"
set "MISSIONS_DIR=%SCRIPT_DIR%All Missions"

:MAIN_MENU
cls
echo.
echo ====================================
echo   MAFIA III SAVE MANAGER
echo ====================================
echo.
echo [1] Load Mission Save
echo [2] Backup Current Saves
echo [3] View Current Saves Info
echo [4] Exit
echo.
set /p "choice=Enter your choice (1-4): "

if "%choice%"=="1" goto LOAD_SAVE
if "%choice%"=="2" goto BACKUP_SAVES
if "%choice%"=="3" goto VIEW_INFO
if "%choice%"=="4" goto END
echo Invalid choice. Please try again.
timeout /t 2 >nul
goto MAIN_MENU

:LOAD_SAVE
cls
echo.
echo ====================================
echo   FINDING STEAM ID...
echo ====================================
echo.

:: Find Steam ID by looking in the Mafia III Data folder
set "MAFIA_DATA=%LOCALAPPDATA%\2K Games\Mafia III\Data"

if not exist "%MAFIA_DATA%" (
    echo ERROR: Mafia III data folder not found!
    echo Expected location: %MAFIA_DATA%
    echo.
    echo Please make sure Mafia III is installed and you have run it at least once.
    pause
    goto MAIN_MENU
)

:: Find the Steam ID folder
set "STEAM_ID="
for /d %%i in ("%MAFIA_DATA%\*") do (
    if exist "%%i\gamesaves" (
        set "STEAM_ID=%%~nxi"
        goto FOUND_STEAM_ID
    )
)

:FOUND_STEAM_ID
if "%STEAM_ID%"=="" (
    echo ERROR: Could not find Steam ID folder!
    echo Searched in: %MAFIA_DATA%
    echo.
    echo Please make sure you have played Mafia III at least once to create save files.
    pause
    goto MAIN_MENU
)

echo Found Steam ID: %STEAM_ID%
echo.

set "SAVE_PATH=%MAFIA_DATA%\%STEAM_ID%\gamesaves\default\aslot"

if not exist "%SAVE_PATH%" (
    echo ERROR: Save folder not found!
    echo Expected location: %SAVE_PATH%
    echo.
    echo Creating directory...
    mkdir "%SAVE_PATH%" 2>nul
    if errorlevel 1 (
        echo Failed to create directory!
        pause
        goto MAIN_MENU
    )
    echo Directory created successfully!
    echo.
)

echo Save folder: %SAVE_PATH%
echo.
echo ====================================
echo   AVAILABLE MISSIONS
echo ====================================
echo.

:: List all mission folders
set count=0
for /d %%d in ("%MISSIONS_DIR%\*") do (
    set /a count+=1
    set "mission[!count!]=%%~nxd"
    echo [!count!] %%~nxd
)

if %count%==0 (
    echo No mission saves found in "All Missions" folder!
    pause
    goto MAIN_MENU
)

echo.
echo [0] Cancel
echo.
set /p "mission_choice=Select mission to load (0-%count%): "

if "%mission_choice%"=="0" goto MAIN_MENU
if %mission_choice% LSS 1 goto INVALID_MISSION
if %mission_choice% GTR %count% goto INVALID_MISSION

set "selected_mission=!mission[%mission_choice%]!"
set "source_path=%MISSIONS_DIR%\!selected_mission!\aslot"

if not exist "%source_path%" (
    echo ERROR: Mission save folder not found!
    echo Path: %source_path%
    pause
    goto MAIN_MENU
)

cls
echo.
echo ====================================
echo   LOADING MISSION SAVE
echo ====================================
echo.
echo Mission: !selected_mission!
echo.
echo Source: %source_path%
echo Destination: %SAVE_PATH%
echo.

:: Count files to copy
set file_count=0
for %%f in ("%source_path%\*.sav") do set /a file_count+=1

if %file_count%==0 (
    echo ERROR: No save files found in mission folder!
    pause
    goto MAIN_MENU
)

echo Found %file_count% save file(s) to copy.
echo.
echo WARNING: This will replace your current saves!
echo.
set /p "confirm=Continue? (Y/N): "

if /i not "%confirm%"=="Y" (
    echo Operation cancelled.
    timeout /t 2 >nul
    goto MAIN_MENU
)

echo.
echo Copying files...
echo.

xcopy "%source_path%\*.sav" "%SAVE_PATH%\" /Y /I >nul 2>&1

if errorlevel 1 (
    echo ERROR: Failed to copy save files!
    pause
    goto MAIN_MENU
)

echo.
echo SUCCESS! Mission save loaded successfully!
echo.
echo Files copied to: %SAVE_PATH%
echo.
pause
goto MAIN_MENU

:INVALID_MISSION
echo Invalid mission selection!
timeout /t 2 >nul
goto LOAD_SAVE

:BACKUP_SAVES
cls
echo.
echo ====================================
echo   BACKUP CURRENT SAVES
echo ====================================
echo.

:: Find Steam ID
set "MAFIA_DATA=%LOCALAPPDATA%\2K Games\Mafia III\Data"
set "STEAM_ID="
for /d %%i in ("%MAFIA_DATA%\*") do (
    if exist "%%i\gamesaves" (
        set "STEAM_ID=%%~nxi"
        goto FOUND_STEAM_ID_BACKUP
    )
)

:FOUND_STEAM_ID_BACKUP
if "%STEAM_ID%"=="" (
    echo ERROR: Could not find Steam ID folder!
    pause
    goto MAIN_MENU
)

set "SAVE_PATH=%MAFIA_DATA%\%STEAM_ID%\gamesaves\default\aslot"

if not exist "%SAVE_PATH%" (
    echo ERROR: No saves found to backup!
    pause
    goto MAIN_MENU
)

:: Create backup with timestamp
set "timestamp=%date:~-4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set "timestamp=%timestamp: =0%"
set "BACKUP_DIR=%SCRIPT_DIR%Backups\Backup_%timestamp%"

echo Creating backup folder...
mkdir "%BACKUP_DIR%" 2>nul

echo Backing up saves...
xcopy "%SAVE_PATH%\*.sav" "%BACKUP_DIR%\" /Y /I >nul 2>&1

if errorlevel 1 (
    echo ERROR: Backup failed!
    pause
    goto MAIN_MENU
)

echo.
echo SUCCESS! Saves backed up to:
echo %BACKUP_DIR%
echo.
pause
goto MAIN_MENU

:VIEW_INFO
cls
echo.
echo ====================================
echo   CURRENT SAVES INFORMATION
echo ====================================
echo.

:: Find Steam ID
set "MAFIA_DATA=%LOCALAPPDATA%\2K Games\Mafia III\Data"
set "STEAM_ID="
for /d %%i in ("%MAFIA_DATA%\*") do (
    if exist "%%i\gamesaves" (
        set "STEAM_ID=%%~nxi"
        goto FOUND_STEAM_ID_INFO
    )
)

:FOUND_STEAM_ID_INFO
if "%STEAM_ID%"=="" (
    echo ERROR: Could not find Steam ID folder!
    pause
    goto MAIN_MENU
)

echo Steam ID: %STEAM_ID%
echo.

set "SAVE_PATH=%MAFIA_DATA%\%STEAM_ID%\gamesaves\default\aslot"

if not exist "%SAVE_PATH%" (
    echo No saves found!
    pause
    goto MAIN_MENU
)

echo Save Location: %SAVE_PATH%
echo.
echo Current Save Files:
echo -----------------------------------

set file_count=0
for %%f in ("%SAVE_PATH%\*.sav") do (
    set /a file_count+=1
    echo [!file_count!] %%~nxf - %%~zf bytes - Modified: %%~tf
)

if %file_count%==0 (
    echo No save files found!
) else (
    echo.
    echo Total: %file_count% save file(s)
)

echo.
pause
goto MAIN_MENU

:END
cls
echo.
echo Thank you for using Mafia III Save Manager!
echo.
timeout /t 2 >nul
exit /b
