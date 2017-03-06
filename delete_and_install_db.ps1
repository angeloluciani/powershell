

# PARAMETRI 
#[string] $oraDxUser          - USER
#[string] $oraDxUserPassword  - PASSWORD ORACLE
#[string] $oraDbServer        - DATABASE
#[string] $path_scripts       - SCRIPT
#[string] $sql_log_file       - SQL LOG
#[string] $data_option        - DATA OPTION
#[string] $nomedump           - NOME DUMP

param ([string] $oraDxUser, [string] $oraDxUserPassword, [string] $oraDbServer, [string] $path_scripts, [string] $sql_log_file, [string] $data_option, [string] $nomedump)


#localhost to set the TNS
if ($oraDbServer -eq "localhost")
{
	$oraTnsConnection = "(DESCRIPTION=(ADDRESS_LIST=(ADDRESS =(PROTOCOL=TCP)(HOST=127.0.0.1)(PORT=1521)))(CONNECT_DATA=(SEVER=DEDICATED)(SERVICE_NAME=xdm)))"
}

# A function to run a sqlplus 
# PARAMETRI 
# [string]$sqlConnect  "connect  "+ $oraUser +"/"+$oraPassword+"@"+$oraTnsConnection
# [string]$sqlCmd The sql file to run

function RunSqlPlus([string]$sqlConnect,[string]$sqlCmd)
{
	Write-Host "Started RunSqlPlus"
	#create a temporary file
	$tmpFile = [System.IO.Path]::GetTempFileName()
	
	#only to check where is created
	Write-Host "TmpFile tmpFile: " $tmpFile 
	$sqlExit = 'exit;'
    
	#added assign the sqlConnect the string "connect  "+ $oraUser +"/"+$oraPassword+"@"+$oraTnsConnection
	Set-Content -path $tmpFile -value $sqlConnect
    Write-host "sqlConnect:  " $sqlConnect
	
	#Add-Content -path $tmpFile -value $sqlCmd
	
	#Add the temporary file the complete scripts to $sqlCmd
	   (Get-Content $sqlCmd) | 
    Foreach-Object {
       Add-Content -path $tmpFile -value $_ 
    } | Set-Content $tmpFile
	
	
	Write-host "sqlCmd:  " $sqlCmd
	#Add exit clause to the temporary file
	Add-Content -path $tmpFile -value $sqlExit

	#if exist a log file delete it 
	if(test-path ($sql_log_file))
	{
		remove-item $sql_log_file -force
	}
	
	# 2>&1 things are for force to not display anything
	&'sqlplus.exe' '/NOLOG' '@' $tmpFile 2>&1 | out-file $sql_log_file
    
	
	#? (dollar sign + question mark) Returns True or False value indicating whether previous command ended with an error.
    # For some reason it does not catch all errors, but most of the time it works.
	if ( -not $? )
	{
		Write-Host "ERROR while executing SQLPLUS command as $sqlConnect" -foregroundcolor red -backgroundcolor yellow
		Write-Host $sqlCmd -foregroundcolor red -backgroundcolor yellow
		write-host
	}       
	
	#Remove the temporary file
	Remove-Item -path $tmpFile
	Write-Host "Completed  RunSqlPlus"
}

#function to connect to SQL PLUS
function RunSqlPlusAsUser([string]$oraUser, [string]$oraPassword, [string]$sqlCmd)
{
Write-Host "*** Started RunSqlPlusAsUser ***"
	$sqlConnect = "connect  "+ $oraUser +"/"+$oraPassword+"@"+$oraTnsConnection
	Write-Host $sqlConnect
	RunSqlPlus $sqlConnect $sqlCmd
Write-Host "*** Completed RunSqlPlusAsUser ***"
}

#function run a sql script (depends from RunSqlPlusAsUser)
function execute_sql_script([string]$script)
{
Write-Host "*** execute_sql_scrip ***"
return RunSqlPlusAsUser $oraDxUser $oraDxUserPassword $script
Write-Host "*** Complete execute_sql_scrip ***"
}
<############################################## MAIN #############################################################################>

