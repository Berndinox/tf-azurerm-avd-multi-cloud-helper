param (
    [Parameter(Mandatory=$true)]
    [string]$KEY
)
if ($variable -eq $null) {Write-Error "Store Key not set"; break}
try { & .\psexec.exe -s -accepteula 'C:\Program Files\FSLogix\Apps\frx.exe' add-secure-key -key='connectionString' -value=$KEY }
catch {Write-Error "Executing frx.exe via psexec failed"}
