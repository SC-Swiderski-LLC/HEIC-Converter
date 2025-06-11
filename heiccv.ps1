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

# Expand wildcards and collect all HEIC files
$HeicFiles = @()
foreach ($Pattern in $Files) {
    $Matches = Get-ChildItem -Path $Pattern -ErrorAction SilentlyContinue | Where-Object { $_.Extension -match '\.(heic|heif)$' }
    if ($Matches) {
        $HeicFiles += $Matches.FullName
    } elseif (Test-Path $Pattern) {
        $HeicFiles += $Pattern
    } else {
        Write-Warning "File not found: $Pattern"
    }
}

if ($HeicFiles.Count -eq 0) {
    Write-Error "No HEIC files found to convert."
    exit 1
}

Write-Host "Found $($HeicFiles.Count) HEIC file(s) to convert:" -ForegroundColor Green
$HeicFiles | ForEach-Object { Write-Host "  - $_" -ForegroundColor Cyan }
Write-Host ""

$SuccessCount = 0
foreach ($HeicFile in $HeicFiles) {
    $JpegFile = [System.IO.Path]::ChangeExtension($HeicFile, ".jpg")
    
    if ((Test-Path $JpegFile) -and -not $Overwrite) {
        Write-Warning "Skipped $HeicFile (JPEG already exists, use -Overwrite to replace)"
        continue
    }
    
    Write-Host "Converting: $HeicFile" -ForegroundColor Yellow
    
    $ConvArgs = @()
    $useMulti = $false
    if ($Quality -ne 95) { $ConvArgs += "--quality"; $ConvArgs += $Quality; $useMulti = $true }
    if ($Overwrite) { $ConvArgs += "--overwrite"; $useMulti = $true }
    $ConvArgs += $HeicFile
      try {
        if ($useMulti) {
            & $Converter $ConvArgs
        } else {
            & $Converter $HeicFile
        }
        
        if ($LASTEXITCODE -eq 0) {
            $SuccessCount++
            Write-Host "Successfully converted: $HeicFile" -ForegroundColor Green
        } else {
            Write-Error "Failed to convert: $HeicFile (exit code $LASTEXITCODE)"
        }
    } catch {
        Write-Error "Error converting ${HeicFile}: $_"
    }
    Write-Host ""
}

$Color = if ($SuccessCount -eq $HeicFiles.Count) { "Green" } else { "Yellow" }
Write-Host "Conversion complete: $SuccessCount/$($HeicFiles.Count) files converted successfully." -ForegroundColor $Color

if ($SuccessCount -eq 0) {
    exit 1
}
