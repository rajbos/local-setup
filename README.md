# local-setup
Repository with all info about my local setup and install scripts to use

# Software to install
Todo: Export package.json from Chocolatey to this repo through the [UI](https://docs.chocolatey.org/en-us/chocolatey-gui/user-interface/main-window/actions/export)

``` PowerShell
choco install chocolateygui
```

# Git setup

## Git default settings

```
git config --global user.name "Rob Bos"
git config --global user.email "raj.bos@gmail.com"
git config --global pull.rebase true
git config --global core.longpaths true
```

## Git cleanup script
Easily remove all local branches that had an remote, but no longer exists on that origin:
```
git config --global alias.cleanup "!git remote prune origin && git branch -vv | grep ''': gone]''' | awk '''{print $1}''' | xargs -r git branch -D"
```

## GPG Signing
```
# get key from here: 
gpg --list-secret-keys --keyid-format LONG
# configure Git to find the key and set the correct program for en/decryption
git config --global user.signingkey ******
git config --global commit.gpgsign true
git config --global gpg.program "C:\Program Files (x86)\GnuPG\bin\gpg.exe"
```

## Chrome settings
go to `chrome://settings/content/notifications` => "Sites can ask to send notifications" -> Off


## Multiple IR Camera's & Windows Hello
Multiple IR Camera's will not work with Windows Hello: the build in one for the laptop will be used for setting up Windows Hello. The only way to get around this is to disable the integrated camera, which can be done with this PowerShell command:

``` powershell
Disable-PnpDevice -InstanceId (Get-PnpDevice -FriendlyName '*integrated webcam*' -Class Camera -Status OK).InstanceId -confirm:$false
```

Be advised, this will completely disable that camera, so if you want to use it, you need to run the enable command as well: 

``` powershell
Enable-PnpDevice -InstanceId (Get-PnpDevice -FriendlyName '*integrated webcam*' -Class Camera -Status OK).InstanceId -confirm:$false
```

# Terminal Setup
Install both oh-my-posh and posh-git:
``` PowerShell
Install-Module posh-git -Scope CurrentUser
Install-Module oh-my-posh -Scope CurrentUser
```

1. Get the Windows Terminal (Store app)
1. Install a font from [Nerd Fonts](https://www.nerdfonts.com/)
1. Setup the font in the terminal
1. Update your PowerShell profile

## PowerShell Profile
``` PowerShell
code $PROFILE
# add the modules and theme
Import-Module oh-my-posh
Import-Module posh-git
Set-PoshPrompt -Theme Agnoster # pick one from Get-PoshThemes
# save the file

# reload your profile
. $profile
```` 