param (
    [Parameter(Mandatory=$true)]
    [string]$KEY
)
if ($KEY -eq $null) {Write-Output "Store Key not set"}
else {
    try {
        Write-Host "Executing frx.exe via psexec"
        & .\psexec.exe -s -accepteula 'C:\Program Files\FSLogix\Apps\frx.exe' add-secure-key -key=connectionString -value=$KEY
    } catch { Write-Output "Executing frx.exe via psexec failed" }
}

Write-Output 'Configure FSLogix ...'
New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name 'Enabled' -PropertyType:DWORD -Value 1 -Force
New-ItemProperty -Path "HKLM:\Software\FSLogix\Profiles" -Name "CCDLocations" -PropertyType:String -Value "type=azure,connectionString=""|fslogix/connectionString|""" -Force
New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name 'VolumeType' -PropertyType:String -Value vhdx -Force
New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name 'DeleteLocalProfileWhenVHDShouldApply' -PropertyType:dword -Value 1 -Force
New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name 'FlipFlopProfileDirectoryName' -PropertyType:dword -Value 1 -Force
Write-Output 'FsLogix complete ...'
