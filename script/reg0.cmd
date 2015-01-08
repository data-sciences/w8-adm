@echo on

for /f %%i in (..\etc\servers) do @echo %%i

for /f %%i in (..\etc\servers) do reg query \\%%i\HKLM\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell 

for /f %%i in (..\etc\servers) do reg add \\%%i\HKLM\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell /v ExecutionPolicy /t REG_SZ /d Unrestricted /f 