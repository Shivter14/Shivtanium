@echo off & setlocal enableDelayedExpansion
echo=¤OV	%\e%[999;1H%\e%[48;2;0;63;127;38;2;255;255;255m Shivtanium %\e%[48;2;0;31;63m%\e%[0K

for /l %%# in () do (
	set kernelOut=
	set /p "kernelOut="
	if defined kernelOut (
		if "!kernelOut!"=="exit" (
			exit 0
		) else if "!kernelOut!"=="exitProcess=!PID!" (
			exit 0
		) else if "!kernelOut:~0,14!"=="focusedWindow=" (
			set "!kernelOut!" >nul 2>&1
			if "!focusedWindow!" neq "systemb_launcher" echo=¤OV	%\e%[999;1H%\e%[48;2;0;63;127;38;2;255;255;255m Shivtanium %\e%[48;2;0;31;63m%\e%[0K !focusedWindow!
		) else if "!kernelOut!"=="click=1" (
			set click=1
			if not defined focusedWindow (
				if "!mouseYpos!"=="!sys.modeH!" if !mouseXpos! leq 12 (
					>>"!sst.dir!\temp\kernelPipe" echo=createProcess	!PID!	systemb-launcher.bat --username "!sys.username!" --UPID !sys.UPID!
				)
			)
		) else set "!kernelOut!" > nul 2>&1
	)
	
)

exit /b 70

< This will never execute >

set /a "win[%PID%.kernelOut]W=64, win[%PID%.kernelOut]H=16, temp.consoleBufferH=win[%PID%.kernelOut]H-2, win[%PID%.kernelOut]X=sys.modeW-win[%PID%.kernelOut]W-1, win[%PID%.kernelOut]Y=sys.modeH-win[%PID%.kernelOut]H-2"

echo=¤CW	!PID!.kernelOut	!win[%PID%.kernelOut]X!	!win[%PID%.kernelOut]Y!	!win[%PID%.kernelOut]W!	!win[%PID%.kernelOut]H!	Kernel output	classic noCBUI
>>"!sst.dir!\temp\kernelPipe" echo=registerWindow	!PID!	!PID!.kernelOut	!win[%PID%.kernelOut]X!	!win[%PID%.kernelOut]Y!	!win[%PID%.kernelOut]W!	!win[%PID%.kernelOut]H!

		for /l %%a in (2 1 !temp.consoleBufferH!) do (
			set /a temp.newpos=%%a-1
			set "CB[!temp.newpos!]=!CB[%%a]!"
		)
		set stream=¤MW	!PID!.kernelOut
		set "CB[!temp.consoleBufferH!]=!kernelOut:	=  !"
		for /l %%a in (1 1 !temp.consoleBufferH!) do (
			set "stream=!stream!	l%%a=!CB[%%a]!"
		)
		echo=!stream!
