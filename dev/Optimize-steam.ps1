# Get all processes related to Steam
$steamProcesses = Get-Process -Name "Steam*" -ErrorAction SilentlyContinue

# Check if there are any Steam processes running
if ($steamProcesses) {
    # Stop each Steam process
    foreach ($process in $steamProcesses) {
        try {
            Stop-Process -Id $process.Id -Force
            Write-Host "Stopped process: $($process.Name) (ID: $($process.Id))"
        } catch {
            Write-Host "Failed to stop process: $($process.Name) (ID: $($process.Id))"
        }
    }
} else {
    Write-Host "No Steam processes are running."
}

# Set registry values under HKEY_CURRENT_USER\SOFTWARE\Valve\Steam
New-ItemProperty -Path "HKCU:\SOFTWARE\Valve\Steam" -Name "StartupModeTmpIsValid" -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path "HKCU:\SOFTWARE\Valve\Steam" -Name "StartupMode" -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path "HKCU:\SOFTWARE\Valve\Steam" -Name "StartupModeTmp" -PropertyType DWord -Value 7 -Force
New-ItemProperty -Path "HKCU:\SOFTWARE\Valve\Steam" -Name "SmoothScrollWebViews" -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path "HKCU:\SOFTWARE\Valve\Steam" -Name "DWriteEnable" -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path "HKCU:\SOFTWARE\Valve\Steam" -Name "H264HWAccel" -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path "HKCU:\SOFTWARE\Valve\Steam" -Name "DPIScaling" -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path "HKCU:\SOFTWARE\Valve\Steam" -Name "GPUAccelWebViews" -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path "HKCU:\SOFTWARE\Valve\Steam" -Name "GPUAccelWebViewsV3" -PropertyType DWord -Value 0 -Force
# Remove Steam from startup
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "Steam" -ErrorAction SilentlyContinue

# Loop through each directory matching the pattern
Get-ChildItem "C:\Program Files (x86)\Steam\userdata" -Directory | ForEach-Object {
    $configPath = "$($_.FullName)\config"
    if (Test-Path $configPath) {
        Write-Output "Navigating to $configPath"
        Clear-Host
    }
}

Set-Location -Path $configPath

function Librarysetting {

    # Specify the file path
$file = ".\localconfig.vdf"

# Define the content to be added
$contentToAdd = @'
	"news"
	{
		"NotifyAvailableGames"		"0"
	}
	"LibraryDisableCommunityContent"		"1"
	"LibraryLowPerfMode"		"1"
	"LibraryLowBandwidthMode"		"1"
	"LibraryDisplayIconInGameList"		"1"
	"Controller_CheckGuideButton"		"0"
	"SteamController_PSSupport"		"0"
}
'@

# Read the current content of the file
$currentContent = Get-Content -Path $file -Raw

# Ensure the existing content ends with a closing brace
if ($currentContent.TrimEnd() -match '}\s*$') {
    # Remove the last closing brace
    $currentContent = $currentContent.TrimEnd() -replace '}\s*$', ''
}

# Append the new content inside the closing brace
$newContent = $currentContent + "`r`n" + $contentToAdd

# Write the updated content back to the file
Set-Content -Path $file -Value $newContent
    
}

function Friendchat {
    # Specify the file path
$file = ".\localconfig.vdf"

# Define the content to be added
$contentToAdd = @'
	"Notifications_ShowIngame"		"1"
	"Notifications_ShowOnline"		"0"
	"Notifications_ShowMessage"		"1"
	"Notifications_EventsAndAnnouncements"		"1"
	"Sounds_PlayIngame"		"0"
	"Sounds_PlayOnline"		"0"
	"Sounds_PlayMessage"		"1"
	"Sounds_EventsAndAnnouncements"		"0"
	"ChatFlashMode"		"0"
	"DoNotDisturb"		"0"
	"SignIntoFriends"		"0"
'@

# Split the content to add into an array of lines
$contentToAddArray = $contentToAdd.Trim().Split("`n")

# Read the current content of the file
$currentContent = Get-Content -Path $file

# Define the pattern to search for
$pattern = '"PersonaName"\s+".*"'

# Initialize index variable
$index = -1

# Find the index of the line that matches the pattern
for ($i = 0; $i -lt $currentContent.Count; $i++) {
    if ($currentContent[$i] -match $pattern) {
        $index = $i
        break
    }
}

# If the line is found, insert the new content after it
if ($index -ne -1) {
    $beforeContent = $currentContent[0..$index]
    $afterContent = $currentContent[($index + 1)..($currentContent.Count - 1)]
    $updatedContent = $beforeContent + $contentToAddArray + $afterContent
    Set-Content -Path $file -Value $updatedContent
} else {
    Write-Host "The specified line was not found in the file."
}

    # Replace the value of "EnableStreaming" from "1" to "0"
    $currentContent = Get-Content -Path $file
    $updatedContent = $currentContent -replace '"EnableStreaming"\s+"1"', '"EnableStreaming"		"0"'
    Set-Content -Path $file -Value $updatedContent

    # Replace the value of "EnableStreaming" from "1" to "0"
    $currentContent = Get-Content -Path $file
    $updatedContent = $currentContent -replace '"HintAppsToPreload"\s+"\d+"', '"HintAppsToPreload" ""'
    Set-Content -Path $file -Value $updatedContent
}

