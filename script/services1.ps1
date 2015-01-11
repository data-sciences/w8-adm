<#

weaves

Remote script

#>

# Testing on master

remove-module DataSciences0

$env:PSModulePath = 'C:\Users\Walter\Documents\WindowsPowerShell\Modules;C:\Program Files\WindowsPowerShell\Modules;C:\windows\system32\WindowsPowerShell\v1.0\Modules\'

$secpasswd = ConvertTo-SecureString 'borrower' -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ("borrower", $secpasswd)

Start-Transaction

Remove-PSDrive -name "services1" -ErrorAction SilentlyContinue
New-PSDrive –Name “services1” -PSProvider FileSystem -Scope "Script" –Root “\\wally\share”

$env:PSModulePath = "\\wally\share\income\adm\script;$env:PSModulePath"

cd \\wally\share\income\adm\script

Import-Module DataSciences0

Get-ds0_Settings
Set-ds0_Slaves

$Settings0

Undo-Transaction
