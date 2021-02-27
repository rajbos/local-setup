# local-setup
Repository with all info about my local setup and install scripts to use


# Software to install
|Name|Link|Available in Chocolatey?|
|---|---|---|
|Windows Terminal (Store App)|||
|Git for Windows|||
|Edge|||
|Slack|||
|Teams|||
|VsCode|||
|Visual Studio|||
|Calendar & Mail (Store App)|||
|GPG4Win|https://www.gpg4win.org/|?|

# Git setup
## Git cleanup script
```
alias.cleanup=!git remote prune origin && git branch -vv | grep ''': gone]''' | awk '''{print $1}''' | xargs -r git branch -D
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
