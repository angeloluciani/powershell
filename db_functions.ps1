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
