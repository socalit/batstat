@echo off
setlocal enabledelayedexpansion
title Battery and System Info (XP–11 Compatible)

:: ─────────────────────────────────────────────
:: Detect Windows version
:: ─────────────────────────────────────────────
ver | findstr "5.1" >nul && set "os=XP"
ver | findstr "6.1" >nul && set "os=7"
ver | findstr "6.2" >nul && set "os=8"
ver | findstr "6.3" >nul && set "os=8.1"
ver | findstr "10.0.1" >nul && set "os=10"
ver | findstr "10.0.2" >nul && set "os=11"

if not defined os set "os=Unknown"

echo Detected Windows Version: %os%

:: ─────────────────────────────────────────────
:: Battery Report (Windows 8+)
:: ─────────────────────────────────────────────
if "%os%"=="8"  goto genreport
if "%os%"=="8.1" goto genreport
if "%os%"=="10" goto genreport
if "%os%"=="11" goto genreport
goto skipreport

:genreport
echo.
echo [*] Generating battery report...
set "REPORT=%USERPROFILE%\Desktop\battery_report.html"
powercfg /batteryreport /output "%REPORT%" >nul 2>&1

if exist "%REPORT%" (
    echo [*] Battery report saved: %REPORT%
    echo [*] Opening report...
    start "" "%REPORT%"
)
:skipreport

:: ─────────────────────────────────────────────
:: If WMIC is available, proceed with diagnostics
:: ─────────────────────────────────────────────
where wmic >nul 2>&1
if errorlevel 1 goto skipwmic

:: ─────────────────────────────────────────────
:: Battery Info
:: ─────────────────────────────────────────────
echo.
echo ----------------------------------------
echo Battery Info
echo ----------------------------------------

for /f "tokens=2 delims==" %%A in ('wmic Path Win32_Battery Get EstimatedChargeRemaining /value ^| find "="') do (
    set "charge=%%A"
)
for /f "tokens=2 delims==" %%B in ('wmic Path Win32_Battery Get BatteryStatus /value ^| find "="') do (
    set "status=%%B"
)

if defined charge (
    echo Battery Level: %charge%%%
    if %charge% LSS 20 echo [!] Battery is low!
) else (
    echo Battery Level: Not available
)

if defined status (
    if %status%==1 echo Status: Discharging
    if %status%==2 echo Status: Charging
    if %status%==3 echo Status: Fully Charged
    if %status% GEQ 4 echo Status Code: %status%
)

:: ─────────────────────────────────────────────
:: System Info
:: ─────────────────────────────────────────────
echo.
echo ----------------------------------------
echo System Information
echo ----------------------------------------

echo Computer Name: %COMPUTERNAME%
echo.
echo OS Version:
ver
echo.
echo Architecture:
for /f "tokens=2 delims==" %%A in ('wmic os get osarchitecture /value ^| find "="') do echo %%A
echo.
echo Manufacturer and Model:
for /f "skip=1 tokens=*" %%A in ('wmic computersystem get manufacturer') do if not "%%A"=="" echo Manufacturer: %%A & goto next1
:next1
for /f "skip=1 tokens=*" %%A in ('wmic computersystem get model') do if not "%%A"=="" echo Model: %%A & goto next2
:next2
echo.
echo Processor:
for /f "skip=1 tokens=*" %%A in ('wmic cpu get name') do if not "%%A"=="" echo %%A & goto next3
:next3
echo.
echo Installed RAM:
for /f "skip=1" %%A in ('wmic computersystem get totalphysicalmemory') do (
    set mem=%%A
    goto showram
)
:showram
set /a memGB=%mem:~0,-9%
echo RAM: %memGB% GB

:: ─────────────────────────────────────────────
:: Disk Info
:: ─────────────────────────────────────────────
echo.
echo ----------------------------------------
echo Disk Drive Info
echo ----------------------------------------

for /f "skip=1 tokens=*" %%A in ('wmic diskdrive get size') do (
    set "raw=%%A"
    if not "!raw!"=="" (
        set "bytes=%%A"
        goto convert
    )
)

:convert
setlocal enabledelayedexpansion
set "bytes=!bytes: =!"
set "bytes=!bytes:,=!"
set "prefix=!bytes:~0,5!"
set /a sizeGB=!prefix! / 10
echo Approximate Size: ~!sizeGB! GB
endlocal

:skipwmic
:end
echo.
pause
endlocal
