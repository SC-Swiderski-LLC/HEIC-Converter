# HEIC Converter - Dual Architecture

This project now uses a clean dual-executable architecture:

## Architecture

### 1. Console Version (`heiccv-console.exe`)
- **Source**: `heic_to_jpeg_console.py`
- **Purpose**: Command-line usage with full output and argument parsing
- **Features**: 
  - Verbose output with progress indicators
  - Full argument parsing with `--help`, `--quality`, `--overwrite`
  - Wildcard support for batch processing
  - Proper exit codes for scripting

### 2. Windowed Version (`heiccv.exe`)
- **Source**: `heic_to_jpeg_windowed.py`  
- **Purpose**: Silent context menu integration
- **Features**:
  - Silent operation (no console windows)
  - File coalescing for multi-selection
  - Automatic cleanup and queuing
  - Context menu only (single file argument)

## Usage

### Command Line
```bash
# Direct executable
.\dist\heiccv-console.exe photo.heic
.\dist\heiccv-console.exe *.heic --quality 90

# Via wrapper scripts (after install)
heiccv photo.heic
.\heiccv.ps1 *.heic --quality 85 --overwrite
.\heiccv.bat photo1.heic photo2.heic
```

### Context Menu
Right-click on HEIC files → "Convert to JPEG"
- Works with single or multiple file selections
- Runs silently without console windows
- Automatically handles file coalescing

## Build Process

```bash
# Build both versions
.\build.bat

# Or build individually  
pyinstaller heiccv_console.spec    # Console version
pyinstaller heiccv_windowed.spec   # Windowed version
```

## Files

- `heic_to_jpeg_console.py` - Console version source
- `heic_to_jpeg_windowed.py` - Windowed version source  
- `heiccv_console.spec` - Console build specification
- `heiccv_windowed.spec` - Windowed build specification
- `heiccv.bat` - Batch wrapper (calls console version)
- `heiccv.ps1` - PowerShell wrapper (calls console version)
- `setup.iss` - Installer configuration

## Installation

1. Run `.\build.bat` to build executables
2. Open `setup.iss` in Inno Setup Compiler
3. Compile to create installer
4. Run installer - adds both executables and context menu integration

The installer:
- Installs both executables to Program Files
- Adds console version to PATH for command-line access
- Registers windowed version for context menu integration
- Provides wrapper scripts for easy command-line usage
