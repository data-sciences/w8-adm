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
