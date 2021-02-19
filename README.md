# local-setup
Repository with all info about my local setup and install scripts to use


# Software to install
- Windows Terminal (Store App)
- Git for Windows
- Edge
- Slack
- Teams
- VsCode
- Visual Studio
- Calender & Mail (Store App)

# Git setup
## Git cleanup script
```
alias.cleanup=!git remote prune origin && git branch -vv | grep ''': gone]''' | awk '''{print $1}''' | xargs -r git branch -D
```
