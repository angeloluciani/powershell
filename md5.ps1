$someFilePath = "" #insert here the path
$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$hash = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($someFilePath)))
write-host "MD5 ->" $md5
write-host "HASH ->" $hash
