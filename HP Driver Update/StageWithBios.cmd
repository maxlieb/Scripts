cd /D "%~dp0"
powershell.exe -ExecutionPolicy Bypass -Command "& '.\Invoke-HPDriverUpdateWithBios.ps1' -RunMode Stage"