# Windows profile setup for the Admin elevated account env.

# You can find the file when running as administrator by executing:
# $PROFILE

# Usually it will be something like this:
#C:\Users\RobBos\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

# To edit and save the file, run in elevated mode:
# Start-Process code -ArgumentList "$PROFILE" -Verb RunAs

function LowPower() {

    $processes = Get-Process
    StopProcesses($processes)

    # do it twice to prevent some process that have not been started yet
    Write-Host "Waiting and retrying to stop processes once more"
    Start-Sleep -s 5
    $processes = Get-Process
    StopProcesses($processes)
}

function StopProcesses($processes) {
    StopProcessWithName -processes $processes -name "Teams"
    StopProcessWithName -processes $processes -name "Box"
    StopProcessWithName -processes $processes -name "Box.Desktop.UpdateService"
    StopProcessWithName -processes $processes -name "ZoomIt64"
    StopProcessWithName -processes $processes -name "Slack"
    StopProcessWithName -processes $processes -name "PowerToys"
    StopProcessWithName -processes $processes -name "OneDrive"
    StopProcessWithName -processes $processes -name "LogiFacecamService"
    StopProcessWithName -processes $processes -name "Krisp"
    StopProcessWithName -processes $processes -name "OneDrive"
    StopProcessWithName -processes $processes -name "iCloudDrive"
    StopProcessWithName -processes $processes -name "iCloudPhotos"
    StopProcessWithName -processes $processes -name "iCloudServices"
    StopProcessWithName -processes $processes -name "DropboxUpdate"
    StopProcessWithName -processes $processes -name "ApplePhotoStreams"
    StopProcessWithName -processes $processes -name "Focusrite Notifier"
    StopProcessWithName -processes $processes -name "DropboxUpdate"
    StopProcessWithName -processes $processes -name "DisplayLinkTrayApp"
}

function StopProcessWithName {
    param (
        $processes,
        [string] $name
    )

    $processes | Where-Object {$_.ProcessName -eq $name} | ForEach-Object { Write-Host "Stopping process with name [$name]"; Stop-Process $_ -Force}
}
# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}