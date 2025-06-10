# HEIC Converter

HEIC Converter is a simple Windows tool that adds a right-click context menu item for converting HEIC image files to JPEG format. After installation, you can right-click any .heic file in Windows Explorer and select "Convert to JPEG" to instantly create a JPEG version of the image in the same folder.

## Features
- Adds a context menu entry for .heic files in Windows Explorer
- Converts HEIC images to JPEG format with a single click
- Supports multiple HEIC file associations (works with different default apps)
- **Global command-line access** - use `heiccv` from any directory
- **Batch processing** - convert multiple files at once
- **Wildcard support** - convert all HEIC files with `*.heic`
- Simple installer and uninstaller

## How It Works
- The installer registers a context menu handler for .heic files in the Windows Registry.
- When you select "Convert to JPEG" from the right-click menu, the tool runs `heiccv.exe` and passes the selected file as an argument.
- The tool uses Python, Pillow, and pillow-heif to convert the HEIC image to JPEG format, saving the new file alongside the original.

## Installation
1. Download and run the installer (`HEIC_Converter_Installer_x64.exe`).
2. Follow the prompts to complete installation.
3. After installation, right-click any .heic file and choose "Convert to JPEG".
4. **The installer automatically adds the converter to your system PATH**, allowing you to use it from any command prompt or PowerShell session.

## Command Line Usage
After installation, you can use the converter from anywhere in your system using the `heiccv` command (short for "HEIC ConVert"):

### Basic Usage
```cmd
# Convert a single file
heiccv photo.heic

# Convert multiple files
heiccv photo1.heic photo2.heic photo3.heic

# Convert all HEIC files in current directory
heiccv *.heic
```

### PowerShell Usage
```powershell
# Convert with custom quality
heiccv photo.heic -Quality 90

# Overwrite existing JPEG files
heiccv *.heic -Overwrite

# Convert all HEIC files in a directory
heiccv C:\Photos\*.heic
```

### Advanced Options
```cmd
# Using the Python script directly for more options
heiccv.exe --help
heiccv.exe photo.heic --quality 85 --overwrite
```

## Uninstallation
- Use "Add or Remove Programs" in Windows to uninstall HEIC Converter. This will remove the context menu and all registry entries.

## Requirements
- Windows 10/11 (64-bit)
- .heic file support (native or via third-party apps)

## License
See the LICENSE file for details.
