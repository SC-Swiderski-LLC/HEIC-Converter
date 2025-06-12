# HEIC Converter PowerShell Wrapper
# This script passes all arguments directly to the console executable

# Get the script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Converter = Join-Path $ScriptDir "heiccv-console.exe"

# For development/testing, also check the dist folder
if (-not (Test-Path $Converter)) {
    $Converter = Join-Path $ScriptDir "dist\heiccv-console.exe"
}

if (-not (Test-Path $Converter)) {
    Write-Error "HEIC converter not found at: $Converter"
    Write-Error "Make sure heiccv-console.exe is in the same directory as this script or in the dist folder"
    exit 1
}

# Pass all arguments directly to the executable
& $Converter $args
exit $LASTEXITCODE
