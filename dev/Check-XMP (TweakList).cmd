@echo off
where.exe PowerShell.exe >NUL
if %ERRORLEVEL% EQU 1 echo PowerShell could not be found, (broke windows?) && pause>nul && exit
PowerShell.exe -ExecutionPolicy Bypass -NoExit -NoLogo -NoExit -noprofile -Command ^
"[System.Net.ServicePointManager]::SecurityProtocol = 'Tls12';iex(irm tl.ctt.cx);Check-XMP"