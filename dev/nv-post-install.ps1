
#run powershell as trusted installer credit : https://github.com/AveYo/LeanAndMean
#added -wait to prevent script from continuing too fast
function RunAsTI($cmd, $arg) {
    $id = 'RunAsTI'; $key = "Registry::HKU\$(((whoami /user)-split' ')[-1])\Volatile Environment"; $code = @'
 $I=[int32]; $M=$I.module.gettype("System.Runtime.Interop`Services.Mar`shal"); $P=$I.module.gettype("System.Int`Ptr"); $S=[string]
 $D=@(); $T=@(); $DM=[AppDomain]::CurrentDomain."DefineDynami`cAssembly"(1,1)."DefineDynami`cModule"(1); $Z=[uintptr]::size
 0..5|% {$D += $DM."Defin`eType"("AveYo_$_",1179913,[ValueType])}; $D += [uintptr]; 4..6|% {$D += $D[$_]."MakeByR`efType"()}
 $F='kernel','advapi','advapi', ($S,$S,$I,$I,$I,$I,$I,$S,$D[7],$D[8]), ([uintptr],$S,$I,$I,$D[9]),([uintptr],$S,$I,$I,[byte[]],$I)
 0..2|% {$9=$D[0]."DefinePInvok`eMethod"(('CreateProcess','RegOpenKeyEx','RegSetValueEx')[$_],$F[$_]+'32',8214,1,$S,$F[$_+3],1,4)}
 $DF=($P,$I,$P),($I,$I,$I,$I,$P,$D[1]),($I,$S,$S,$S,$I,$I,$I,$I,$I,$I,$I,$I,[int16],[int16],$P,$P,$P,$P),($D[3],$P),($P,$P,$I,$I)
 1..5|% {$k=$_; $n=1; $DF[$_-1]|% {$9=$D[$k]."Defin`eField"('f' + $n++, $_, 6)}}; 0..5|% {$T += $D[$_]."Creat`eType"()}
 0..5|% {nv "A$_" ([Activator]::CreateInstance($T[$_])) -fo}; function F ($1,$2) {$T[0]."G`etMethod"($1).invoke(0,$2)}
 $TI=(whoami /groups)-like'*1-16-16384*'; $As=0; if(!$cmd) {$cmd='control';$arg='admintools'}; if ($cmd-eq'This PC'){$cmd='file:'}
 if (!$TI) {'TrustedInstaller','lsass','winlogon'|% {if (!$As) {$9=sc.exe start $_; $As=@(get-process -name $_ -ea 0|% {$_})[0]}}
 function M ($1,$2,$3) {$M."G`etMethod"($1,[type[]]$2).invoke(0,$3)}; $H=@(); $Z,(4*$Z+16)|% {$H += M "AllocHG`lobal" $I $_}
 M "WriteInt`Ptr" ($P,$P) ($H[0],$As.Handle); $A1.f1=131072; $A1.f2=$Z; $A1.f3=$H[0]; $A2.f1=1; $A2.f2=1; $A2.f3=1; $A2.f4=1
 $A2.f6=$A1; $A3.f1=10*$Z+32; $A4.f1=$A3; $A4.f2=$H[1]; M "StructureTo`Ptr" ($D[2],$P,[boolean]) (($A2 -as $D[2]),$A4.f2,$false)
 $Run=@($null, "powershell -win 1 -nop -c iex `$env:R; # $id", 0, 0, 0, 0x0E080600, 0, $null, ($A4 -as $T[4]), ($A5 -as $T[5]))
 F 'CreateProcess' $Run; return}; $env:R=''; rp $key $id -force; $priv=[diagnostics.process]."GetM`ember"('SetPrivilege',42)[0]
 'SeSecurityPrivilege','SeTakeOwnershipPrivilege','SeBackupPrivilege','SeRestorePrivilege' |% {$priv.Invoke($null, @("$_",2))}
 $HKU=[uintptr][uint32]2147483651; $NT='S-1-5-18'; $reg=($HKU,$NT,8,2,($HKU -as $D[9])); F 'RegOpenKeyEx' $reg; $LNK=$reg[4]
 function L ($1,$2,$3) {sp 'HKLM:\Software\Classes\AppID\{CDCBCFCA-3CDC-436f-A4E2-0E02075250C2}' 'RunAs' $3 -force -ea 0
  $b=[Text.Encoding]::Unicode.GetBytes("\Registry\User\$1"); F 'RegSetValueEx' @($2,'SymbolicLinkValue',0,6,[byte[]]$b,$b.Length)}
 function Q {[int](gwmi win32_process -filter 'name="explorer.exe"'|?{$_.getownersid().sid-eq$NT}|select -last 1).ProcessId}
 $11bug=($((gwmi Win32_OperatingSystem).BuildNumber)-eq'22000')-AND(($cmd-eq'file:')-OR(test-path -lit $cmd -PathType Container))
 if ($11bug) {'System.Windows.Forms','Microsoft.VisualBasic' |% {[Reflection.Assembly]::LoadWithPartialName("'$_")}}
 if ($11bug) {$path='^(l)'+$($cmd -replace '([\+\^\%\~\(\)\[\]])','{$1}')+'{ENTER}'; $cmd='control.exe'; $arg='admintools'}
 L ($key-split'\\')[1] $LNK ''; $R=[diagnostics.process]::start($cmd,$arg); if ($R) {$R.PriorityClass='High'; $R.WaitForExit()}
 if ($11bug) {$w=0; do {if($w-gt40){break}; sleep -mi 250;$w++} until (Q); [Microsoft.VisualBasic.Interaction]::AppActivate($(Q))}
 if ($11bug) {[Windows.Forms.SendKeys]::SendWait($path)}; do {sleep 7} while(Q); L '.Default' $LNK 'Interactive User'
'@; $V = ''; 'cmd', 'arg', 'id', 'key' | ForEach-Object { $V += "`n`$$_='$($(Get-Variable $_ -val)-replace"'","''")';" }; Set-ItemProperty $key $id $($V, $code) -type 7 -force -ea 0
    Start-Process powershell -args "-win 1 -nop -c `n$V `$env:R=(gi `$key -ea 0).getvalue(`$id)-join''; iex `$env:R" -verb runas -Wait
} # lean & mean snippet by AveYo, 2022.01.28


