@echo off & setlocal enableDelayedExpansion
echo=¤OV	%\e%[999;1H%\e%[48;2;63;127;192;38;2;255;255;255m Shivtanium %\e%[48;2;0;31;63m%\e%[0K
set /a "win[systemb_launcher]X=1, win[systemb_launcher]Y=sys.modeH-1, win[systemb_launcher]W=32, win[systemb_launcher]H=16, tempY=sys.modeH-win[systemb_launcher]H, tempH=win[systemb_launcher]H+1"
echo=¤CW	systemb_launcher	!win[systemb_launcher]X!	!win[systemb_launcher]Y!	!win[systemb_launcher]W!	!win[systemb_launcher]H!	Application Launcher	discord noCBUI
>>"!sst.dir!\temp\kernelPipe" echo=registerWindow	!PID!	systemb_launcher	!win[systemb_launcher]X!	!tempY!	!win[systemb_launcher]W!	!tempH!	1

for /l %%y in (!win[systemb_launcher]Y! -2 !tempY!) do (
	set "win[systemb_launcher]Y=%%y"
	echo=¤MW	systemb_launcher	Y=%%y
)
echo=¤MW	systemb_launcher	Y=!tempY!

for %%a in (%*) do (
	if defined next (
		set "!next!=%%~a"
		set next=
	) else (
		set next=
		if "%%a"=="--username" (
			set next=sys.username
		) else if "%%a"=="--UPID" set next=sys.UPID
	)
)

if not defined sys.UPID (
	echo=createProcess	!PID!	systemb-dialog.bat 5 !tempY! 44 7 "systemb-launcher	classic" "l2=  The process failed to start:	l3=    You need to be logged in,	l4=    in order to use systemb-launcher." 35 5 7 " Close "
	echo=exitProcess	!PID!
	exit 0
) >> "!sst.dir!\temp\kernelPipe"

set "math=win[systemb_launcher]Y=tempY, win[systemb_launcher]BY=win[systemb_launcher]Y+win[systemb_launcher]H-1, sidebarW=12, sidebarX=win[systemb_launcher]W-sidebarW-2"
set "buttons= "

for %%b in (
	"shutdown	sidebarW	sidebarX	win[systemb_launcher]BY-1	:shutdown	Shut Down"
	"logout		sidebarW	sidebarX	win[systemb_launcher]BY-2	:logout		Log Out"
	"calculator	sidebarW	sidebarX	win[systemb_launcher]BY-3	:calculator	Calculator"
	"explorer	sidebarW	sidebarX	win[systemb_launcher]BY-4	:explorer	Explorer"
) do for /f "tokens=1-5* delims=	" %%0 in ("%%~b") do (
	set "buttons=!buttons!"%%~0" "
	set "button[%%~0]=%%~4"
	set "button[%%~0]title=%%~5"
	set math=!math!, "button[%%~0]W=%%~1, button[%%~0]X=%%~2, button[%%~0]Y=%%~3, button[%%~0]DY=button[%%~0]Y-win[systemb_launcher]Y, button[%%~0]BX=button[%%~0]X+button[%%~0]W-1"
)

set /a !math!
set pipe=¤MW	systemb_launcher
for %%b in (!buttons!) do for /f "" %%y in ("!button[%%~b]DY!") do (
	set "win[systemb_launcher]o%%y=!win[systemb_launcher]o%%y!%\e%8%\e%[!button[%%~b]X!C%\e%[!button[%%~b]W!X !button[%%~b]title!"
	set "pipe=!pipe!	o%%y=!win[systemb_launcher]o%%y:~2!"
)
echo=!pipe!
set math=
set pipe=

for /l %%# in () do (
	set kernelOut=
	set /p "kernelOut="
	if defined kernelOut if "!kernelOut!"=="click=1" (
		if "!focusedWindow!"=="systemb_launcher" (
			for %%b in (!buttons!) do (
				if "!mouseYpos!"=="!button[%%~b]Y!" if !mouseXpos! geq !button[%%~b]X! if !mouseXpos! leq !button[%%~b]BX! (
					call !button[%%~b]!
				)
			)
		) else (
			call :exit
		)
	) else if "!kernelOut!"=="exit" (
		exit 0
	) else if "!kernelOut!"=="exitProcess=!PID!" (
		exit 0
	) else set "!kernelOut!" > nul 2>&1
)
:shutdown
echo=¤OV	%\e%[999;1H%\e%[48;2;0;31;63;38;2;255;255;255m%\e%[0K
(
	echo=exitProcess	!PID!
	echo=exitProcessTree	0
	echo=exitProcessTree	!sys.UPID!
	exit 0
) >> "!sst.dir!\temp\kernelPipe"
:logout
echo=¤OV	%\e%[999;1H%\e%[48;2;0;31;63;38;2;255;255;255m%\e%[0K
(
	echo=createProcess	0	systemb-login.bat
	echo=exitProcess	!PID!
	echo=exitProcessTree	!sys.UPID!
	exit 0
) >> "!sst.dir!\temp\kernelPipe"
:calculator
>>"!sst.dir!\temp\kernelPipe" echo=createProcess	!sys.UPID!	systemb-calculator.bat
goto exit
:explorer
>>"!sst.dir!\temp\kernelPipe" echo=createProcess	!sys.UPID!	systemb-explorer.bat --username "!sys.username!" --UPID !sys.UPID!
:exit
for /l %%y in (!win[systemb_launcher]Y! 2 !sys.modeH!) do echo=¤MW	systemb_launcher	Y=%%y
echo=¤MW	systemb_launcher	Y=!sys.modeH!
echo=¤OV	%\e%[999;1H%\e%[48;2;0;63;127;38;2;255;255;255m Shivtanium %\e%[48;2;0;31;63m%\e%[0K
>>"!sst.dir!\temp\kernelPipe" echo=exitProcess	!PID!
exit 0
