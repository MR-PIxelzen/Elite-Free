Start-Job -ScriptBlock {
    # Close Discord if it's running
    Stop-Process -Name "discord" -Force -ErrorAction SilentlyContinue
    
    # Clear the screen
    Clear-Host
    
    # Kill Discord process if still running
    Stop-Process -Name "discord" -Force -ErrorAction SilentlyContinue
    
    # Change directory to Discord's AppData folder
    Set-Location -Path "$env:APPDATA\discord"
    
    # Create settings.json with specified content
    #@"
    #{
    #  "enableHardwareAcceleration": false,
    #  "IS_MAXIMIZED": true,
    #  "IS_MINIMIZED": false,
    #  "OPEN_ON_STARTUP": false,
    #  "debugLogging": false
    #}
    #"@ | Out-File -FilePath "settings.json" -Encoding ASCII
    
    # Prompt to debloat Discord
        Write-Output "Removing bloat!"
    
        # Close Discord if running
        Stop-Process -Name "discord" -Force -ErrorAction SilentlyContinue
    
        # Remove Discord from startup
        $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
        $regName = "Discord"
        
        if (Test-Path -Path $regPath -ErrorAction SilentlyContinue) {
            $regValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue
            if ($regValue) {
                Remove-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue > $null
            }
        }

    
        # Delete unnecessary files and folders
        Get-ChildItem -Path "$env:LOCALAPPDATA\Discord\app-*" -Recurse -Include "chrome*.pak" | Remove-Item -Force
    
        # Prompt to remove Discord overlay
        Get-ChildItem -Path "$env:LOCALAPPDATA\Discord\app-*\modules" -Recurse -Include "discord_overlay2-2" | Remove-Item -Recurse -Force
    
        # Remove specified Discord modules
        $modulesToRemove = @("discord_cloudsync-1", "discord_dispatch-1", "discord_erlpack-1", "discord_game_utils-1", "discord_media-2", "discord_spellcheck-1", "discord_hook-2")
        foreach ($module in $modulesToRemove) {
            Get-ChildItem -Path "$env:LOCALAPPDATA\Discord\app-*\modules" -Recurse -Include $module | Remove-Item -Recurse -Force
        }
    
        # Clean up log files
        Remove-Item -Path "$env:HOMEPATH\AppData\Local\Discord\Discord_updater_rCURRENT.log" -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:HOMEPATH\AppData\Local\Discord\SquirrelSetup.log" -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:LOCALAPPDATA\Discord\debug.log" -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:LOCALAPPDATA\Discord\swiftshader" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:LOCALAPPDATA\Discord\Discord_updater*" -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:LOCALAPPDATA\Discord\SquirrelSetup*" -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:HOMEPATH\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Discord Inc" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:HOMEPATH\AppData\Local\discord\download" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:LOCALAPPDATA\Discord\Update.exe" -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:HOMEPATH\Desktop\Discord.lnk" -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:HOMEPATH\Desktop\Discord Start.exe" -Force -ErrorAction SilentlyContinue
        Get-ChildItem -Path "$env:LOCALAPPDATA\Discord\*" -Include "discord_game_sdk_x64.dll", "discord_game_sdk_x86.dll" -Recurse | Remove-Item -Force
    
        # Remove specific directories
        $directoriesToRemove = @("discord_cloudsync", "discord_dispatch", "discord_erlpack", "discord_media", "discord_spellcheck", "discord_game_utils")
        foreach ($dir in $directoriesToRemove) {
            Get-ChildItem -Path "$env:LOCALAPPDATA\Discord\*" -Recurse -Directory -Include $dir | Remove-Item -Recurse -Force
        }
    
        # Clean up locales
        Set-Location -Path "$env:LOCALAPPDATA\Discord\app*"
        Copy-Item -Path "locales\en-US.pak" -Destination "$env:LOCALAPPDATA\Discord\"
        Remove-Item -Path "locales" -Recurse -Force
        New-Item -Path "locales" -ItemType Directory
        Move-Item -Path "$env:LOCALAPPDATA\Discord\en-US.pak" -Destination "locales"
    
        # Download and replace app.asar
        $appAsarPaths = Get-ChildItem -Path "$env:LOCALAPPDATA\Discord\app*" -Recurse -Include "app.asar"
        foreach ($appAsarPath in $appAsarPaths) {
            Invoke-WebRequest -Uri "https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar" -OutFile $appAsarPath.FullName
        }
    
        Write-Output "Done!"
    
    
    # Prompt to remove Krisp
    
        Get-ChildItem -Path "$env:HOMEPATH\AppData\Local\discord" -Recurse -Include "discord_krisp" | Remove-Item -Recurse -Force
        Write-Output "Done!"
    
    
    # Prompt to remove overlay
    
        Get-ChildItem -Path "$env:HOMEPATH\AppData\Local\discord" -Recurse -Include "discord_overlay2", "discord_rpc" | Remove-Item -Recurse -Force
        Write-Output "Done!"
    
    
    # Final cleanup and create shortcut
    Set-Location -Path "$env:LOCALAPPDATA\Discord\app-*"
    Remove-Item -Path "chrome*.pak" -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:LOCALAPPDATA\Discord\Update.exe" -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:HOMEPATH\Desktop\Discord.lnk" -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:HOMEPATH\Desktop\Discord Start.exe" -Force -ErrorAction SilentlyContinue
    
    # Get the path of Discord.exe and create a symbolic link
    $discordExePath = Get-ChildItem -Path "$env:LOCALAPPDATA\Discord\app-*" -Recurse -Include "Discord.exe" | Select-Object -First 1 -ExpandProperty FullName
    if ($discordExePath) {
        New-Item -ItemType SymbolicLink -Path "$env:HOMEPATH\Desktop\Elite-Discord.exe" -Target $discordExePath
    }
}