#getting monitor ids and adding them to an array
$monitorDevices = pnputil /enum-devices | Select-String -Pattern 'DISPLAY'

if ($monitorDevices) {
    $dList = @()
    
    foreach ($device in $monitorDevices) {
        $deviceId = $device.ToString() -replace '^.*?DISPLAY\\(.*?)\\.*$', '$1'
        
        if ($deviceId.Length -eq 7 -and !$dList.Contains($deviceId)) {
            
            $dList += $deviceId
            
                
        }
    }
        
}


#adding saturation reg key paths to an array
$paths = @()
for ($i = 0; $i -lt $dList.Length; $i++) {
    $paths += Get-ChildItem -Path 'registry::HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm\State\DisplayDatabase\' | Where-Object { $_.Name -like "*$($dList[$i])*" } | Select-Object -First 1

}



#getting names of connected monitors
$monitors = Get-WmiObject -Namespace root\wmi -Class WmiMonitorID

$manufacturerNames = @()

foreach ($monitor in $monitors) {
    $manufacturerName = [System.Text.Encoding]::ASCII.GetString($monitor.UserFriendlyName -ne 0)
    $manufacturerNames += $manufacturerName
}







Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$form = New-Object System.Windows.Forms.Form
$form.Size = New-Object System.Drawing.Size(400, 430)
$form.StartPosition = 'CenterScreen'
$form.Text = 'Post Install Tweaks'
$form.BackColor = 'Black'

$TabControl = New-Object System.Windows.Forms.TabControl
$TabControl.Location = New-Object System.Drawing.Size(10, 10)
$TabControl.Size = New-Object System.Drawing.Size(370, 350) 
$TabControl.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)


