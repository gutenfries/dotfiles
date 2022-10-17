<#
SPDX-License-Identifier: MIT
Author: Mark Gutenberger <mark-gutenberger@outlook.com>
clang-format.ps1 (c) 2022
Created:  2022-02-28T13:59:28.751Z
Modified: 2022-03-04T14:03:03.409Z
#>


function Main() {
	#! /bin/bash
	bash . ./clang-format.sh
	exit
}

function Find-Env() {
	try {
		wsl -l -v
	}
	catch {
		Write-Error "[clang-format.ps1]: Warn: `"WSL is not installed.`"" -ForegroundColor yellow
	}
	finally {
		try {
			bash --version
		}
		catch {
			Write-Error "[clang-format.ps1]: Warn: `"No bash enviroment is installed`"" -ForegroundColor Yellow
			exit
		}
	}
};

try {
	if (Find-Env) {
		[string]$WorkingDir = Get-Location
		$WorkingDir = $WorkingDir.Replace('\', '/')
		Main
	}
	else {
		Write-Error "[clang-format.ps1]: Error: `"No GNU enviroment available.`"" -ForegroundColor Red
		exit
	}
}
catch {
	Write-Error "[clang-format.ps1]: Error: clang-format not found"
}
