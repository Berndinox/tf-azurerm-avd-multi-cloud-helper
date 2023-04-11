param (
    [Parameter(Mandatory=$true)]
    [string]$KEY = "STOREKEY"
)
& .\psexec.exe -s -accepteula 'C:\Program Files\FSLogix\Apps\frx.exe' add-secure-key -key='connectionString' -value=$KEY
