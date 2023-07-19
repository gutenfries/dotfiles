#! /usr/bin/env pwsh

# External Imports:
Import-Module -Name PSReadLine
Import-Module -Name CompletionPredictor

# Env:
$env:PYTHONIOENCODING = "utf-8"
$env:PYTHON_HOST_PROG = "C:\Python311\"
$env:PYTHON3_HOST_PROG = "C:\Python311\"

# User Defined Functions:
function Invoke-Admin ()
{
	if ($Args.Count -eq 0)
	{
		return "Invoke-Admin: No command specified"
	} else
	{
		# group arguments into a single string
		$command = $Args[0]
		$arguments = $Args[1..$Args.Count]
		$arguments = $arguments -join " "

		# invoke command
		try
		{
			$process = Start-Process -FilePath $($command) -ArgumentList $arguments -Verb RunAs -Wait -PassThru

			return "completed with exit code ${process.ExitCode}"
		} catch
		{
			return "Error: $_"
		}
	};
};

function Invoke-Batstat ()
{
	WMIC PATH Win32_Battery Get EstimatedChargeRemaining
};

function Invoke-ls()
{
	try
	{
		# default to showing all files
		& $ENV:USERPROFILE\.cargo\bin\lsd.exe -A $Args
	} catch
	{
		Write-Host "Warning: LSD not installed" -ForegroundColor Yellow
		Get-ChildItem $Args
	}
};

function Set-Location-Up()
{
	Set-Location ..
}


function Invoke-rm()
{
	Remove-Item $Args -Force -Recurse
}

# Aliases:
Set-Alias sudo Invoke-Admin
Set-Alias batstat Invoke-Batstat
Set-Alias battery Invoke-Batstat
Set-Alias ls Invoke-ls
Set-Alias .. Set-Location-Up
Set-Alias rm Invoke-rm

######################################################################

function Init()
{
	# set for starship
	$OS = $env:OS
	Set-Alias $OS $env:OS
	$ENV:STARSHIP_CONFIG = "$HOME\.config\starship.toml"
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

		if ($cursor -lt $line.Length)
		{
			[Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar($key, $arg)
		} else
		{
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

		if ($cursor -lt $line.Length)
		{
			[Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar($key, $arg)
		} else
		{
			[Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion($key, $arg)
		}
	}
}

Init