function EnableGameOverlay {
 
    # Specify the file path
$file = ".\localconfig.vdf"

# Define the content to be added
$contentToAdd = @'
"EnableGameOverlay"		"0"
'@

# Split the content to add into an array of lines
$contentToAddArray = $contentToAdd.Trim().Split("`n")

# Read the current content of the file
$currentContent = Get-Content -Path $file

# Define the pattern to search for
$pattern = '"PushToTalkKey"\s+".*"'

# Initialize index variable
$index = -1

# Find the index of the line that matches the pattern
for ($i = 0; $i -lt $currentContent.Count; $i++) {
    if ($currentContent[$i] -match $pattern) {
        $index = $i
        break
    }
}

# If the line is found, insert the new content after it
if ($index -ne -1) {
    $beforeContent = $currentContent[0..$index]
    $afterContent = $currentContent[($index + 1)..($currentContent.Count - 1)]
    $updatedContent = $beforeContent + $contentToAddArray + $afterContent
    Set-Content -Path $file -Value $updatedContent
} else {
    Write-Host "The specified line was not found in the file."
}

}

function sharedconfigsetitng {

 Get-ChildItem "C:\Program Files (x86)\Steam\userdata" -Directory | ForEach-Object {
    $configPath = "$($_.FullName)\7\remote"
    if (Test-Path $configPath) {
        #Write-Output "Navigating to $configPath"
        
        # Specify the file path
        $file = "$configPath\sharedconfig.vdf"

        # create config for msi afterburner
$MultilineComment = @"
"UserRoamingConfigStore"
{
	"Software"
	{
		"Valve"
		{
			"Steam"
			{

				"FriendsUI"
				{
					"FriendsUIJSON"		"{\"bNotifications_ShowIngame\":false,\"bNotifications_ShowOnline\":false,\"bNotifications_ShowMessage\":false,\"bNotifications_EventsAndAnnouncements\":true,\"bSounds_PlayIngame\":false,\"bSounds_PlayOnline\":false,\"bSounds_PlayMessage\":false,\"bSounds_EventsAndAnnouncements\":false,\"bAlwaysNewChatWindow\":false,\"bForceAlphabeticFriendSorting\":false,\"nChatFlashMode\":0,\"bRememberOpenChats\":true,\"bCompactQuickAccess\":false,\"bCompactFriendsList\":false,\"bNotifications_ShowChatRoomNotification\":false,\"bSounds_PlayChatRoomNotification\":false,\"bHideOfflineFriendsInTagGroups\":false,\"bHideCategorizedFriends\":false,\"bCategorizeInGameFriendsByGame\":true,\"nChatFontSize\":2,\"b24HourClock\":false,\"bDoNotDisturbMode\":false,\"bDisableEmbedInlining\":false,\"bSignIntoFriends\":false,\"bDisableSpellcheck\":false,\"bDisableRoomEffects\":true,\"bAnimatedAvatars\":false,\"featuresEnabled\":{\"DoNotDisturb\":1,\"LoaderWindowSynchronization\":1,\"NonFriendMessageHandling\":1,\"NewVoiceHotKeyState\":1,\"PersonaNotifications\":1,\"ServerVirtualizedMemberLists\":1,\"SteamworksChatAPI\":1,\"FriendsFilter\":1}}"
				}
			}
		}
	}
	"DisableAllToasts"		"1"
	"DisableToastsInGame"		"1"
}
"@
Set-Content -Path "$file" -Value $MultilineComment -Force

    } else {
        Write-Output "Path not found: ${configPath}"
    }
}


}

function StreamingThrottleEnabled {
 
    # Specify the file path
$file = "C:\Program Files (x86)\Steam\config\config.vdf"

    # Replace the value of "EnableStreaming" from "1" to "0"
    $currentContent = Get-Content -Path $file
    $updatedContent = $currentContent -replace '"StreamingThrottleEnabled"\s+"\d+"', '"StreamingThrottleEnabled" "1"'
    Set-Content -Path $file -Value $updatedContent

    # Replace the value of "EnableStreaming" from "1" to "0"
    $currentContent = Get-Content -Path $file
    $updatedContent = $currentContent -replace '"AllowDownloadsDuringGameplay"\s+"\d+"', '"AllowDownloadsDuringGameplay" "0"'
    Set-Content -Path $file -Value $updatedContent
}

Librarysetting
Friendchat
EnableGameOverlay
sharedconfigsetitng
StreamingThrottleEnabled

Pause
