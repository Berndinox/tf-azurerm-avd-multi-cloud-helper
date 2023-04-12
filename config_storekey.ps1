param (
    [Parameter(Mandatory=$true)]
    [string]$KEY
)

Write-Output "FSLogix Config Start"

if ($KEY -eq $null) {Write-Output "Store Key not set"}
else {
    try {
        Write-Output "Executing frx.exe"
        Start-Process -FilePath "C:\Program Files\FSLogix\Apps\frx.exe" -Wait -ArgumentList "add-secure-key -key=connectionString -value=$Key"
    } catch { Write-Output "Executing frx.exe failed" }
}

Write-Output 'Set RegHives'
New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name 'Enabled' -PropertyType:DWORD -Value 1 -Force
New-ItemProperty -Path "HKLM:\Software\FSLogix\Profiles" -Name "CCDLocations" -PropertyType:String -Value "type=azure,connectionString=""|fslogix/connectionString|""" -Force
New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name 'VolumeType' -PropertyType:String -Value vhdx -Force
New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name 'DeleteLocalProfileWhenVHDShouldApply' -PropertyType:dword -Value 1 -Force
New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name 'FlipFlopProfileDirectoryName' -PropertyType:dword -Value 1 -Force
Write-Output "FSLogix Config Finished, Rebooting"

Restart-Computer  -Force