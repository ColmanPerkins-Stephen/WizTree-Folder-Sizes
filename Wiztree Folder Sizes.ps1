# Set the path to the WizTree files
$wiztreeZipPath = $env:windir+"\temp\WizTree64.zip"
$wiztreePath = $env:windir+"\temp\WizTree.exe" # Points to 32 bit wich runs 32 bit or calls 64 bit
$unzipPath = $env:windir+"\temp\"

# Set the scan variables
$drivePath = $env:SystemDrive # Scans the Windows install drive, otherwise format as "C:"
$folderDepth = 5 # How deep the scan will probe
$exportFiles = 0 # Set to "1" to include files, not just folders
$outputPath = $env:windir+"\temp\" # Path for the output files

# Set the filename of the output
$formattedName = $env:COMPUTERNAME+"_"+$drivePath.Trim(":")+"_"+(Get-Date).ToString("yyyy_MM_dd")

# Download Wiztree (slightly older version but time\version safe URL)
Invoke-WebRequest -Uri "https://diskanalyzer.com/files/archive/wiztree_4_13_portable.zip" -OutFile $wiztreeZipPath -Headers @{"Cache-Control"="no-cache"}

# Check if the file finished downloading, otherwise, wait 10 seconds
if (!(Test-Path $wiztreeZipPath -PathType Leaf)){
    Start-Sleep -s 10
}

# Unzip the files
Expand-Archive -Path $wiztreeZipPath -DestinationPath $unzipPath -Force

# Set the list of Args for the app run
$argumentList = "$drivePath /export=""$outputPath\$formattedName.csv"" /treemapimagefile=""$outputPath\$formattedName.png"" /exportmaxdepth=$folderDepth /exportfiles=$exportFiles /filterexclude=""Windows"" /admin=1"

# Start WizTree and export the C drive as a jpg
Start-Process -FilePath $wiztreePath -ArgumentList $argumentList -Wait