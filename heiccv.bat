@echo off
REM HEIC Converter Command Line Wrapper
REM Usage: heiccv <file.heic> [file2.heic] [file3.heic] ...

if "%~1"=="" (
    echo Usage: heiccv ^<file.heic^> [file2.heic] [file3.heic] ...
    echo.
    echo Examples:
    echo   heiccv photo.heic
    echo   heiccv *.heic
    echo   heiccv photo1.heic photo2.heic photo3.heic
    exit /b 1
)

set SCRIPT_DIR=%~dp0
set CONVERTER="%SCRIPT_DIR%heiccv.exe"

REM For development/testing, also check the dist folder
if not exist %CONVERTER% (
    set CONVERTER="%SCRIPT_DIR%dist\heiccv.exe"
)

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
