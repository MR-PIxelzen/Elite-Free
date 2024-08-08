# Set variables
$url = "https://github.com/MR-PIxelzen/Windows_Optimisation_Pack/raw/main/DDU.zip"
$outputFile = "C:\Elite\resources\DDU.zip"
$extractFolder = "C:\Elite\resources\DDU"
$executable = "ddu.exe"

# Create the directory if it doesn't exist
if (!(Test-Path -Path "C:\Elite\resources")) {
    New-Item -ItemType Directory -Path "C:\Elite\resources"
}

# Download the file
Invoke-WebRequest -Uri $url -OutFile $outputFile

# Extract the file
Expand-Archive -Path $outputFile -DestinationPath $extractFolder

# Verify the contents of the extraction folder
Write-Output "Contents of the extraction folder ($extractFolder):"
Get-ChildItem -Path $extractFolder

# Start the executable
$executablePath = Join-Path -Path $extractFolder -ChildPath $executable
Write-Output "Trying to start the executable at: $executablePath"

#if (Test-Path -Path $executablePath) {
#    Start-Process -FilePath $executablePath
#} else {
#    Write-Error "Executable not found at $executablePath"
#}

#Pause
<#
curl -g -k -L -# -o "C:\Elite\resources\DDU\ddu.bat" "https://github.com/MR-PIxelzen/Windows_Optimisation_Pack/raw/main/ddu.bat" >nul 2>&1

#>
# create config for msi afterburner
$MultilineComment = @"
@echo off
setlocal EnableDelayedExpansion
set ver=0.1
set c=curl -g -k -L -# -o

cd /d "%~dp0"

title Elite display-drivers-uninstaller %ver%


REM Get video controller name
for /f "skip=1 delims=" %%a in ('wmic path win32_VideoController get name') do (
    set "placaF=%%a"
    set "placaF=!placaF:~0,-1!" REM Remove trailing carriage return
    goto :next
)

:next
echo Video controller: !placaF!

REM Driver uninstallation based on detected video controller
set "vendor="
if /i "!placaF:~0,6!"=="NVIDIA" (
    set "vendor=NVIDIA"
) else if /i "!placaF:~0,3!"=="AMD" (
    set "vendor=AMD"
) else if /i "!placaF:~0,5!"=="Intel" (
    set "vendor=Intel"
)

if defined vendor (
    echo Uninstalling !vendor! drivers...
 bcdedit /deletevalue {current} safeboot
 bcdedit /deletevalue {current} safebootalternateshell
    start "" "%~dp0\ddu.exe" -Silent -NoRestorePoint -PreventWinUpdate -NoSafeModeMsg -Clean!vendor! -Restart 
    
) else (
    echo Unknown video controller: !placaF!
     bcdedit /deletevalue {current} safeboot
     bcdedit /deletevalue {current} safebootalternateshell
)

pause
"@
#"C:\Vortex\resources\DDU\ddu.bat"
Set-Content -Path "$env:C:\Elite\resources\DDU\ddu.bat" -Value $MultilineComment -Force

# Add the registry entry to run ddu.bat on the next boot
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" -Name "*DDU" -PropertyType String -Value "C:\Elite\resources\DDU\ddu.bat" -Force

# Set the system to boot into Safe Mode (minimal)
bcdedit /set {default} safeboot minimal | Out-Null

# Restart the system in 5 seconds with a custom message
shutdown.exe -r -t 5 -c "restart into safe mode"
