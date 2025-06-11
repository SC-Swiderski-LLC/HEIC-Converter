@echo off
REM HEIC Converter Command Line Wrapper
REM This script passes all arguments directly to the console executable

set SCRIPT_DIR=%~dp0
set CONVERTER="%SCRIPT_DIR%heiccv-console.exe"

REM For development/testing, also check the dist folder
if not exist %CONVERTER% (
    set CONVERTER="%SCRIPT_DIR%dist\heiccv-console.exe"
)

if not exist %CONVERTER% (
    echo Error: HEIC converter not found at %CONVERTER%
    echo Make sure heiccv-console.exe is in the same directory as this script or in the dist folder
    exit /b 1
)

REM Pass all arguments to the executable
%CONVERTER% %*
exit /b %errorlevel%

:loop
if "%~1"=="" goto :eof
echo Converting: %~1
%CONVERTER% "%~1"
if errorlevel 1 (
    echo Error converting: %~1
) else (
    echo Successfully converted: %~1
)
echo.
shift
goto loop
