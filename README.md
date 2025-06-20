# HEIC Converter

HEIC Converter is a simple Windows tool that adds a right-click context menu item for converting HEIC image files to JPEG format. After installation, you can right-click any .heic file in Windows Explorer and select "Convert to JPEG" to instantly create a JPEG version of the image in the same folder.

![HEIC Converter Demo](assets/demo.gif)

## Features
- Adds a context menu entry for .heic files in Windows Explorer
- Converts HEIC images to JPEG format with a single click
- **Context menu supports up to 15 files at once** for batch conversion
- Supports multiple HEIC file associations (works with different default apps)
- **Global command-line access** - use `heiccv` from any directory
- **Batch processing** - convert unlimited files via command line
- **Wildcard support** - convert all HEIC files with `*.heic`
- Simple installer and uninstaller

## Quick Start
👉 **For basic usage instructions, see the [User Guide](USER_GUIDE.md)**

The context menu is perfect for converting a few photos quickly. For batch processing many files, use the command line options below.

## How It Works
- The installer registers a context menu handler for .heic files in the Windows Registry.
- When you select "Convert to JPEG" from the right-click menu, the tool runs `heiccv.exe` and passes the selected file as an argument.
- **Context menu works with 1-15 files at once** - for larger batches, use the command line.
- The tool uses Python, Pillow, and pillow-heif to convert the HEIC image to JPEG format, saving the new file alongside the original.

## Installation
1. Download and run the installer (`HEIC_Converter_Installer_x64.exe`).
2. Follow the prompts to complete installation.
3. After installation, right-click any .heic file and choose "Convert to JPEG".
4. **The installer automatically adds the converter to your system PATH**, allowing you to use it from any command prompt or PowerShell session.

## PowerShell Usage
After installation, you can use the converter from anywhere in your system using the `heiccv` command (short for "HEIC ConVert"):

![HEIC Converter PowerShell Demo](assets/demo-console.gif)

### Examples
```powershell
# Convert with custom quality
heiccv "photo.heic" -Quality 90

# Overwrite existing JPEG files
heiccv "*.heic" -Overwrite

# Convert all HEIC files in a directory
heiccv "C:\Photos\*.heic"
```
## Batch Processing
You can convert multiple HEIC files at once by specifying a wildcard pattern or multiple file paths. For example:

```powershell
heiccv "C:\Photos\*.heic"
```
---

## Uninstallation
- Use "Add or Remove Programs" in Windows to uninstall HEIC Converter. This will remove the context menu and all registry entries.

## Requirements
- Windows 10/11 (64-bit)
- .heic file support (native or via third-party apps)

## License
See the LICENSE file for details.
