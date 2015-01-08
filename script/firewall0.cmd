@echo off
rem enable the firewall for remote admin

netsh firewall set service type = remoteadmin mode = enable
