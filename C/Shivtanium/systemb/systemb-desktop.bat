@echo off & setlocal enableDelayedExpansion

for /l %%# in () do (
	set _expTime=!expTime!
	set expTime=!time:~0,-6!
	if "!_expTime!" neq "!expTime!" (
		echo=¤OV	%\e%[999;1H%\e%[48;2;0;63;127;38;2;255;255;255m Shivtanium %\e%[48;2;0;31;63m%\e%[0K !focusedWindow!%\e%[999C%\e%[24D!date! !expTime!
	)
	set kernelOut=
	set /p "kernelOut="
	if defined kernelOut (
		if "!kernelOut!"=="exit" (
			exit 0
		) else if "!kernelOut!"=="exitProcess=!PID!" (
			exit 0
		) else if "!kernelOut:~0,14!"=="focusedWindow=" (
			set "!kernelOut!" >nul 2>&1
			if "!focusedWindow!" neq "systemb_launcher" echo=¤OV	%\e%[999;1H%\e%[48;2;0;63;127;38;2;255;255;255m Shivtanium %\e%[48;2;0;31;63m%\e%[0K !focusedWindow!%\e%[999C%\e%[24D!date! !expTime!
		) else if "!kernelOut!"=="click=1" (
			if not defined focusedWindow if "!mouseYpos!"=="!sys.modeH!" if !mouseXpos! leq 12 call :launcher
		) else set "!kernelOut!" > nul 2>&1
	)
	
)

:launcher
echo=¤OV	%\e%[999;1H%\e%[48;2;63;127;192;38;2;255;255;255m Shivtanium %\e%[48;2;0;31;63m%\e%[0K%\e%[999C%\e%[24D!date! !expTime!
set /a "win[systemb_launcher]X=1, tempY=sys.modeH-1, win[systemb_launcher]W=38, win[systemb_launcher]H=12, win[systemb_launcher]Y=sys.modeH-win[systemb_launcher]H, tempH=win[systemb_launcher]H+1"
if "!sys.lowPerformanceMode!"=="True" (
	set "tempY=!win[systemb_launcher]Y!"
	set theme=classic
	set sys.reduceMotion=True
) else set theme=discord
echo=¤CW	systemb_launcher	!win[systemb_launcher]X!	!tempY!	!win[systemb_launcher]W!	!win[systemb_launcher]H!	Application Launcher	!theme! noCBUI
>>"!sst.dir!\temp\kernelPipe" echo=registerWindow	!PID!	systemb_launcher	!win[systemb_launcher]X!	!win[systemb_launcher]Y!	!win[systemb_launcher]W!	!tempH!	1
if "!sys.reduceMotion!" neq "True" for /l %%y in (!tempY! -1 !win[systemb_launcher]Y!) do (
	echo=¤MW	systemb_launcher	Y=%%y
)
echo=¤MW	systemb_launcher	Y=!win[systemb_launcher]Y!

set "math=win[systemb_launcher]BY=win[systemb_launcher]Y+win[systemb_launcher]H-1, sidebarW=12, itemW=(sidebarX=win[systemb_launcher]W-sidebarW-2)-2"
set "buttons= "

for %%b in (
	"about		sidebarW	sidebarX	win[systemb_launcher]BY-8	:about		About"
	"settings	sidebarW	sidebarX	win[systemb_launcher]BY-7	:settings	Settings"
	"terminal	sidebarW	sidebarX	win[systemb_launcher]BY-6	:terminal	Terminal"
	"explorer	sidebarW	sidebarX	win[systemb_launcher]BY-5	:explorer	Explorer"
	"logout		sidebarW	sidebarX	win[systemb_launcher]BY-3	:logout		Log Out"
	"restart	sidebarW	sidebarX	win[systemb_launcher]BY-2	:restart	Restart"
	"shutdown	sidebarW	sidebarX	win[systemb_launcher]BY-1	:shutdown	Shut Down"
	
	"calculator	win[systemb_launcher]W-sidebarW-6	2	win[systemb_launcher]Y+2	:calculator	Calculator"
	"taskmgr	win[systemb_launcher]W-sidebarW-6	2	win[systemb_launcher]Y+3	:taskmgr	Task Manager"
	"NEL		win[systemb_launcher]W-sidebarW-6	2	win[systemb_launcher]Y+4	:launchProgram NewEngine-Launcher\Shivtanium-NewEngine-Launcher.bat	NewEngine Launcher"
	"tetris		win[systemb_launcher]W-sidebarW-6	2	win[systemb_launcher]Y+5	:launchProgram Shivtanium-Tetris\tetris.bat	Tetris"
) do for /f "tokens=1-5* delims=	" %%0 in ("%%~b") do (
	set "buttons="%%~0" !buttons!"
	set "button[%%~0]=%%~4"
	set "button[%%~0]title= %%~5"
	set math=!math!, "button[%%~0]W=%%~1, button[%%~0]X=%%~2, button[%%~0]Y=%%~3, button[%%~0]DY=button[%%~0]Y-win[systemb_launcher]Y, button[%%~0]BX=button[%%~0]X+button[%%~0]W-1"
)

set /a !math!
set math=
for %%b in (!buttons!) do for /f "tokens=1* delims=;" %%y in ("!button[%%~b]DY!;!button[%%~b]W!") do (
	set "o%%y=!o%%y!%\e%8%\e%[!button[%%~b]X!C%\e%[!button[%%~b]W!X!button[%%~b]title:~0,%%~z!"
)
set pipe=
if "!sys.reduceMotion!"=="True" (
	set pipe=¤MW	systemb_launcher
	set "add=set pipe=^!pipe^!"
) else (
	set "add=echo=¤MW	systemb_launcher"
)

for /l %%y in (!win[systemb_launcher]H! -1 1) do (
	if defined o%%y %add%	o%%y=!o%%y:~2!
)
if defined pipe (
	echo=!pipe!
	set pipe=
)
set exit=
:launcher.loop
for /l %%# in (1 1 1000) do if not defined exit for /l %%# in (1 1 1000) do if not defined exit (
	set _expTime=!expTime!
	set expTime=!time:~0,-6!
	if "!_expTime!" neq "!expTime!" (
		echo=¤OV	%\e%[999;1H%\e%[48;2;0;63;127;38;2;255;255;255m Shivtanium %\e%[48;2;0;31;63m%\e%[0K !focusedWindow!%\e%[999C%\e%[24D!date! !expTime!
	)
	set kernelOut=
	set /p "kernelOut="
	if defined kernelOut if "!kernelOut!"=="click=1" (
		if "!focusedWindow!"=="systemb_launcher" (
			for %%b in (!buttons!) do (
				if "!mouseYpos!"=="!button[%%~b]Y!" if !mouseXpos! geq !button[%%~b]X! if !mouseXpos! leq !button[%%~b]BX! (
					call !button[%%~b]!
					set exit=True
				)
			)
		) else (
			call :exit
			set exit=True
		)
	) else if "!kernelOut!"=="exit" (
		exit 0
	) else if "!kernelOut!"=="exitProcess=!PID!" (
		exit 0
	) else set "!kernelOut!" > nul 2>&1
)
set focusedWindow=
if not defined exit goto launcher.loop
exit /b 0
:shutdown
(
	echo=exitProcess	!PID!
	echo=powerState	shutdown
) >> "!sst.dir!\temp\kernelPipe"
exit 0
:restart
(
	echo=exitProcess	!PID!
	echo=powerState	reboot
) >> "!sst.dir!\temp\kernelPipe"
exit 0
:logout
(
	echo=createProcess	0	systemb-login.bat
	echo=exitProcess	!PID!
	echo=exitProcessTree	!sys.UPID!
) >> "!sst.dir!\temp\kernelPipe"
exit 0
:calculator
>>"!sst.dir!\temp\kernelPipe" echo=createProcess	!sys.UPID!	systemb-calculator.bat
goto exit
:explorer
>>"!sst.dir!\temp\kernelPipe" echo=createProcess	!sys.UPID!	systemb-explorer.bat --username "!sys.username!" --UPID !sys.UPID!
goto exit
:terminal
>>"!sst.dir!\temp\kernelPipe" echo=createProcess	!sys.UPID!	systemb-console.bat --username "!sys.username!" --UPID !sys.UPID!
goto exit
:settings
>>"!sst.dir!\temp\kernelPipe" echo=createProcess	!sys.UPID!	systemb-control-panel.bat --username "!sys.username!" --UPID !sys.UPID!
goto exit
:taskmgr
>>"!sst.dir!\temp\kernelPipe" echo=createProcess	!sys.UPID!	systemb-taskmgr.bat --username "!sys.username!" --UPID !sys.UPID!
goto exit
:about
set "sys.username=!sys.username!."
>>"!sst.dir!\temp\kernelPipe" echo=createProcess	!sys.UPID!	systemb-dialog.bat (sys.modeW-w)/2+1 3 60 15 "About Shivtanium"^
 "l1=%\e%[7m▓▓▓▒▒░░%\e%[45X%\e%[45C░░▒▒▓▓%\e%[27m	l2=%\e%[7m▓▓▒▒░░   ▄▄▄ ▄    ▄      ▄%\e%[12X%\e%[12C▄%\e%[12X%\e%[12C░░▒▒▓▓▓%\e%[27m	l3=%\e%[7m▓▓▓▒▒░░ █    █          ▄█▄%\e%[25X%\e%[25C░░▒▒▓▓%\e%[27m	l4=%\e%[7m▓▓▒▒░░   ▀▀▄ █▀▀▄ █ █ █  █  ▄▀▀▄ █▀▀▄ █ █  █ █▀▄▀▄ ░░▒▒▓▓▓%\e%[27m	l5=%\e%[7m▓▓▓▒▒░░ ▄▄▄▀ █  █ █ ▀█▀  █  ▀▄▄█ █  █ █ ▀▄▄█ █ █ █  ░░▒▒▓▓%\e%[27m	l6=%\e%[7m▓▓▒▒░░%\e%[45X%\e%[10C▀%\e%[9C▀%\e%[9C▀%\e%[8C▀     ░░▒▒▓▓▓%\e%[27m	l7=%\e%[7m▓▓▓▒▒░░%\e%[45X%\e%[45C░░▒▒▓▓%\e%[27m	l9=  Shivtanium version !sys.tag! !sys.ver! !sys.subvinfo!	l10=  Copyright © Shivter 2021 - 2024	l12=  Logged in as !sys.username:~0,43!" w-buttonW-2 h-2 7 " Close "
 
goto exit
:launchProgram
set "arg=%~1"
>>"!sst.dir!\temp\kernelPipe" echo=createProcess	!sys.UPID!	programs\!arg! --username "!sys.username!" --UPID !sys.UPID!
:exit
if "!sys.reduceMotion!" neq "True" (
	for /l %%y in (!win[systemb_launcher]Y! 1 !sys.modeH!) do echo=¤MW	systemb_launcher	Y=%%y
	echo=¤MW	systemb_launcher	Y=!sys.modeH!
)
echo=¤DW	systemb_launcher
>>"!sst.dir!\temp\kernelPipe" echo=unRegisterWindow	systemb_launcher
echo=¤OV	%\e%[999;1H%\e%[48;2;0;63;127;38;2;255;255;255m Shivtanium %\e%[48;2;0;31;63m%\e%[0K%\e%[999C%\e%[24D!date! !expTime!
set exit=True
exit /b
