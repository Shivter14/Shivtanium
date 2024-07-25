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
set sys.UPID=!PID!
if not exist "!sst.root!\Users\!sys.username!\userprofile.dat" call :fail User "!sys.username!" does not exist.

if "!sys.lowPerformanceMode!"=="True" (
	echo=¤CTRL	APPLYTHEME	classic
) else (
	set user.globalTheme=aero
	for /f "usebackq tokens=1* delims==" %%a in ("!sst.root!\Users\!sys.username!\userprofile.dat") do (
		set "user.%%a=%%b" > nul 2>&1
	)
	echo=¤CTRL	APPLYTHEME	!user.globalTheme!
)

call systemb-desktop.bat || call :fail systemb-desktop exitted with exit code !errorlevel!.
>>"!sst.dir!\temp\kernelPipe" echo=exitProcess	!PID!
exit 0
:fail
set args=%*
>>"!sst.dir!\temp\kernelPipe" echo=createProcess	0	systemb\systemb-login.bat
call systemb-dialog.bat 4 2 48 7 "systemb-userinit	classic" "l2=  !args!	l4=  Login failed."
exit /b 0
