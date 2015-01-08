<#

weaves

Demonstrate how to invoke commands remotely without the remote machine being in the domain.

You may need to use the winrm command to add to TrustedHosts.

#>

$secpasswd = ConvertTo-SecureString '3Ip$7tsA' -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ("owner", $secpasswd)

$abdul = New-PSSession -Authentication "Negotiate" -ComputerName abdul -Credential $mycreds

$ScriptBlockContent = {
    param ($MessageToWrite, $mesg)
    Write-Host $MessageToWrite 
    Write-Host $mesg
    }

Invoke-Command -Session $abdul -ScriptBlock $ScriptBlockContent -ArgumentList "DNS1", "DNS2"

$job = Test-connection -Count 1 -ComputerName (Get-Content ..\etc\slaves) -asJob

if ($job.JobStateInfo.State -ne "Running") { $results = Receive-Job $job }
