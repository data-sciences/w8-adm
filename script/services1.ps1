<#

weaves

Use CIM session to set clients

Turn IPv6 off.
Copy over DNSes.

#>

Get-ds0_Settings
Set-ds0_Slaves -ComputerName $env:ComputerName

$Settings0

Disable-NetAdapterBinding -CimSession ($Settings0.cims) -Name "Ethernet" -ComponentID ms_tcpip6 
Disable-NetAdapterBinding -CimSession ($Settings0.cims) -Name "Wi-Fi" -ComponentID ms_tcpip6

$dnses = (Get-DnsClientServerAddress -InterfaceAlias "Ethernet").ServerAddresses

Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -CimSession ($Settings0.cims) -ServerAddresses $dnses

