

# PARAMETRI 
#[string] $oraDxUser          - USER
#[string] $oraDxUserPassword  - PASSWORD ORACLE
#[string] $oraDbServer        - DATABASE
#[string] $path_scripts       - SCRIPT
#[string] $sql_log_file       - SQL LOG
#[string] $data_option        - DATA OPTION
#[string] $nomedump           - NOME DUMP

param ([string] $xdm_web_app, [string] $war_location, [string] $dev, [string] $dev_reference)
#param ([string] $oraDxUser, [string] $oraDxUserPassword, [string] $oraDbServer, [string] $path_scripts, [string] $sql_log_file, [string] $data_option, [string] $nomedump)

#$xdm_web_app  =  "C:\Prog\apache-tomcat-7\webapps\xdm"
#$war_location =  "C:\Users\angelo.luciani\Desktop\Version56\last_build"
#$dev          =  "C:\Prog\apache-tomcat-7\webapps\xdm\WEB-INF\config\dev"
#$dev_reference = "C:\Users\angelo.luciani\Desktop\Version56\last_build\dev"

#Variables
$7ziplocation =  "C:\Program Files\7-Zip\7z.exe"
#******************************* Procedure **********************************************************

#0 Set up 7-Zip\7z
function Set-7zip 
{
	if (-not (test-path $7ziplocation))
	 {
	 throw "7z.exe needed"
	 }   
	
}

#1 Delete the old version  
function Delete-OldVersion
{
		if(test-path ($xdm_web_app))
		{
		remove-item $xdm_web_app -Force -Recurse
		}
}
# 2. Get the war
# SFTP is not supported by powershell
# Probably we can use WinSCP

#3 Unzip the war
function Unzip-Deploy {
Set-Location $war_location
sz x "xdm.war" -oC:\Prog\apache-tomcat-7\webapps\xdm
}

#4. modify the file config

function Modify-config 
{
		if(test-path ($dev))
		{
		remove-item $dev -Force -Recurse
		}
		#5 copy dev folder
	   Copy-Item $dev_reference $dev -recurse
}

####################################################### MAIN ##################################################
set-alias sz $7ziplocation
Write-Host "*** STARTED ***" -foreground "green"
Write-Host "*** Set-7zip ***" -foreground "green"
Set-7zip 
Write-Host "*** Delete-OldVersion ***" -foreground "green"
Delete-OldVersion
Write-Host "*** Unzip-Deploy ***" -foreground "green"
Unzip-Deploy
Write-Host "*** Modify-config ***" -foreground "green"
Modify-config 
#Write-Host "*** COMPLETED ***" -foreground "green"
