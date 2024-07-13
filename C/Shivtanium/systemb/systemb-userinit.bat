@echo off & setlocal enableDelayedExpansion
set username=
set next=
for %%a in (%*) do (
	if defined next (
		set "!next!=%%~a"
	) else (
		set next=
		if "%%a"=="--username" set next=sys.username
	)
)
if not defined sys.username call :fail Argument error: 'username' is not defined.
if not exist "!sst.root!" call :fail FATAL: sst.root doesn't exist.
if "!sys.lowPerformanceMode!"=="True" (
	echo=¤CTRL	APPLYTHEME	classic
) else echo=¤CTRL	APPLYTHEME	aero
set sys.UPID=!PID!
if not exist "!sst.root!\Users" md "!sst.root!\Users"
call "!sst.dir!\systemb\systemb-desktop.bat" || call :fail systemb-desktop exitted with exit code !errorlevel!.
>>"!sst.dir!\temp\kernelPipe" echo=exitProcess	!PID!
exit 0
:fail
set args=%*
call systemb-dialog.bat 4 2 48 7 "systemb-userinit	classic" "l2=  !args!	l4=  Login failed."
exit 0
