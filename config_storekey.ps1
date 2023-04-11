param (
    [Parameter(Mandatory=$true)]
    [string]$KEY = "STOREKEY"
)
$error.clear()
PSexec.exe

if($error.count -eq 0){
  Set-ExecutionPolicy Bypass -Scope Process -Force
  PsExec.exe -s -accepteula 'C:\Program Files\FSLogix\Apps\frx.exe' add-secure-key -key='connectionString' -value=$KEY
} else {
  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
  choco install psexec
  PsExec.exe -s -accepteula 'C:\Program Files\FSLogix\Apps\frx.exe' add-secure-key -key='connectionString' -value=$KEY
}
