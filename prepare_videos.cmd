@echo off
setlocal enabledelayedexpansion

REM Get the directory where the script is located
set "script_dir=%~dp0"

REM Set the main directory
set "main_dir=%script_dir%main"

REM Main menu
:menu
cls
echo.
echo === Video Processing Script ===
echo 1. Create Main Folder Structure
echo 2. Convert Videos to MP3
echo 3. Rename MP3s
echo 4. Restore SRT Names
echo 5. Exit
echo.
set /p choice=Enter your choice (1-5): 

if "%choice%"=="1" (
    call :create_folders
    pause
    goto menu
)
if "%choice%"=="2" (
    call :convert_to_mp3
    pause
    goto menu
)
if "%choice%"=="3" (
    call :rename_mp3s
    pause
    goto menu
)
if "%choice%"=="4" (
    call :restore_srt_names
    pause
    goto menu
)
if "%choice%"=="5" exit /b

goto menu

REM Create main directory structure
:create_folders
cls
echo Creating main folder structure...
if not exist "%main_dir%" mkdir "%main_dir%"

set "video_dir=%main_dir%\1.default"
set "renamed_dir=%main_dir%\2.upload"
set "srt_dir=%main_dir%\3.ready"
set "converted_dir=%video_dir%\mp3"

if not exist "%video_dir%" mkdir "%video_dir%"
if not exist "%renamed_dir%" mkdir "%renamed_dir%"
if not exist "%srt_dir%" mkdir "%srt_dir%"
if not exist "%converted_dir%" mkdir "%converted_dir%"

REM Create log file if it doesn't exist
set "name_log=%main_dir%\original_names.log"
if not exist "%name_log%" type nul > "%name_log%"

echo Folder structure created successfully.
exit /b

REM Convert videos to MP3
:convert_to_mp3
cls
echo Converting video files to MP3...
set /a counter=1

REM Supported video extensions
set "video_exts=.mp4 .avi .mov .webm .mkv"

REM Check if main directory exists
if not exist "%main_dir%" (
    echo Error: Main folder structure not created. Please create it first.
    exit /b
)

for %%f in ("%video_dir%\*.*") do (
    set "ext=%%~xf"
    echo !video_exts! | findstr /i /c:"!ext!" >nul
    if !errorlevel! == 0 (
        set "filename=%%~nf"
        ffmpeg -i "%%f" -vn -acodec libmp3lame -q:a 2 "%converted_dir%\!filename!.mp3"
    )
)
echo Video to MP3 conversion complete.
exit /b

REM Rename MP3s and save original names
:rename_mp3s
cls
REM Calculate the number of spaces needed to center the message
set /a padding=(40 - 24) / 2
set "spaces="
for /l %%i in (1,1,%padding%) do set "spaces=!spaces! "

echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
REM Centers the message
echo %spaces%==================================
echo %spaces%    You can upload your files now
echo %spaces%==================================

REM Clear previous log
if exist "%name_log%" del "%name_log%"

set /a counter=1
for %%f in ("%converted_dir%\*.mp3") do (
    set "filename=%%~nf"
    set "extension=%%~xf"
    set "new_name=video_!counter!!extension!"
    
    REM Save original filename to log
    echo !filename!>>"%name_log%"
    
    REM Copy file to renamed directory
    copy "%%f" "%renamed_dir%\!new_name!"
    
    echo Renamed: %%f to !new_name!
    set /a counter+=1
)
echo MP3 renaming complete.
exit /b

REM Restore original names to SRT files
:restore_srt_names
cls
echo Restoring SRT names...

REM Check if main directory exists
if not exist "%main_dir%" (
    echo Error: Main folder structure not created. Please create it first.
    exit /b
)

REM Verify log file exists and has content
if not exist "%name_log%" (
    echo Error: Original names log file is missing.
    exit /b
)

REM Restore SRT names
set /a counter=1
for /f "delims=" %%f in ('type "%name_log%"') do (
    set "original_name=%%f"
    set "new_srt_name=video_!counter!.srt"
    
    if exist "%srt_dir%\!new_srt_name!" (
        REM Rename SRT to original video name
        ren "%srt_dir%\!new_srt_name!" "!original_name!.srt"
        echo Restored: !new_srt_name! to !original_name!.srt
    ) else (
        echo Warning: SRT file !new_srt_name! not found.
    )
    
    set /a counter+=1
)
echo SRT name restoration complete.
exit /b