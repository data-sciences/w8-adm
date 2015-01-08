$secpasswd = ConvertTo-SecureString '3Ip$7tsA' -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ("owner", $secpasswd)

$abdul = New-PSSession -Authentication "Negotiate" -ComputerName abdul -Credential $mycreds

$message = "DNS" 
$ScriptBlockContent = {
    param ($MessageToWrite)
    Write-Host $MessageToWrite 
    }

Invoke-Command -Session $abdul -ScriptBlock $ScriptBlockContent -ArgumentList $message