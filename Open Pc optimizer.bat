@echo off
setlocal
if "%~1" == "" (
    echo Drag a PowerShell script onto this batch file to run it with administrative privileges.
    pause
    exit /b
)
rem @echo off


REM :: Check if a file was dragged and dropped
REM if "%~1"=="" (
REM     echo Please drag and drop a PowerShell script onto this batch file.
REM     pause
REM     exit /b 1
REM )

:: Get the full path of the dragged file
set "file=%~1"

:: Get the current directory
set "currentDir=%cd%"

:: Add the Defender exclusion
powershell -Command "Add-MpPreference -ExclusionPath '%file%'"

:: Notify the user
echo Exclusion added for: %file%
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%~1""' -Verb RunAs}"
pause


