@echo off
REM Deletes the D3DSCache directory in the AppData\Local folder

REM Get the current user's profile path
set "D3DSCachePath=%UserProfile%\AppData\Local\D3DSCache"

REM Check if the directory exists
if exist "%D3DSCachePath%" (
    REM Delete the directory and its contents
    rd /s /q "%D3DSCachePath%"
    echo Deleted: %D3DSCachePath%
) else (
    echo Directory not found: %D3DSCachePath%
)

REM Pause to keep the command prompt open
pause
