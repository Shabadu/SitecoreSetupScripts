$useXDB=$false
$useSolr=$false
$useLinux=$false
$ipRange="192.168.30"

# Look for Sitecore zip in Setup Folder
$sitecoreZip = Get-Item "$PWD\Setup\Sitecore 8.* rev. *.zip" -ErrorAction SilentlyContinue | Select-Object -First 1 -ErrorAction SilentlyContinue
if(-Not $sitecoreZip -or -Not (Test-Path $sitecoreZip))
{
	Write-Host "No Sitecore zip found under Setup"
	$path = Read-Host "Please provide the path to the Sitecore zip"
	if(-Not (Test-Path $path))
	{
		Write-Error "Unable to find zip $path"
		Write-Error "Exiting"
		return -1;
	}
	else 
	{
		$sitecoreZip = $path
	}
}
Write-Host "using '$sitecoreZip' as sitecore install zip"
Write-Host ""

# Look for License.xml in Setup Folder
$licenseFile = Get-Item "$PWD\Setup\License.xml" -ErrorAction SilentlyContinue | Select-Object -First 1 -ErrorAction SilentlyContinue
if(-Not $licenseFile -or -Not (Test-Path $licenseFile))
{
	Write-Host "No License.xml file found under Setup"

	$path = Read-Host "Please provide the path to the License.xml file"
	if(-Not (Test-Path $path))
	{
		Write-Error "Unable to find zip $path"
		Write-Error "Exiting"
		return -1;
	}
	else 
	{
		$licenseFile = $path
	}
}
Write-Host "using '$licenseFile' as License.xml file"
Write-Host ""

# Ask if the user wants to use XDB. Default off
$answer = Read-Host "Turn on XDB? [y/n]"
if($answer -eq 'y' -or $answer -eq 'Y')
{
	$useXDB = $true
}

if($useXDB -eq $true)
{
	Write-Host "Using XDB going to add mongo to images"
}
else 
{
	Write-Host "Not using XDB"	
}
Write-Host ""

# Ask if the user wants to use solr instead of lucene. Default off
$answer = Read-Host "Use Solr instead of Lucene? [y/n]"
if($answer -eq 'y' -or $answer -eq 'Y')
{
	$useSolr = $true
}

if($useSolr -eq $true)
{
	Write-Host "Using Solr going to add solr to images"
}
else 
{
	Write-Host "Not Using Solr"	
}
Write-Host ""

if($useSolr -eq $true)
{
	$answer = Read-Host "Do you want to linux based solr image instead of a windows based solr image? [y/n]"
	if($answer -eq $true)
	{
		$useLinux = $true;
		Write-Host "Using linux based image for Solr"
	}
	else 
	{
		Write-Host "Using windows base image for Solr"
	}
}
Write-Host ""

# Ask what ip range should be used for containers. Default (192.168.30)
$done = $false
do
{
	$range = Read-Host "What ip range do you want to use? Default: $ipRange"
	if([System.String]::IsNullOrWhiteSpace($range) -eq $true)
	{
		Write-Host "Using default range $ipRange"
		$done = $true
	}
	elseif($range -match "(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\.(25
	[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])")
	{
		$ipRange = $range
		$done = $true
	}
	else 
	{
		Write-Host "Invalid Range"
	}
}
while($done -ne $true);
Write-Host "Using IP Range $ipRange"
Write-Host ""

# Extract sitecore zip file to (Setup/tmp/