# Function to zip an exe file with password protection
param (
    [string]$ExeFilePath
)

# Check if the file exists
if (-Not (Test-Path -Path $ExeFilePath -PathType Leaf)) {
    Write-Host "File not found: $ExeFilePath" -ForegroundColor Red
    exit 1
}

# Get the file name without extension
$FileName = [System.IO.Path]::GetFileNameWithoutExtension($ExeFilePath)

# Set the output zip file path in the current script directory
$ScriptDirectory = $PSScriptRoot
$ZipFilePath = "$ScriptDirectory\$FileName.zip"

# Compress the exe file into a zip archive
Compress-Archive -Path $ExeFilePath -DestinationPath $ZipFilePath -Force

Write-Host "File zipped successfully: $ZipFilePath" -ForegroundColor Green
