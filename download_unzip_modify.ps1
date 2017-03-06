#Variables
$client_path = "C:\Users\angelo.luciani\Desktop\Version56\client_automation_download\xdm-client-64bit.zip"
$folder_unzip = "C:\Users\angelo.luciani\Desktop\Version56\client_automation_download\client"
$bundle = "C:\Users\angelo.luciani\Desktop\Version56\client_automation_download\client\plugins\xdm.client.deps.bundle_14.3.1.jar"

function Delete-OldclientZip {
	if(test-path ($client_path))
	{
		remove-item $client_path -force
	}
}

function Download-file {

$source = "http://localhost:8080/xdm/update/xdm-client-64bit.zip"
$destination = $client_path
 
Invoke-WebRequest $source -OutFile $destination
}

function Delete-OldUnzipClient
{
	if(test-path ($folder_unzip ))
	{
		remove-item $folder_unzip  -force -recurse
	}
}
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}



#########################################################################################################Main####################################################################################################

Write-host "########################## STARTED #################################################"
Write-host "1. Delete old client "
Delete-OldclientZip
Write-host "2. Delete Old Unzipped File"
Delete-OldUnzipClient

Write-host "3. Download the new file"
Download-file
Write-host "4. Unzip the new client"
Unzip $client_path $folder_unzip

Write-host "5. Modify the bundle file"
	if(test-path ($bundle))
	{
		remove-item $bundle -force
	}
Copy-Item "C:\Users\angelo.luciani\Desktop\Version56\client_automation_download\bundle_file\xdm.client.deps.bundle_14.3.1.jar" "C:\Users\angelo.luciani\Desktop\Version56\client_automation_download\client\plugins\"
Write-host "########################## COMPLETED #################################################"
