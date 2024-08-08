Add-Type -AssemblyName System.Windows.Forms		
			try
			{   ## Displays an Downloading Resources .
				[void][System.Windows.Forms.MessageBox]::Show("Please wait, downloading NVCleanstall.
click ok to open NVCleanstall", "Downloading Resources", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

				Start-Job -ScriptBlock {
			# Define the registry path
			$registryPath = "HKCU:\SOFTWARE\techPowerUp\NVCleanstall"
			# Create the registry key if it doesn't exist
			if (-not (Test-Path $registryPath)) {
				New-Item -Path $registryPath -Force
			}
			# Set the registry values
			Set-ItemProperty -Path $registryPath -Name "InstallPath" -Value "C:\Program Files\NVCleanstall"
			Set-ItemProperty -Path $registryPath -Name "InstallVersion" -Value "1.16.0.0"

# Define the PreviousTweaks JSON string
$previousTweaks = @"
{
  "DisableInstallerTelemetry": true,
  "Unattended": true,
  "UnattendedReboot": true,
  "CleanInstall": true,
  "InstallDCHControlPanel": false,
  "AddHardwareId": false,
  "ShowDlssIndicator": false,
  "DisableMPO": true,
  "DisableNvCamera": true,
  "ShowExpertOptions": true,
  "DisableDriverTelemetry": true,
  "DisableNvContainer": false,
  "DisableHDAudioSleepTimer": false,
  "EnableMSI": true,
  "DisableHDCP": true,
  "NvEncPatch": false,
  "RunProgram": false,
  "RebuildSignatureEAC": true,
  "SkipUnsignedDriverWarning": true,
  "AddIdId": "",
  "AddIdName": "NVIDIA Graphics Device",
  "RunBefore": "",
  "RunAfter": "",
  "AddIdTemplate": "",
  "MSIPolicy": 0,
  "MSIPriority": 0,
  "NvEncPatchVersions": 0
}
"@
			# Set the PreviousTweaks registry value
			Set-ItemProperty -Path $registryPath -Name "PreviousTweaks" -Value $previousTweaks
			
			$downloadUrl = "https://raw.githubusercontent.com/MR-PIxelzen/Windows_Optimisation_Pack/main/NVCleanstall.exe"
			$outputPath = "C:\Elite\resources\NVCleanstall.exe"
			
			Invoke-WebRequest -Uri $downloadUrl -OutFile $outputPath
			Start-Process -FilePath $outputPath -Wait	
            }
            # Displays an installation tutorial in a message box with step-by-step instructions.
            [void][System.Windows.Forms.MessageBox]::Show(
                "1. Click 'Next'.`n`n" +
                "2. Choose the components you want to install, click recommended or leave it default, then click 'Next'.`n`n" +
                "3. Click 'Use previous settings'.`n`n" +
                "4. Click 'Next'.`n`n" +
                "5. Click 'Install' or 'Build package'.",
                "Installation Tutorial",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Information
            )
            
			}
			catch
			{
				
				[System.Windows.Forms.MessageBox]::Show("fail to download and launch NVCleanstall.`nError: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK)
			}