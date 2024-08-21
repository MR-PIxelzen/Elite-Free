@echo off
where.exe PowerShell.exe >NUL
if %ERRORLEVEL% EQU 1 echo PowerShell could not be found, (broke windows?) && pause>nul && exit
powershell -ExecutionPolicy Bypass -NoLogo -noprofile -command "$gpu = Get-PnpDevice -Class Display | Where-Object { $_.FriendlyName -like '*NVIDIA*' }; if ($gpu) { $gpuId = $gpu.InstanceId; Disable-PnpDevice -InstanceId $gpuId -Confirm:$false; Start-Sleep -Seconds 1; Enable-PnpDevice -InstanceId $gpuId -Confirm:$false } else { Clear-Host }"
