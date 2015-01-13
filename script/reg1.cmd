@echo off

rem weaves
rem Some local configuration

copy ..\etc\su.lnk c:\Users\Public\Desktop

reg add HKLM\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell /v ExecutionPolicy /t REG_SZ /d Unrestricted /f

