<#

weaves

Use CIM session to set clients

Turn IPv6 off.
Copy over DNSes.

#>

Get-ds0_Settings
Set-ds0_Slaves -ComputerName (Get-Content ..\etc\slaves)
# Set-ds0_Slaves -ComputerName $env:ComputerName

$Settings.cims

Disable-NetAdapterBinding -CimSession ($Settings0.cims) -Name "Ethernet" -ComponentID ms_tcpip6 
Disable-NetAdapterBinding -CimSession ($Settings0.cims) -Name "Wi-Fi" -ComponentID ms_tcpip6

$dnses = (Get-DnsClientServerAddress -InterfaceAlias "Ethernet").ServerAddresses

$host0 = (Get-CimSession | ? { $_.ComputerName -eq "abdul" })[-1]

$dnses = $null
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -CimSession $host0 -ServerAddresses $dnses

$ethernet = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter DHCPEnabled=True -ComputerName $host0.ComputerName -Credential $mycreds | ? { $_.IPAddress }
$ethernet.RenewDHCPLease()

(Get-DnsClientServerAddress -CimSession $host0 -InterfaceAlias "Ethernet").ServerAddresses

