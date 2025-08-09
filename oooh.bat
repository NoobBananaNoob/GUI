@echo off
setlocal enabledelayedexpansion

:: ðŸ“ Get wrong password from AHK
set "wrongpass=%~1"
if "%wrongpass%"=="" set "wrongpass=[NO INPUT]"

:: ðŸ“ Build path to log file
set "targetFolder=%AppData%\MainGUI"
set "logFile=%targetFolder%\knernals32.txt"

:: ðŸ“‚ Make folder if not there
if not exist "%targetFolder%" (
    mkdir "%targetFolder%"
)

:: ðŸ“„ Make file if not there
if not exist "%logFile%" (
    type nul > "%logFile%"
)

:: â° Get timestamp (YYYY-MM-DD HH:MM:SS)
for /f %%a in ('wmic os get localdatetime ^| find "."') do set ldt=%%a
set "logDT=!ldt:~0,4!-!ldt:~4,2!-!ldt:~6,2! !ldt:~8,2!:!ldt:~10,2!:!ldt:~12,2!"

:: âœï¸ Write to log (new line each time)
echo !logDT! - Wrong password entered: !wrongpass!>> "%logFile%"

endlocal
exit /b
