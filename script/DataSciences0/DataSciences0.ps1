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

    Begin
    {
	$lnetwork = $Settings0.Network
        $lnetwork = $lnetwork -replace "\.0$", ".*"
    }
    
    Process
    {
	$slaves = @()

	$slaves0 = (Test-connection -Count 1 -Quiet -ComputerName $ComputerName)

	foreach ($h0 in ($slaves0)) {
	    if ($h0.IPV4Address.IPAddressToString -like $lnetwork) {
		$slaves += $h0.Address
	    }
	}
	$slaves
    }

    End
    {
	$slaves0 = @()
	foreach ($slave in $slaves) {
	    try {
		$err = $null
		$s = New-PSSession -Authentication "Negotiate" -ComputerName $slave -Credential $script:mycreds -ErrorAction SilentlyContinue -ErrorVariable err
		if ($err) { 
		    continue
		}
		
		$o = New-Object -Type PSObject -Property @{ 
		    name = $slave
	            creds = $s
		}
		$slaves0 += $o
	    } catch {
		write-host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
		write-host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red
	    }
	}
	
    	$Settings0 | Add-Member -MemberType NoteProperty -Name Slaves -Value $slaves0
    }

}


Export-ModuleMember Set-Slaves, Get-Network, Get-Settings