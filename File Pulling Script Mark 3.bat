@echo off
REM This script is used to delete or move files of a specific filetype.
REM Created and maintained by Matthew Putnam with help from Braidon Myers.
REM Copyright Matthew Putnam & Braidon Myers, 2018.
REM This script may NOT be used by any person or organization 
REM other than Matthew Putnam/Braidon Myers without written permission from one of them.

REM TODO
REM Add total files affected prior to execution ("Delete 1234 files w/ %filetype% extension?") // Added as of 5/31/18 by Matt P.
REM Add option to carry directories to save having to retype entire URLs
REM Add rough progress indicator (e.g., x out of y files complete) // Added as of 6/1/18 by Matt P.
REM Take an angle grinder to the progress indicator
:beginning
cls
SetLocal EnableDelayedExpansion
set debugPath=%USERPROFILE%\Desktop\FileScriptDebug.txt

set /p operation="Enter operation you'd like to execute (move, del): "

if /i %operation% == move goto :move
if /i %operation% == del goto :del

:move

set /p fromDir="Enter full location path to move files from: "
set /p toDir="Enter full location path to move files to: "
set /p filetype="Enter filetype to move, including period (e.g., .txt): "

set fromDirPlusFiletype=%fromDir%*%filetype%
set command="DIR %fromDirPlusFiletype% | find /C "%filetype%""

for /f "tokens=* USEBACKQ" %%A in (`%command%`) DO set countOfAffectedFiles=%%A

echo Are you sure you want to move %countOfAffectedFiles% %filetype% files from %fromDir% to %toDir%?
set /p confirm="Y for yes, anything else for no: "

if /I NOT %confirm% == y goto :end

set timesRan=0
for /R "%fromDir%" %%i in (*%filetype%) do move "%%i" "%toDir%" >nul && set /a timesRan = timesRan + 1 && echo Moved file !timesRan! of %countOfAffectedFiles%
echo Successfully moved %timesRan% files
set /p restart="Do you want to restart? Y for yes, anything else for no: "

if /i %restart% == Y (
goto :beginning 
) else (
exit
)

pause
exit

:del

set /p fromDir="Enter full location path to delete files from: "
set /p filetype="Enter filetype to delete, including period (e.g., .txt): "
set fromDirPlusFiletype=%fromDir%*%filetype%

set command="DIR %fromDirPlusFiletype% | find /C "%filetype%""
for /f "tokens=* USEBACKQ" %%A in (`%command%`) DO set countOfAffectedFiles=%%A

echo Are you sure you want to delete %countOfAffectedFiles% %filetype% files from %fromDir%?
set /p confirm="Y for yes, anything else for no: "

if /I NOT %confirm% == y goto :end

set timesRan=0
for /R "%fromDir%"  %%i in (*%filetype%) do del "%%i" && set /a timesRan = timesRan + 1 && echo Deleted file !timesRan! of %countOfAffectedFiles%
echo Successfully deleted %timesRan% files
set /p restart="Do you want to restart? Y for yes, anything else for no: "

if /i %restart% == Y goto :beginning else exit
:end
set /p restart="Do you want to restart? Y for yes, anything else for no: "

if /i %restart% == Y (
goto :beginning 
) else (
exit
)
pause
exit