* About 

weaves
Data Sciences Consulting

Basic configuration for a cheap Windows 8.1 laptop to be part of a VM cluster

* Operation

The scripts are run in this order from an Adminstrator command prompt
from this directory

 reg1.cmd
 services0 .\services0.ps1

* Installation using TightVNC

You can install remotely using TightVNC. This doesn't have an easy means of launching an
Administrator prompt, so 

On the desktop, mount \\wally\share
In Explorer, locate the Shortcut income\etc\su.lnk
Launch that and run as owner.

 net use z: \\wally\share /user:wally\borrower 

enter the borrower password. Then 

 z:
 cd income\adm\script

and run the scripts.

* Actions

** reg1.cmd 

Allow PowerShell scripts
Provide an Administrator Prompt on the desktop

** services0.ps1

*** Enable services

Enable and auto-start 

Windows Remote Management
Remote Registry

*** Disable services

Windows search
Windows Media Player search

*** Firewall

Disabled for Private and Domain
Enabled for Public

*** Network Category

Set Ethernet or Wi-Fi as a Private Network

*** DNS

