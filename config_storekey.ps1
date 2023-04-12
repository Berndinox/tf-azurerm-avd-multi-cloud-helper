param (
    [Parameter(Mandatory=$true)]
    [string]$KEY
)
if ($KEY -eq $null) {Write-Output "Store Key not set"; break}
try {& .\psexec.exe -s -accepteula 'C:\Program Files\FSLogix\Apps\frx.exe' add-secure-key -key=connectionString -value=$KEY}
catch {Write-Output "Executing frx.exe via psexec failed"}

# Remove if Custom Image - from here
Invoke-WebRequest -Uri "https://aka.ms/fslogix_download" -OutFile "C:\Temp\fslogix.zip"
Expand-Archive "C:\Temp\fslogix.zip" -DestinationPath C:\Temp\FSLogix
& C:\Temp\FSLogix\x64\Release\FSLogixAppsSetup.exe /install /quiet /norestart /log c:\temp\fslogix.txt

Start-Sleep -s 20

while($true) { 
    $Log = Get-Content c:\temp\fslogix.txt -Tail 2
    If ($log | Select-String -Pattern 'Exit code') { 
        break
    } Else 
    { 
        Write-Output 'FSLogix installation running'; Start-Sleep -s 10 
    } 
}

Write-Output 'Configure FSLogix ...'
New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name 'Enabled' -PropertyType:DWORD -Value 1 -Force
New-ItemProperty -Path "HKLM:\Software\FSLogix\Profiles" -Name "CCDLocations" -PropertyType:String -Value "type=azure,connectionString=""|fslogix/connectionString|""" -Force
New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name 'VolumeType' -PropertyType:String -Value vhdx -Force
New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name 'DeleteLocalProfileWhenVHDShouldApply' -PropertyType:dword -Value 1 -Force
New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name 'FlipFlopProfileDirectoryName' -PropertyType:dword -Value 1 -Force
Write-Output 'FsLogix complete ...'
