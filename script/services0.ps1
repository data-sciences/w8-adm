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

Get-Service |  Where-Object {$_.name -eq "WinRM"}

# Set the firewall off
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
Set-NetFirewallProfile -Profile Domain,Private -Enabled False

# Check network type is private

Get-NetConnectionProfile

# Make sure all the interfaces are Private when we enable WinRM

foreach ($iface in (Get-NetConnectionProfile)) {
    if ($iface.InterfaceAlias -in "Ethernet", "Wi-Fi") {
        Write-Host $iface.InterfaceAlias
        Set-NetConnectionProfile -InterfaceAlias $iface.InterfaceAlias -NetworkCategory Private
    }

    if ($iface.InterfaceAlias -like "*VMnet*") {
        Write-Host $iface.InterfaceAlias
        Set-NetConnectionProfile -InterfaceAlias $iface.InterfaceAlias -NetworkCategory Private
    }
}

# Stop these services.

stop-Service WSearch
Set-Service WSearch -StartupType Disabled

Get-Service |  Where-Object {$_.name -eq "WSearch"}

stop-Service WMPNetworkSvc
Set-Service WMPNetworkSvc -StartupType Disabled

Get-Service |  Where-Object {$_.name -eq "WMPNetworkSvc"}

Enable-PSRemoting -Force -SkipNetworkProfileCheck