$TabPage1 = New-Object System.Windows.Forms.TabPage
$TabPage1.Text = 'General'
$TabPage1.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)

$TabPage2 = New-Object System.Windows.Forms.TabPage
$TabPage2.Text = 'Digital Vibrance'
$TabPage2.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)


   
$TabControl.Controls.Add($TabPage1)
$TabControl.Controls.Add($TabPage2)



$Form.Controls.Add($TabControl) 


$checkbox1 = new-object System.Windows.Forms.checkbox
$checkbox1.Location = new-object System.Drawing.Size(10, 20)
$checkbox1.Size = new-object System.Drawing.Size(150, 20)
$checkbox1.Text = 'Import NVCP Settings'
$checkbox1.ForeColor = 'White'
$checkbox1.Checked = $false
$Form.Controls.Add($checkbox1)  
$TabPage1.Controls.Add($checkBox1)

$checkbox2 = new-object System.Windows.Forms.checkbox
$checkbox2.Location = new-object System.Drawing.Size(10, 50)
$checkbox2.Size = new-object System.Drawing.Size(150, 20)
$checkbox2.Text = 'Enable Legacy Sharpen'
$checkbox2.ForeColor = 'White'
$checkbox2.Checked = $false
$Form.Controls.Add($checkbox2)
$TabPage1.Controls.Add($checkBox2)

$checkbox3 = new-object System.Windows.Forms.checkbox
$checkbox3.Location = new-object System.Drawing.Size(10, 80)
$checkbox3.Size = new-object System.Drawing.Size(150, 20)
$checkbox3.Text = 'Enable MSI Mode'
$checkbox3.ForeColor = 'White'
$checkbox3.Checked = $false
$Form.Controls.Add($checkbox3)
$TabPage1.Controls.Add($checkBox3)

$checkbox4 = new-object System.Windows.Forms.checkbox
$checkbox4.Location = new-object System.Drawing.Size(10, 110)
$checkbox4.Size = new-object System.Drawing.Size(150, 20)
$checkbox4.Text = 'Remove GPU Idle States'
$checkbox4.ForeColor = 'White'
$checkbox4.Checked = $false
$Form.Controls.Add($checkbox4)
$TabPage1.Controls.Add($checkBox4)


$trackbarValues = @{}
for ($i = 0; $i -lt $dList.Length; $i++) {
    $y = 35 + ($i * 80)

    # Create a label for the manufacturer name
    $nameLabel = New-Object System.Windows.Forms.Label
    $nameLabel.Text = $manufacturerNames[$i]
    $nameLabel.ForeColor = 'White'
    $nameLabel.AutoSize = $true
    $nameLabel.Location = New-Object System.Drawing.Point(10, $y)
    $tabPage2.Controls.Add($nameLabel)

    # Create a trackbar for the value
    $trackBar = New-Object System.Windows.Forms.TrackBar
    $trackBar.Minimum = 0
    $trackBar.Maximum = 100
    $trackBar.TickFrequency = 5
    $trackBar.SmallChange = 1
    $trackBar.LargeChange = 10
    $trackBar.Location = New-Object System.Drawing.Point(100, $y)
    $trackBar.Width = 200
    $tabPage2.Controls.Add($trackBar)
    $midpoint = [Math]::Round(($trackBar.Minimum + $trackBar.Maximum) / 2)
    $trackBar.Value = $midpoint

    # Assign a unique tag to each trackbar
    $trackBar.Tag = $i

    # Create a label to display the value
    $valueLabel = New-Object System.Windows.Forms.Label
    $valueLabel.AutoSize = $true
    $valueLabel.ForeColor = 'White'
    $valueLabel.Location = New-Object System.Drawing.Point(300, $y)
    $valueLabel.Text = '50'
    $tabPage2.Controls.Add($valueLabel)

    # Add an event handler to update the value label when the trackbar value changes
    $handler = {
        param (
            $valueLabel,
            $trackBar,
            $trackbarValues
        )

        $trackBar.add_Scroll({
                $valueLabel.Text = $trackBar.Value.ToString()
                $trackbarValues[$trackBar.Tag] = $trackBar.Value

            })
    }

     

    # Create a new closure for each trackbar and value label pair
    $closure = $handler.GetNewClosure()
    $closure.Invoke($valueLabel, $trackBar, $trackbarValues)

    # Add the initial value to the trackbarValues hashtable
    $trackbarValues[$i] = $midpoint
}




