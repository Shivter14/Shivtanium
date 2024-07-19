@echo off & setlocal enableDelayedExpansion
if not defined PID (
	echo=This program requires to be run in the Shivtanium Kernel.
	<nul set /p "=Press any key to exit. . ."
	pause>nul
	exit /b 1
)
set /a PID=PID
set /a "nextButtonBX=(nextButtonX=(win[!PID!.oobe]W=64)-8)+5, contentH=(win[!PID!.oobe]H=16)-2, win[!PID!.oobe]X=(sys.modeW - win[!PID!.oobe]W) / 2, win[!PID!.oobe]Y=(sys.modeH - win[!PID!.oobe]H) / 2"
echo=¤CTRL	APPLYTHEME	lo-fi
echo=¤CW	!PID!.oobe	!win[%PID%.oobe]X!	!win[%PID%.oobe]Y!	!win[%PID%.oobe]W!	!win[%PID%.oobe]H!	 	lo-fi noCBUI
>>"!sst.dir!\temp\kernelPipe" echo=registerWindow	!PID!	!PID!.oobe	!win[%PID%.oobe]X!	!win[%PID%.oobe]Y!	!win[%PID%.oobe]W!	!win[%PID%.oobe]H!
:start
set "s2=▓▓▓▒▒░░                                             ░░▒▒▓▓"
set "s3=▓▓▒▒░░   ▄▄▄ ▄    ▄      ▄            ▄            ░░▒▒▓▓▓"
set "s4=▓▓▓▒▒░░ █    █          ▄█▄                         ░░▒▒▓▓"
set "s5=▓▓▒▒░░   ▀▀▄ █▀▀▄ █ █ █  █  ▄▀▀▄ █▀▀▄ █ █  █ █▀▄▀▄ ░░▒▒▓▓▓"
set "s6=▓▓▓▒▒░░ ▄▄▄▀ █  █ █ ▀█▀  █  ▀▄▄█ █  █ █ ▀▄▄█ █ █ █  ░░▒▒▓▓"
set "s7=▓▓▒▒░░          ▀         ▀         ▀        ▀     ░░▒▒▓▓▓"
set "s8=▓▓▓▒▒░░                                             ░░▒▒▓▓"

for /l %%a in (3 4 51) do (
	set /a "off=27-%%a/2"
	echo=¤MW	!PID!.oobe^
	l2=%\e%[!off!C%\e%[7m!s2:~0,%%a!!s2:~-7!%\e%[27m^
	l3=%\e%[!off!C%\e%[7m!s3:~0,%%a!!s3:~-7!%\e%[27m^
	l4=%\e%[!off!C%\e%[7m!s4:~0,%%a!!s4:~-7!%\e%[27m^
	l5=%\e%[!off!C%\e%[7m!s5:~0,%%a!!s5:~-7!%\e%[27m^
	l6=%\e%[!off!C%\e%[7m!s6:~0,%%a!!s6:~-7!%\e%[27m^
	l7=%\e%[!off!C%\e%[7m!s7:~0,%%a!!s7:~-7!%\e%[27m^
	l8=%\e%[!off!C%\e%[7m!s8:~0,%%a!!s8:~-7!%\e%[27m
)
set last=!contentH!
for /l %%a in (!contentH! -1 10) do (
	echo=¤MW	!PID!.oobe	l!last!=	l%%a=%\e%[20CWelcome to Shivtanium‼
	set last=%%a
)
echo=¤MW	!PID!.oobe	l12=%\e%[8CBefore we put you on the desktop, we have some	l13=%\e%[17Ccustomization to go through.	o!contentH!=%\e%[!nextButtonX!C Next 

set last=
set off=
call :pagewait
echo=¤MW	!PID!.oobe	l12=	l13=
set fall=10
for /l %%a in (51 -4 3) do (
	set /a "off=27-%%a/2", "last=fall, fall+=1"
	if !last! lss !contentH! (
		set add=
		echo=¤MW	!PID!.oobe	l!last!=	l!fall!=%\e%[20CWelcome to Shivtanium‼
	) else set add=	l!contentH!=
	
	echo=¤MW	!PID!.oobe^
	l2=%\e%[!off!C%\e%[7m!s2:~0,%%a!!s2:~-7!%\e%[27m^
	l3=%\e%[!off!C%\e%[7m!s3:~0,%%a!!s3:~-7!%\e%[27m^
	l4=%\e%[!off!C%\e%[7m!s4:~0,%%a!!s4:~-7!%\e%[27m^
	l5=%\e%[!off!C%\e%[7m!s5:~0,%%a!!s5:~-7!%\e%[27m^
	l6=%\e%[!off!C%\e%[7m!s6:~0,%%a!!s6:~-7!%\e%[27m^
	l7=%\e%[!off!C%\e%[7m!s7:~0,%%a!!s7:~-7!%\e%[27m^
	l8=%\e%[!off!C%\e%[7m!s8:~0,%%a!!s8:~-7!%\e%[27m!add!
)
set last=
set fall=
set add=
echo=¤MW	!PID!.oobe	l2=	l3=	l4=	l5=	l6=	l7=	l8=

set "l2=Create a user profile"
set "l4= Username:           "
set "l7= Password:           "
for /l %%a in (1 2 21) do echo=¤MW	!PID!.oobe	l2=  !l2:~-%%a!	l4=  !l4:~-%%a!	l7=  !l7:~-%%a!	o5=%\e%[3C %\e%[%%aX	o8=%\e%[3C %\e%[%%aX
for /l %%a in (22 2 !nextButtonX!) do echo=¤MW	!PID!.oobe	o5=%\e%[3C %\e%[%%aX	o8=%\e%[3C %\e%[%%aX
call :pagewait
echo=¤MW	!PID!.oobe	o5=	o8=
goto start
:pagewait
for /l %%# in (1 1 1000) do if not defined continue for /l %%# in (1 1 1000) do if not defined continue (
	set kernelOut=
	set /p "kernelOut="
	if defined kernelOut if "!kernelOut!"=="click=1" (
		if "!focusedWindow!"=="!PID!.oobe" (
			set /a "relativeMouseX=mouseXpos - win[!PID!.oobe]X, relativeMouseY=mouseYpos - win[!PID!.oobe]Y"
			if "!relativeMouseY!"=="!contentH!" if !relativeMouseX! geq !nextButtonX! if !relativeMouseX! leq !nextButtonBX! (
				echo=¤MW	!PID!.oobe	o!contentH!=%\e%[!nextButtonX!C%\e%[7m Next %\e%[27m
			)
		)
	) else if "!kernelOut!"=="click=0" (
		if "!focusedWindow!"=="!PID!.oobe" (
			echo=¤MW	!PID!.oobe	o!contentH!=%\e%[!nextButtonX!C Next 
			set /a "relativeMouseX=mouseXpos - win[!PID!.oobe]X, relativeMouseY=mouseYpos - win[!PID!.oobe]Y"
			if "!relativeMouseY!"=="!contentH!" if !relativeMouseX! geq !nextButtonX! if !relativeMouseX! leq !nextButtonBX! (
				set continue=True
			)
		)
	) else if "!kernelOut!"=="exitProcess=!PID!" (
		exit 0
	) else if "!kernelOut!"=="exit" (
		exit 0
	) else set "!kernelOut!">nul 2>&1
)
if not defined continue goto pagewait
set continue=
exit /b 0
