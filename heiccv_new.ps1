# HEIC Converter PowerShell Wrapper
# Usage: heiccv photo.heic [photo2.heic] [photo3.heic] ...

param(
    [Parameter(Mandatory=$true, Position=0, ValueFromRemainingArguments=$true)]
    [string[]]$Files,
    
    [int]$Quality = 95,
    
    [switch]$Overwrite
)

# Get the script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Converter = Join-Path $ScriptDir "heiccv.exe"

if (-not (Test-Path $Converter)) {
    Write-Error "HEIC converter not found at: $Converter"
    exit 1
}

if ($Files.Count -eq 0) {
    Write-Host "Usage: heiccv <file.heic> [file2.heic] [file3.heic] ..."
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  heiccv photo.heic"
    Write-Host "  heiccv *.heic"
    Write-Host "  heiccv photo1.heic photo2.heic photo3.heic"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -Quality <1-100>  JPEG quality (default: 95)"
    Write-Host "  -Overwrite        Overwrite existing JPEG files"
    exit 1
}

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
    
    $Args = @("--quality", $Quality)
    if ($Overwrite) { $Args += "--overwrite" }
    $Args += $HeicFile
    
    try {
        & $Converter $Args
        if ($LASTEXITCODE -eq 0) {
            $SuccessCount++
            Write-Host "Successfully converted: $HeicFile" -ForegroundColor Green
        } else {
            Write-Error "Failed to convert: $HeicFile"
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
