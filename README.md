# dotfiles

## Windows TODO list

Things you are going to have to do to make all the dotfiles work without error:

You will have to run the following to create a symlink to the `pwshrc.ps1` file in the `$HOME` directory.

### PowerShell

```powershell
# rename the existing profile file if it exists
Rename-Item -Path $HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 -NewName Microsoft.PowerShell_profile.ps1.bak
# create empty profile file
New-Item -ItemType File -Path $HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
# rename the .pwshrc
Rename-Item -Path $HOME\.pwshrc -NewName pwshrc.tmp
# create the symlink
New-Item -ItemType SymbolicLink -Path $HOME\pwshrc.ps1 -Value $HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
# copy the contents of the .pwshrc.tmp to the new .pwshrc file
Get-Content $HOME\pwshrc.tmp | Out-File $HOME\pwshrc.ps1
```

If you cannot get PowerShell to run the above commands, you can run, you can use another shell to do the same thing as above.

### CMD

```cmd
REM rename the existing profile file if it exists
ren %USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 Microsoft.PowerShell_profile.ps1.bak
REM create empty profile file
type nul > %USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
REM rename the .pwshrc
ren %USERPROFILE%\.pwshrc pwshrc.tmp
REM create the symlink
mklink %USERPROFILE%\pwshrc.ps1 %USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
REM copy the contents of the .pwshrc.tmp to the new .pwshrc file
copy %USERPROFILE%\pwshrc.tmp %USERPROFILE%\pwshrc.ps1
```

#### Git Bash

```bash
# rename the existing profile file if it exists
mv $HOME/Documents/PowerShell/Microsoft.PowerShell_profile.ps1 $HOME/Documents/PowerShell/Microsoft.PowerShell_profile.ps1.bak
# create empty profile file
touch $HOME/Documents/PowerShell/Microsoft.PowerShell_profile.ps1
# rename the .pwshrc
mv $HOME/.pwshrc $HOME/.pwshrc.tmp
# create the symlink
ln -s $HOME/pwshrc.ps1 $HOME/Documents/PowerShell/Microsoft.PowerShell_profile.ps1
# copy the contents of the .pwshrc.tmp to the new .pwshrc file
cat $HOME/.pwshrc.tmp > $HOME/pwshrc.ps1
```
