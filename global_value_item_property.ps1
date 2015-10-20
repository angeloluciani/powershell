
# #############################################################################
# MAIN PROGRAM
# #############################################################################

$i =0

while ($i -eq 0) 
{ 
Write-Host "╔╦╦╦═╦╗╔═╦═╦══╦═╗"
Write-Host "║║║║╩╣╚╣═╣║║║║║╩╣"
Write-Host "╚══╩═╩═╩═╩═╩╩╩╩═╝"
Write-Host ________________________________________________________________
Write-Host "|1.  |Select the item property from a file  |" -foreground "green"
Write-Host ________________________________________________________________

Write-Host "Select a command ==> "
$a = read-host "Write the number action" 


switch ($a) 
    { 
        0
	{
	$i = 1
	Write-Host THANKS !!!! -foreground yellow
	}
		1
		{
		
	#remove old file result if it present
		if (test-path -path "C:\\Users\\angelo.luciani\\Desktop\\result.txt")
		   {
		   Remove-Item "C:\\Users\\angelo.luciani\\Desktop\\result.txt"
		   }
		
		  Write-Host "-match" -foreground "magenta"
		   if (test-path -path "C:\\Users\\angelo.luciani\\Desktop\\popipopi.txt")
		   {
		        $text = Get-Content "C:\\Users\\angelo.luciani\\Desktop\\popipopi.txt"
		   		foreach ($item in $text) 
				{
		           $found = $item -match "\'.*\'"
				   $spid  = $matches[0]
		           $b = $spid.Length
		           $pluto = $spid.Substring(1,$b-2)
				   $stringacompleta = "global [val property_"+$pluto+" `"values['"+$pluto+"']"+"`"]"
				   $stringacompleta >> "C:\\Users\\angelo.luciani\\Desktop\\result.txt"
				}                 
           }
	}	
}

Write-Host Set up COMPLETED -foreground "magenta"
