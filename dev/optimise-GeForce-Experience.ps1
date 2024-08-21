If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
{Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
Exit}
$Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (Administrator)"
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.PrivateData.ProgressBackgroundColor = "Black"
$Host.PrivateData.ProgressForegroundColor = "White"
Clear-Host

Get-Process | Where-Object { $_.ProcessName -like "*nv*" } | Stop-Process -Force

function EnableQuietMode {
    # Path to the XML file
    $xmlFilePath = "C:\ProgramData\NVIDIA Corporation\NvBackend\config.xml"

    # Load the XML file
    $xml = [xml](Get-Content $xmlFilePath)

    # Function to set or add a setting
    function SetOrAddSetting {
        param (
            [xml]$xml,
            [string]$settingName,
            [string]$newValue
        )

        $settingElement = $xml.SelectSingleNode("//Setting[@name='$settingName']")
        if ($null -ne $settingElement) {
            # Update existing setting
            $settingElement.SetAttribute("value", $newValue)
            Write-Host "Value of '$settingName' updated successfully."
        } else {
            # Add new setting
            $newSetting = $xml.CreateElement("Setting")
            $newSetting.SetAttribute("name", $settingName)
            $newSetting.SetAttribute("value", $newValue)
            $xml.SelectSingleNode("//Settings").AppendChild($newSetting)
            Write-Host "Setting '$settingName' added successfully."
        }
    }

    # Update or add required settings
    SetOrAddSetting -xml $xml -settingName "EnableQuietMode" -newValue "0"
    SetOrAddSetting -xml $xml -settingName "EnableBatteryBoost" -newValue "0"
    SetOrAddSetting -xml $xml -settingName "BatteryBoostIsSupported" -newValue "0"

    # Save the changes back to the XML file
    $xml.Save($xmlFilePath)

    Write-Host "Settings have been successfully updated."
}

# Call the function to execute it
#EnableQuietMode


function ModifySettings {
    # Path to the XML file
    $xmlFilePath = "$env:LocalAppData\NVIDIA\NvBackend\config.xml"

    # Load the XML file
    $xml = [xml](Get-Content $xmlFilePath)

    # Specify the settings you want to modify and set their values to zero
    $settingsToModify = @{
        "EnableUpdateTypeOPS" = "0"
        "EnableUpdateTypeSOPS" = "0"
        "EnableAutomaticApplicationScan" = "0"
        "EnableAutomaticDriverDownload" = "0"
        "EnableAutomaticApplyOPS" = "0"
        #<Setting name='EnableUpdateTypeOPS' value='0' />
        #<Setting name='EnableUpdateTypeSOPS' value='0' />
        #<Setting name='EnableAutomaticDriverDownload' value='0' />
        #<Setting name='EnableAutomaticApplicationScan' value='0' />
        #<Setting name='EnableAutomaticApplyOPS' value='0' />
    }

    # Loop through each setting to modify
    foreach ($settingName in $settingsToModify.Keys) {
        # Find the setting element with the specified name
        $settingElement = $xml.SelectSingleNode("//Setting[@name='$settingName']")

        if ($settingElement -ne $null) {
            # Set the new value for the setting
            $newValue = $settingsToModify[$settingName]
            $settingElement.SetAttribute("value", $newValue)

            Write-Host "Value of '$settingName' changed to '$newValue' successfully."
        } else {
            Write-Host "Setting '$settingName' not found."
        }
    }

    # Save the changes back to the XML file
    $xml.Save($xmlFilePath)
}

function RemoveApplicationScanPaths {
# Path to the XML file
$xmlFilePath = "$env:LocalAppData\NVIDIA\NvBackend\config.xml"

# Load the XML file
$xml = [xml](Get-Content $xmlFilePath)

# Specify the setting name you want to modify
$settingName = "ApplicationScanPaths"

# Find the setting element with the specified name
$settingElement = $xml.SelectSingleNode("//Setting[@name='$settingName']")

if ($settingElement -ne $null) {
    # Loop until no <String> child elements are found
    do {
        $stringElement = $settingElement.SelectSingleNode("String")
        if ($stringElement -ne $null) {
            $settingElement.RemoveChild($stringElement) | Out-Null
        }
    } while ($stringElement -ne $null)

    Write-Host "All String elements removed successfully from '$settingName'."
} else {
    Write-Host "Setting '$settingName' not found."
}

# Save the changes back to the XML file
$xml.Save($xmlFilePath)

}
Set-ItemProperty -Path "$env:LocalAppData\NVIDIA\NvBackend\config.xml" -Name IsReadOnly -Value $false
EnableQuietMode
RemoveApplicationScanPaths
ModifySettings
Set-ItemProperty -Path "$env:LocalAppData\NVIDIA\NvBackend\config.xml" -Name IsReadOnly -Value $true
Read-Host -Prompt "Press any key to continue"