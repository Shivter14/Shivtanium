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
echo=¤CTRL	APPLYTHEME	aero
set sys.UPID=!PID!
if not exist "!sst.root!\Users" md "!sst.root!\Users"
call "!sst.dir!\systemb\systemb-desktop.bat" || call :fail systemb-desktop exitted with exit code !errorlevel!.
>>"!sst.dir!\temp\kernelPipe" echo=exitProcess	!PID!
exit 0
:fail
echo=¤CW	!PID!.systemb_userinit	4	2	48	7	systemb-userinit	classic
echo=¤MW	!PID!.systemb_userinit	l2=  %*	l4=  Login failed.
>>"!sst.dir!\temp\kernelPipe" echo=registerWindow	!PID!	!PID!.systemb_userinit	4	2	48	7
for /l %%a in (5 -1 1) do (
	echo=¤MW	!PID!.systemb_userinit	l4=  Login failed. Exitting in %%a seconds. . .
	ping -n 2 127.0.0.1 > nul 2>&1
)
>>"!sst.dir!\temp\kernelPipe" echo=exitProcess	!PID!
exit 0
