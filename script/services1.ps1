<#

weaves

Enable PowerShell scripts in the registry
Then run this to set up services.

#>

Set-Service RemoteRegistry -StartupType Automatic
start-Service RemoteRegistry

Get-Service |  Where-Object {$_.name -eq "RemoteRegistry"}

Set-Service WinRM -StartupType Automatic
start-Service WinRM 

Get-Service |  Where-Object {$_.name -eq "WinRM "}

# Stop these.

stop-Service WSearch
Set-Service WSearch -StartupType Disabled

Get-Service |  Where-Object {$_.name -eq "WSearch"}

stop-Service WMPNetworkSvc
Set-Service WMPNetworkSvc -StartupType Disabled

Get-Service |  Where-Object {$_.name -eq "WMPNetworkSvc"}

