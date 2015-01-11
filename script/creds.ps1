<#

weaves

Demonstrate how to invoke commands remotely without the remote machine being in the domain.

You may need to use the winrm command to add to TrustedHosts.

#>

$secpasswd = ConvertTo-SecureString '3Ip$7tsA' -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ("owner", $secpasswd)

$abdul = New-PSSession -Authentication "Negotiate" -ComputerName abdul -Credential $mycreds

$ScriptBlockContent = {
    param ($ip, $name)
    Add-Content -Encoding ASCII -Path "c:\Windows\System32\drivers\etc\hosts" -Value "$ip $name"
    }

Invoke-Command -Session $abdul -ScriptBlock $ScriptBlockContent -ArgumentList "172.24.29.17", "l3.site"

<#

ping test: what hosts are up?

The orega.com network returns a ping for every host! 

#>

function FileSize3 ($dir, $minSize)
{
  dir $dir
  where {$_.length -gt $minsize}
}

$slaves = @()

$slaves0 = Test-connection -Count 1 -ComputerName (Get-Content ..\etc\slaves)

foreach ($h0 in ($slaves0)) {
    if ($h0.IPV4Address.IPAddressToString -like '172.24.29.*') {
        $slaves += $h0.Address
    }
}

Write-Host $slaves

function Pinger($ComputerName) 
{
    $slaves = @()

    $slaves0 = Test-connection -Count 1 -ComputerName $ComputerName

    foreach ($h0 in ($slaves0)) {
	if ($h0.IPV4Address.IPAddressToString -like '172.24.29.*') {
            $slaves += $h0.Address
	}
    }

}



function sobject {
    param(
          [Parameter(Mandatory=$true)]
          [String]$name
    )
    
    $s0 = $sobject.psobject.copy()
    $s0.name = $name
    $s0.network = "172.24.29.0"
    $s0
}

function Network0

foreach ($iface in (Get-NetConnectionProfile)) {
    if ($iface.InterfaceAlias -in "Ethernet", "Wi-Fi") {
        Write-Host $iface.InterfaceAlias
        Set-NetConnectionProfile -InterfaceAlias $iface.InterfaceAlias -NetworkCategory Private
    }


# trying to change the lid setting

$Name = @{
    Namespace = 'root\cimv2\power'
}
$Id = (Get-WmiObject @Name Win32_PowerPlan -Filter "ElementName LIKE 'High%'") -replace '.*(\{.*})"', '$1'
$Lid = '{5ca83367-6e45-459f-a27b-476b1d01c936}'
Get-WmiObject @Name Win32_PowerSettingDataIndex -Filter "InstanceId LIKE '%$Id\\AC\\$Lid'" | 
    Set-WmiInstance -Arguments @{ SettingIndexValue = 2 }

(Get-WmiObject @Name Win32_PowerPlan -Filter "ElementName LIKE 'High%'")

$class = ([wmi] '\root\cimv2\power:Win32_PowerSettingDataIndex.InstanceID="Microsoft:PowerSettingDataIndex\\{8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c}\\DC\\{5ca83367-6e45-459f-a27b-476b1d01c936}"')
$class.SettingIndexValue = 0
$class.Put()

$DO_NOTHING = 2

$activePowerPlan = Get-WmiObject -Namespace "root\cimv2\power" Win32_PowerPlan -Filter "ElementName LIKE 'High%'"
$rawPowerPlanID = $activePowerPlan | select -Property InstanceID
$rawPowerPlanID -match '\\({.*})}'
$powerPlanID = $matches[1]

# The .GetRelated() method is an inefficient approach, i'm looking for a needle and this haystack is too big. Can i go directly to the object instead of searching?
$lidCloseActionOnACPower = $activePowerPlan.GetRelated("win32_powersettingdataindex") | where {$_.InstanceID -eq "Microsoft:PowerSettingDataIndex\$powerPlanID\AC\{5ca83367-6e45-459f-a27b-476b1d01c936}"}

$lidCloseActionOnACPower | select -Property SettingIndexValue
$lidCloseActionOnACPower.SettingIndexValue = $DO_NOTHING
$lidCloseActionOnACPower.put()
