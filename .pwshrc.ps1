Import-Module -Name PSReadLine
Import-Module -Name CompletionPredictor

# (neo)vim things...
$env:PYTHONIOENCODING = "utf-8"
$env:PYTHON_HOST_PROG = "C:\Python311\"
$env:PYTHON3_HOST_PROG = "C:\Python311\"

function Invoke-Admin () {
        if ($Args.Count -eq 0) {
                return "Invoke-Admin: No command specified"
        }
        else {
                # group arguments into a single string
                $command = $Args[0]
                $arguments = $Args[1..$Args.Count]
                $arguments = $arguments -join " "

                # invoke command
                try {
                        $process = Start-Process -FilePath $command -ArgumentList $arguments -Verb RunAs -Wait -PassThru
                        # return "Exit: $process.ExitCode"
                        return $process.ExitCode
                }
                catch {
                        return "Error: $_"
                }
        };
};

Set-Alias sudo Invoke-Admin

function Invoke-Batstat () {
        WMIC PATH Win32_Battery Get EstimatedChargeRemaining
};

$lsd = "$HOME\dev\lsd\target\release\lsd.exe"
$lsd_debug = "$HOME\dev\lsd\target\debug\lsd.exe"

Set-Alias batstat Invoke-Batstat
Set-Alias battery Invoke-Batstat

function Invoke-ls() {
        try {
                # default to showing all files
                & $lsd -A $Args
        }
        catch {
                # try to use debug version if there is no release build
                try {
                        & $lsd_debug -A $Args
                }
                catch {
                        Write-Host "Warning: No batch operation, program, or executable matching the pattern of $lsd or $lsd_debug found...`n Please update your powershell profile" -ForegroundColor Yellow
                        Get-ChildItem $Args
                }
        }
};

function Invoke-lsd() {
        try {
                & $lsd $Args
        }
        catch {
                try {
                        & $lsd_debug $Args
                }
                catch {
                 Write-Host "Warning: No batch operation, program, or executable matching the pattern of $lsd or $lsd_debug found...`n Please update your powershell profile" -ForegroundColor Yellow
                 Get-ChildItem $Args
                }
        }
};

Set-Alias lsd Invoke-lsd
Set-Alias ls Invoke-ls

function Set-Location-Up() {
        Set-Location ..
}

Set-Alias .. Set-Location-Up

function Invoke-rm() {
        Remove-Item $Args -Force -Recurse
}

Set-Alias rm Invoke-rm

# set for starship
$OS = $env:OS
Set-Alias $OS $env:OS
$ENV:STARSHIP_CONFIG = "$HOME\starship.toml"
Invoke-Expression (& starship init powershell)

# manages the window title:
$host.UI.Write("`e]0;$pwd`a")

Invoke-Expression "$(thefuck --alias)"

# Config PSReadLine
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
# Set-PSReadLineOption -PredictionSource History
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
# `ForwardChar` accepts the entire suggestion text when the cursor is at the end of the line.
# This custom binding makes `RightArrow` behave similarly - accepting the next word instead of the entire suggestion text.
Set-PSReadLineKeyHandler -Key Shift+RightArrow `
        -BriefDescription ForwardCharAndAcceptNextSuggestionWord `
        -LongDescription "Move cursor one character to the right in the current editing line and accept the next word in suggestion when it's at the end of current editing line" `
        -ScriptBlock {
        param($key, $arg)

        $line = $null
        $cursor = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

        if ($cursor -lt $line.Length) {
                [Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar($key, $arg)
        }
        else {
                [Microsoft.PowerShell.PSConsoleReadLine]::AcceptNextSuggestionWord($key, $arg)
        }
}

Set-PSReadLineKeyHandler -Key Shift+Tab `
        -BriefDescription ForwardCharAndAcceptNextSuggestionWord `
        -LongDescription "Move cursor one character to the right in the current editing line and accept the next word in suggestion when it's at the end of current editing line" `
        -ScriptBlock {
        param($key, $arg)

        $line = $null
        $cursor = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

        if ($cursor -lt $line.Length) {
                [Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar($key, $arg)
        }
        else {
                [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion($key, $arg)
        }
}