# Create an "Apply" button
$applyButton = New-Object System.Windows.Forms.Button
$applyButton.Location = New-Object System.Drawing.Point(150, 360)
$applyButton.Size = New-Object System.Drawing.Size(100, 30)
$applyButton.Text = 'Apply'
$applyButton.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$applyButton.ForeColor = [System.Drawing.Color]::White
$applyButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$applyButton.FlatAppearance.BorderSize = 0
$applyButton.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(62, 62, 64)
$applyButton.FlatAppearance.MouseDownBackColor = [System.Drawing.Color]::FromArgb(27, 27, 28)
$applyButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.Controls.Add($applyButton)

# Show the form
$dialogResult = $form.ShowDialog()

# Handle the button click event
if ($dialogResult -eq [System.Windows.Forms.DialogResult]::OK) {

    if ($checkbox1.Checked) {

        #imports nip
        #get inspector and nip from github
        $ProgressPreference = 'SilentlyContinue'
        $uri = 'https://raw.githubusercontent.com/zoicware/NvidiaAutoinstall/main/Resources/nvidiaProfileInspector.exe'
        Invoke-WebRequest -Uri $uri -UseBasicParsing -OutFile "$env:TEMP\Inspector.exe"
        $uri2 = 'https://raw.githubusercontent.com/zoicware/NvidiaAutoinstall/main/Resources/Latest.nip'
        Invoke-WebRequest -Uri $uri2 -UseBasicParsing -OutFile "$env:TEMP\Latest.nip"
        
        $arguments = 's', '-load', "$env:TEMP\Latest.nip"
        & "$env:TEMP\Inspector.exe" $arguments | Wait-Process

        #removes try icon
        Reg.exe add 'HKCU\SOFTWARE\NVIDIA Corporation\NvTray' /v 'StartOnLogin' /t REG_DWORD /d '0' /f

        #cleanup files
        Remove-Item -Path "$env:TEMP\Inspector.exe" -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:TEMP\Latest.nip" -Force -ErrorAction SilentlyContinue
    }

    
    if ($checkbox2.Checked) {
        #enables legacy sharpen
        Reg.exe add 'HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS' /v 'EnableGR535' /t REG_DWORD /d '0' /f

    }

    if ($checkbox3.Checked) {
        #sets msi mode
        $instanceID = (Get-PnpDevice -Class Display).InstanceId
        Reg.exe add "HKLM\SYSTEM\ControlSet001\Enum\$instanceID\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v 'MSISupported' /t REG_DWORD /d '1' /f

    }

    if ($checkbox4.Checked) {
        #disable p0 state
        $subkeys = (Get-ChildItem -Path 'Registry::HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}' -Force -ErrorAction SilentlyContinue).Name

        foreach ($key in $subkeys) {
            if ($key -notlike '*Configuration') {
                Set-ItemProperty -Path "registry::$key" -Name 'DisableDynamicPstate' -Value 1 -Force
            }

        }
    }
   
    #looping through trackbar values and setting them in registry to the corresponding monitor 
    $i = 0
   
    foreach ($key in $trackbarValues.Keys) {
        $value = $trackbarValues[$key]
        $path = $paths[$i]
        $command = "Reg.exe add $path /v `"SaturationRegistryKey`" /t REG_DWORD /d $value /f"
        RunAsTI powershell "-nologo -windowstyle hidden -command $command"
        Start-Sleep 1
        $i++
    }

   
}