## Set the location to the Spotify directory in AppData
#Set-Location $env:APPDATA\Spotify
#
## Kill the Spotify process if it is running
#taskkill /F /IM Spotify.exe
#
## Verify the existence of the prefs file
#if (Test-Path prefs) {
#    # Output the current content of the prefs file (optional)
#    Get-Content prefs
#
#    # Replace the hardware acceleration setting in the prefs file
#    (Get-Content prefs -Raw) -replace 'ui.hardware_acceleration=\d+', 'ui.hardware_acceleration=false' | Out-File -Encoding Default -Force prefs
#} else {
#    Write-Output "The prefs file does not exist."
#}
#

# Define the path to the prefs file
$prefsFilePath = "$env:APPDATA\Spotify\prefs"

# Read the content of the prefs file
$content = Get-Content -Path $prefsFilePath

# Define the key and the new value
$key = 'ui.hardware_acceleration'
$newValue = 'false'

# Initialize a flag to check if the key was found and replaced
$keyFound = $false

# Iterate over each line and update the value if the key is found
for ($i = 0; $i -lt $content.Length; $i++) {
    if ($content[$i] -match "$key\s*=\s*.*") {
        $content[$i] = "$key = $newValue"
        $keyFound = $true
        break
    }
}

# If the key was not found, append the key-value pair to the file
if (-not $keyFound) {
    $content += "$key = $newValue"
}

# Write the updated content back to the prefs file
Set-Content -Path $prefsFilePath -Value $content
