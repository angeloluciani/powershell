#assign the path to the variable
$path = "C:\Prog\apache-tomcat-7\logs"
#set the path
Set-Location $path
#assign the path to the variable
$files = Get-ChildItem

#Write all items 
Foreach ($i in $files)
{
Write-Host
Write-Host "Remove file" $i.FullName -foregroundcolor blue -backgroundcolor black
Write-Host
}
#Remove all items 
Foreach ($i in $files)
{
Write-Host
Write-Host "Remove file" $i.FullName -foregroundcolor red -backgroundcolor yellow
Write-Host
Remove-Item $i
}
