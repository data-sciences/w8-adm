<#

weaves

Function Initialize-TestModule {
    $PrivateData  = $MyInvocation.MyCommand.Module.PrivateData
    $PrivateData.Config #= ([xml](Get-Content $PSScriptRoot\Config.xml | Out-String)).Config    
}

#>

function Get-Network
{
    Param
    (
        [parameter(Mandatory=$false,
		   ValueFromPipeline=$true)]
        [String[]]
        $ComputerName = $env:ComputerName
    ) 
    
    Process
    {
	$address = $null

	# Which interfaces are up
	foreach ($iface in (Get-NetConnectionProfile)) {
	    if ($iface.InterfaceAlias -in "Wi-Fi", "Ethernet") {
		$address = Get-NetIPAddress -InterfaceAlias $iface.InterfaceAlias
	    }
	}
	$n0 = ($address | ? { $_.AddressFamily -eq "IPv4" }).IPAddress
	$n1 = (Get-IPDetails -ComputerName $n0) | Where-Object { $_.IPAddress -eq $n0 }
	$n1.Network
    }               
}

function Get-Settings {

    param(
        [Parameter(Mandatory=$false)]
        [String]
        $Name = $env:ComputerName
    )

    Begin
    {
	$OutputObj  = New-Object -Type PSObject -Property @{ 
	    name = $Name 
	}
    }

    Process
    {
	$OutputObj | Add-Member -MemberType NoteProperty -Name Network -Value (Get-Network)
        $OutputObj
    }

    End {
     $Settings0 = $OutputObj
    }
}

function Get-Slave
{
    Param
    (
        [parameter(Mandatory=$false,
		   ValueFromPipeline=$true)]
        [String[]]
        $ComputerName = $env:ComputerName
    )

    Process {
	$s = $null
	if ($ComputerName -eq $env:ComputerName) {
	    $s = New-PSSession -ComputerName $ComputerName
	} else {
	    $s = New-PSSession -Authentication "Negotiate" -ComputerName $ComputerName -Credential $script:mycreds
	}
	$s
    }
}

function Set-Slaves
{
    Param
    (
        [parameter(Mandatory=$false,
		   ValueFromPipeline=$true)]
        [String[]]
        $ComputerName = (Get-Content $PSScriptRoot\etc\slaves)
    )

    Process
    {
	if ($ComputerName -eq $env:ComputerName) {
	    $slaves0 = @(New-PSSession)
	    $Settings0 | Add-Member -Force -MemberType NoteProperty -Name pss -Value $slaves0
	    $slaves0 = @(New-CimSession)
	    $Settings0 | Add-Member -Force -MemberType NoteProperty -Name cims -Value $slaves0
	} else {
	    (Set-Slaves0)
	}
    }
}

function Set-Slaves0
{
    Param
    (
        [parameter(Mandatory=$false,
		   ValueFromPipeline=$true)]
        [String[]]
        $ComputerName = (Get-Content $PSScriptRoot\etc\slaves)
    )

    Begin
    {
	$lnetwork = $Settings0.Network
        $lnetwork = $lnetwork -replace "\.0$", ".*"
    }
    
    Process
    {
	$slaves = @()

	$slaves0 = (Test-connection -Count 1 -ComputerName $ComputerName)
	foreach ($h0 in ($slaves0)) {
	    if ($h0.IPV4Address.IPAddressToString -like $lnetwork) {
		$slaves += $h0.Address
	    }
	}
	$slaves
    }

    End
    {
	$slaves0 = New-PSSession -Authentication "Negotiate" -ComputerName $slaves -Credential $mycreds -ErrorAction SilentlyContinue -ErrorVariable err

	$Settings0 | Add-Member -Force -MemberType NoteProperty -Name pss -Value $slaves0

	$slaves0 = New-CimSession -Authentication "Negotiate" -ComputerName $slaves -Credential $mycreds -ErrorAction SilentlyContinue -ErrorVariable err

	$Settings0 | Add-Member -Force -MemberType NoteProperty -Name cims -Value $slaves0
    }

}

function Set-HostsFile
{

}


Export-ModuleMember Set-Slaves, Get-Network, Get-Settings, Get-Slave