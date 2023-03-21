powershell
$username = "mleffler@beconproperty.com"
$password = "Beacon1244"

$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "HomepageIsNewTabPage" -Value 0 -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "Homepage" -Value "https://help.beaconproperty.com" -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "RestoreOnStartup" -Value 4 -Force

$msgBoxTitle = "Microsoft Edge Homepage and Start Page Update"
$msgBoxBodySuccess = "The homepage and start page have been updated successfully for all users."
$msgBoxBodyFailure = "The update of homepage and start page failed. Please check the credentials and try again."

$allUsers = Get-ChildItem 'C:\Users' | ForEach-Object { $_.Name }
foreach ($user in $allUsers) {
    $userProfile = "C:\Users\$user"
    try {
        Start-Process -FilePath "powershell" -ArgumentList "Start-Process 'msedge.exe' '-restore-last-session' -WindowStyle Maximized" -Credential $cred -ErrorAction Stop -WorkingDirectory $userProfile
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show($msgBoxBodyFailure, $msgBoxTitle, 'OK', 'Error')
        break
    }
}

[System.Windows.Forms.MessageBox]::Show($msgBoxBodySuccess, $msgBoxTitle, 'OK', 'Information')
