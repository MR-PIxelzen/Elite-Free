# Define the name of the software you want to uninstall
$softwareName = "Mozilla Maintenance Service"

# Get the list of installed software and find the one you want to uninstall
$software = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq $softwareName }

# Check if the software was found
if ($software) {
    try {
        # Uninstall the software
        $software.Uninstall()
        Write-Host "Successfully uninstalled $softwareName"
    } catch {
        Write-Host "Failed to uninstall $softwareName: $_"
    }
} else {
    Write-Host "$softwareName is not installed."
}
