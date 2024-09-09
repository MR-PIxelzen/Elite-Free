@echo off
rem made my PRDGY_ACE, no point of saying dont claim it as urs, cuz i know u will
for /f "delims=" %%a in ('powershell -noprofile -c "$deviceId = '*' + (Get-PnpDevice -PresentOnly | Where-Object {($_.InstanceId -like 'PCI*') -and ($_.Class -like 'Display')}).PNPDeviceID.Replace('\', '\\') + '*'; (gwmi -query 'select * from Win32_PnPAllocatedResource' | Where-Object {$_.__RELPATH -like '*Win32_IRQResource*'} | Where-Object {$_.Dependent -like $deviceId } | Select-Object -ExpandProperty Antecedent).Split('=')[1]"') do set "GPU_IRQ=%%a"
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\PriorityControl" /v IRQ%GPU_IRQ%Priority /t REG_DWORD /d 1 /f
pause