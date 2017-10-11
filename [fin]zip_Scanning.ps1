﻿$ErrorActionPreference = 'silentlycontinue'
$env:hostIP = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.netadapter.status -ne "Disconnected"}).ipv4address.ipaddress
$env:hostMAC = (Get-NetAdapter | where-object -FilterScript {$_.HardwareInterface -eq "True" -and $_.Status -ne "Disconnected"}).MacAddress
$aroot = (get-psdrive | select root).root
foreach ($root in $aroot)
{
foreach($source in (Get-ChildItem $root -file -recurse -filter '*.zip'))
{
$rootd = ($source.directoryname.Split(":"))[0]
$cdatetime = ($file | select CreationTime).CreationTime
$cdatetime = get-date $cdatetime -format yyyy-MM-dd@hh:mm:ss
$cdate = $cdatetime.split("@")[0]
$ctime = $cdatetime.split("@")[1]
$adatetime = ($file | select LastAccessTime).LastAccessTime
$adatetime = get-date $adatetime -format yyyy-MM-dd@hh:mm:ss
$adate = $cdatetime.split("@")[0]
$atime = $cdatetime.split("@")[1]
$mdatetime = ($file | select LastWriteTime).LastWriteTime
$mdatetime = get-date $mdatetime -format yyyy-MM-dd@hh:mm:ss
$mdate = $mdatetime.split("@")[0]
$mtime = $mdatetime.split("@")[1]
[IO.Compression.ZipFile]::OpenRead($source.FullName).Entries | %{$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $env:username + ":::;" +  $env:hostIP + ":::;" + $env:hostMAC + ":::;" + $cdate + ":::;" + $ctime + “ :“ + $adate + ":::;" + $atime + “ :“ + $mdate + “ :“ + $mtime + “ :“ + "{0:N2}" -f ($source.Length/1kb) + ":::;" + $rootd + ":::;" + $source.DirectoryName + ":::;" + $source.Name + ":::;" + $source.BaseName + ":::;" + $source.Extension + ":::;" + $source.Attributes+ ":::;" + "$source`: $($_.FullName):::;$($_.fullname.split(".")[-1]):::;$($_.Length/1kb)" } | Out-File  C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_zip.txt -Append 
}
}
