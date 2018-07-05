@echo off
REM Created and maintained by Matthew Putnam with help from Braidon Myers.
REM Built on and for Windows 10. Not tested on other versions of Windows.

REM ---- TODO ----
REM Add option to carry directories to save having to retype entire URLs
REM Take an angle grinder to the progress indicator
REM Cleanup/improve commentary
REM Reduce repetition of the same code (Looking at you, restart if statement)
REM General optimizations

REM Sets "beginning" point, clears CMD screen, sets environment variable to allow for math in
REM for loop, and sets the debug path used for general debugging.
:beginning
cls
SetLocal EnableDelayedExpansion
set debugPath=%USERPROFILE%\Desktop\FileScriptDebug.txt

REM Prompts user for desired operation to run through, then jumps to
REM appropriate section of script.
set /p operation="Enter operation you'd like to execute (move, del): "
if /i %operation% == move goto :move
if /i %operation% == del goto :del

REM Move portion of script. Prompts for directory to move files
REM from and to, as well as the types of files to move.
:move
set /p fromDir="Enter full location path to move files from: "
set /p toDir="Enter full location path to move files to: "
set /p filetype="Enter filetype to move, including period (e.g., .txt): "

REM Combines the from directory and filetype, constructs and saves command to be ran.
set fromDirPlusFiletype=%fromDir%*%filetype%
set command="DIR %fromDirPlusFiletype% | find /C "%filetype%""

REM For loop to determine the amount of files affected by command made above.
for /f "tokens=* USEBACKQ" %%A in (`%command%`) DO set countOfAffectedFiles=%%A

REM Confirms prompted-for information w/ user.
echo Are you sure you want to move %countOfAffectedFiles% %filetype% files from %fromDir% to %toDir%?
set /p confirm="Y for yes, anything else for no: "

REM Goes to end if user did not confirm prompted-for information.
if /I NOT %confirm% == y goto :end

REM Created variable to keep track of times ran (used in this case to keep track
REM of the amount of files moved), uses For loop to find a file matching user-entered
REM criteria, then move that file to user-entered to directory, then add one
REM to timesRan, and then print out the amount of files moved out of total.
REM Lastly, reports success of moving files and then asks if the user
REM wants to restart.
set timesRan=0
for /R "%fromDir%" %%i in (*%filetype%) do move "%%i" "%toDir%" >nul && set /a timesRan = timesRan + 1 && echo Moved file !timesRan! of %countOfAffectedFiles%
echo Successfully moved %timesRan% files
set /p restart="Do you want to restart? Y for yes, anything else for no: "

REM If user entered Y, jumps to beginning. If they did not, exits script.
if /i %restart% == Y (
goto :beginning 
) else (
exit
)

REM Possibly unneccessary end/exit for :move ?
pause
exit

REM Del(ete) portion of script.
REM Prompts for from directory, and type of files to delete.
:del
set /p fromDir="Enter full location path to delete files from: "
set /p filetype="Enter filetype to delete, including period (e.g., .txt): "

REM Combines from directory and filetype, then creates command to be executed.
REM Then uses for loop to discover amount of files to be deleted.
set fromDirPlusFiletype=%fromDir%*%filetype%
set command="DIR %fromDirPlusFiletype% | find /C "%filetype%""
for /f "tokens=* USEBACKQ" %%A in (`%command%`) DO set countOfAffectedFiles=%%A

REM Prompts user to ensure entered information is correct.
echo Are you sure you want to delete %countOfAffectedFiles% %filetype% files from %fromDir%?
set /p confirm="Y for yes, anything else for no: "

REM If user did not say Y, jump to the end.
if /I NOT %confirm% == Y goto :end

REM Created variable to keep track of times ran (used here to keep track of
REM deleted files). Uses for loop to run previously created command,
REM deleting appropriate files. Then reports success and final count,
REM asks if user wants to restart.
set timesRan=0
for /R "%fromDir%"  %%i in (*%filetype%) do del "%%i" && set /a timesRan = timesRan + 1 && echo Deleted file !timesRan! of %countOfAffectedFiles%
echo Successfully deleted %timesRan% files
set /p restart="Do you want to restart? Y for yes, anything else for no: "

REM If user wants to restart, go to beginning. Else, exit script.
if /i %restart% == Y (
goto :beginning 
) else (
exit
)

REM End of script. If user wants to restart, go to beginning. Else, exit script.
:end
set /p restart="Do you want to restart? Y for yes, anything else for no: "

REM If user entered Y, jumps to beginning. If they did not, exits script.
if /i %restart% == Y (
goto :beginning 
) else (
exit
)
pause
exit