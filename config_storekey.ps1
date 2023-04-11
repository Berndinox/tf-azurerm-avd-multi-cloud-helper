param (
    [Parameter(Mandatory=$true)]
    [string]$KEY = "STOREKEY"
)
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-WebRequest https://github.com/Berndinox/tf-azurerm-avd-multi-cloud-helper/raw/main/PsExec.exe -OutFile "PsExec.exe"
PsExec.exe -s -accepteula 'C:\Program Files\FSLogix\Apps\frx.exe' add-secure-key -key='connectionString' -value=$KEY
