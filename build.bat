@echo off
REM Build script for HEIC Converter

echo Building HEIC Converter...
echo.

REM Create dist directory if it doesn't exist
if not exist "dist" mkdir dist

REM Build the executable with PyInstaller
echo Building executable...
pyinstaller --onefile --clean --name heiccv heic_to_jpeg.py

if errorlevel 1 (
    echo Build failed!
    exit /b 1
)

REM Copy the executable to dist
copy "dist\heiccv.exe" "dist\" >nul

echo.
echo Build complete! 
echo Executable: dist\heiccv.exe
echo.
echo To create installer:
echo 1. Make sure Inno Setup is installed
echo 2. Open setup.iss in Inno Setup Compiler
echo 3. Compile to create the installer
echo.
echo To test command line:
echo   dist\heiccv.exe --help
echo   heiccv.bat test.heic
echo.
pause
