# Mafia III Save Manager

A simple batch file with a text-based user interface (TUI) to manage Mafia III save files.

## Features

- **Load Mission Saves**: Browse and load any mission save from the "All Missions" folder
- **Automatic Steam ID Detection**: Automatically finds your Steam ID from the Mafia III data folder
- **Backup Current Saves**: Create timestamped backups of your current save files
- **View Save Information**: See details about your current save files
- **User-Friendly Interface**: Easy-to-use menu system with clear prompts

## Usage

1. Double-click `Mafia3SaveManager.bat` to launch the program
2. Choose from the menu options:
   - **[1] Load Mission Save**: Select a mission to load its save files
   - **[2] Backup Current Saves**: Create a backup before loading new saves
   - **[3] View Current Saves Info**: See your current save files and Steam ID
   - **[4] Exit**: Close the program

## How It Works

1. The program automatically detects your Steam ID by scanning:
   ```
   %LOCALAPPDATA%\2K Games\Mafia III\Data\
   ```

2. It then copies save files from:
   ```
   All Missions\[Mission Name]\aslot\
   ```
   
3. To your Mafia III save location:
   ```
   %LOCALAPPDATA%\2K Games\Mafia III\Data\[STEAM_ID]\gamesaves\default\aslot\
   ```

## Requirements

- Windows operating system
- Mafia III installed and run at least once (to create the save folder structure)
- "All Missions" folder in the same directory as the batch file

## Safety

The program will:
- Warn you before overwriting existing saves
- Let you create backups before loading new saves
- Show you exactly what files will be copied

## Troubleshooting

If you encounter errors:
- Make sure Mafia III is installed
- Run Mafia III at least once to create the save folder structure
- Verify the "All Missions" folder exists in the same directory as the batch file
- Check that you have write permissions to the Mafia III data folder

## File Structure

```
Mafia3-SaveHelp\
├── Mafia3SaveManager.bat    (The main program)
├── All Missions\              (Mission save folders)
│   ├── 1.Why take for chance\
│   │   └── aslot\
│   │       ├── save0.sav
│   │       ├── save1.sav
│   │       └── save2.sav
│   └── [Other missions...]
└── Backups\                   (Created automatically when you backup)
    └── Backup_[timestamp]\
```