#ONLY TO PRINT VARIABLES
Write-Host "***started parameters***"
Write-Host "user ==>"$oraDxUser
Write-Host "password ==>"$oraDxUserPassword
Write-Host "DB ==>"$oraDbServer
Write-Host "Path script ==>" $path_scripts+"/cleanit.sql"
Write-Host "Path log ==> "$sql_log_file
Write-Host "***completed parameters***"
Write-Host "Started to delete XDM schema" -foreground "green"
#set the location
Set-Location $path_scripts
#create the full_path
$full_path=$path_scripts+"/cleanit.sql"
#file_name
$file_name="cleanit.sql"
#get the context_sql it could be useful to print $context_sql  
$context_sql = Get-Content $full_path
#run the sql script
execute_sql_script($full_path)
Write-Host "Completed to delete XDM schema" -foreground "green"


<############################################## INSTALL DB #############################################################################>

Write-Host "***************************************************Import DB section*************************************"  -foreground "green"
$path_exe      = "C:\Prog\oracle\product\12.1.0\dbhome_1\BIN\imp.exe"
$path_exe_dp      = "C:\Prog\oracle\product\12.1.0\dbhome_1\BIN\impdp.exe"
$user          = "xdm"

$data_pump     = "1"
$schema = "xdm"

#NOTE: BELOW YOU INSERT THE DUMP LOCATION
$dump_location="C:\myscript\DB"
#$dump_location = "C:\myscript\"
$imp_log_file = "C:\myscript\localhost.log"

#Parameters DB sid and dump name
$nome_sid = "xdm"

#If isnot  a data_pump


write-host "questa è la data_option ===>"$data_option


			if ($data_option -eq "0")
			{
			Write-Host "*************************************************** Started import *************************************"  -foreground "green"
						Set-location $dump_location 
							#if exist a log file delete it 
							if(test-path ($imp_log_file))
							{
								remove-item $imp_log_file -force
							}
						$parameters = $user+"/"+$oraDxUserPassword+"@"+$nome_sid+" FILE="+$nomedump+" COMMIT=Y IGNORE=Y FROMUSER="+$user+" TOUSER="+$user+" FEEDBACK=10000 LOG="+$imp_log_file
						#$parameters = $user+"/"+$ora_password+"@"+$nome_sid+" FILE="+$nomedump+" COMMIT=Y IGNORE=Y FROMUSER="+$user+" TOUSER="+$user+" FEEDBACK=10000 LOG="+$imp_log_file
						Write-host $parameters
						#-NoNewWindow
						Start-process $path_exe  $parameters 
						Write-Host "*************************************************** Completed to import *************************************"  -foreground "green"
			}
#If it is a data_pump			
			ElseIf ($data_option -eq "1")
			{ 
			Write-Host "*************************************************** Started import datapump *************************************"  -foreground "green"
			   #If it is a data_pump		
			   #$parameters = impdp xdm/manager@xdm schemas=xdm directory=DATA_PUMP_DIR dumpfile=TABLE_2_09092016.DMP logfile=log_TABLE_2_09092016.log remap_schema=xdm:xdm
			                       #xdm/manager@xdm schemas=xdm directory=DATA_PUMP_DIR dumpfile=CALENDAR_26_10_2016.DMP logfile=C:\myscript\localhost.log remap_schema=xdm:xdm
               #$path_exe_dp
			   Set-location $dump_location 

							#if exist a log file delete it 
							if(test-path ($imp_log_file))
							{
								remove-item $imp_log_file -force
							}
   #"log"+$nomedump+"
						$parameters = $user+"/"+$oraDxUserPassword+"@"+$nome_sid+" schemas="+$schema+" directory="+"DATA_PUMP_DIR"+" dumpfile="+$nomedump+" logfile= log_"+$nomedump+" remap_schema="+$schema+":"+$schema

						Write-host $parameters
						Start-process $path_exe_dp $parameters 
						Write-Host "*************************************************** Completed to import *************************************"  -foreground "green"			     
			}
#only a print
				If ($data_option -eq "3")
			{
						Write-Host "*************************************************** Only Delete the DB *************************************"  -foreground "green"
			}
			
			
			
			
