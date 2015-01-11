<#

weaves

Remote script

#>

# Testing on master

remove-module DataSciences0
$env:PSModulePath = 'C:\Users\Walter\Documents\WindowsPowerShell\Modules;C:\Program Files\WindowsPowerShell\Modules;C:\windows\system32\WindowsPowerShell\v1.0\Modules\'

# Script start

$secpasswd = ConvertTo-SecureString 'borrower' -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ("borrower", $secpasswd)

Remove-PSDrive -name "services1" -ErrorAction SilentlyContinue
New-PSDrive –Name “services1” -PSProvider FileSystem -Scope "Script" –Root “\\wally\share” 

$env:PSModulePath = "\\wally\share\income\adm\script;$env:PSModulePath"

cd \\wally\share\income\adm\script

Import-Module DataSciences0

Get-ds0_Settings
Set-ds0_Slaves -ComputerName $env:ComputerName

$Settings0

Disable-NetAdapterBinding -CimSession ($Settings0.cims) -Name "Ethernet" -ComponentID ms_tcpip6 
Disable-NetAdapterBinding -CimSession ($Settings0.cims) -Name "Wi-Fi" -ComponentID ms_tcpip6

$dnses = (Get-DnsClientServerAddress -InterfaceAlias "Ethernet").ServerAddresses
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -CimSession ($Settings0.cims) -ServerAddresses $dnses




