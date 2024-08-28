@echo off
setlocal

echo Deleting Spotify cache...

:: Define the directories to be cleared
set "cacheDir1=%appdata%\Spotify\Storage"
set "cacheDir2=%localappdata%\Spotify\Storage"
set "cacheDir3=%localappdata%\Spotify\Browser\GPUCache"

:: Define the directory and file pattern for deletion
set "fileDir=%localappdata%\Spotify\Data\ed"
set "filePattern=*.file"

:: Function to delete the contents of a directory
call :deleteCache "%cacheDir1%"
call :deleteCache "%cacheDir2%"
call :deleteCache "%cacheDir3%"

:: Function to delete files with a specific pattern
call :deleteFiles "%fileDir%" "%filePattern%"

echo Spotify cache cleared.
endlocal
pause
exit /b

:deleteCache
set "dir=%~1"
if exist "%dir%" (
    echo Deleting contents of %dir%
    rmdir /s /q "%dir%"
    mkdir "%dir%"
) else (
    echo Directory %dir% does not exist.
)
exit /b

:deleteFiles
set "dir=%~1"
set "pattern=%~2"
if exist "%dir%" (
    echo Deleting files with pattern %pattern% in %dir%
    del /q "%dir%\%pattern%"
) else (
    echo Directory %dir% does not exist.
)
exit /b
