@echo off
echo BCU Generated batch uninstall script
"C:\WINDOWS\Installer\Razer\Installer\App\RazerInstaller.exe" /uninstall
"C:\Program Files (x86)\Razer\Razer Services\Razer Central\UninstallRazerCentral.bat"
"C:\Program Files (x86)\Razer\Razer Services\GMS\UninstallGMS.bat"
"C:\Program Files\BCUninstaller\win-x64\UniversalUninstaller.exe" /Q "C:\Program Files (x86)\Razer\RzS3WizardPkg\"
"C:\Program Files\BCUninstaller\win-x64\UniversalUninstaller.exe" /Q "C:\Program Files (x86)\Razer\Synapse3\UserProcess\"
pause
exit
