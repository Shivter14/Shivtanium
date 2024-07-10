@echo off & setlocal enableDelayedExpansion
if not defined PID (
	echo This program requires to be run in:
	echo   Shivtanium Kernel Beta 1.2.1 or higher.
	set /p "=Press any key to exit. . ."
	exit /b 1
)
for %%a in (%*) do (
	if defined next (
		set "!next!=%%~a"
		set next=
	) else (
		set next=
		if "%%a"=="--username" (
			set next=sys.username
		) else if "%%a"=="--UPID" (
			set next=sys.UPID
		) else if "%%a"=="--working-dir" (
			set next=setdir
		)
	)
)
set /a "closeButtonX=(win[!PID!.conhost]W=sys.modeW/2)-3, conP=(conH=(win[!PID!.conhost]H=sys.modeH/2)-4)+2, win[!PID!.conhost]X=sys.modeW/4, win[!PID!.conhost]Y=sys.modeH/4"

echo=¤CW	!PID!.conhost	!win[%PID%.conhost]X!	!win[%PID%.conhost]Y!	!win[%PID%.conhost]W!	!win[%PID%.conhost]H!	Terminal	discord
echo=¤MW	!PID!.conhost	l!conP!=]
>>"!sst.dir!\temp\kernelPipe" echo=registerWindow	!PID!	!PID!.conhost	!win[%PID%.conhost]X!	!win[%PID%.conhost]Y!	!win[%PID%.conhost]W!	!win[%PID%.conhost]H!
set "input= "
for /l %%# in () do (
	set kernelOut=
	set /p "kernelOut="
	if defined kernelOut if "!kernelOut:~0,14!"=="keysPressedRN=" (
		set "!kernelOut!" > nul 2>&1
		if "!focusedWindow!"=="!PID!.conhost" for %%k in (!keysPressedRN!) do (
			set "char=!charset_L:~%%k,1!"
			if "!keysPressed!" neq "!keysPressed:-16-=!" set "char=!charset_U:~%%k,1!"
			if "!keysPressed!" neq "!keysPressed:-17-=!" set "char=!charset_A:~%%k,1!"
			if "!char!"==" " (
				if "%%~k" neq "32" set char=
				if "%%~k"=="8" (
					if "!input!" neq " " set "input=!input:~0,-1!"
					echo=¤MW	!PID!.conhost	l!conP!=]!input!
				) else if "%%~k"=="13" (
					if /I "!input!"==" exit" (
						>>"!sst.dir!\temp\kernelPipe" echo=exitProcess	!PID!
						exit 0
					)
					for /f "delims=*^!	" %%a in ('echo=]!input!^& !input:~1! 2^>^&1') do (
						for /l %%y in (1 1 !conH!) do (
							set /a "x=%%y+1"
							for %%z in (!x!) do set "l%%y=!l%%z!"
						)
						set "l!x!=%%a"
					)
					set pipe=
					for /l %%y in (1 1 !conP!) do set "pipe=!pipe!	l%%y=!l%%y!"
					set "input= "
					echo=¤MW	!PID!.conhost	l!conP!=]!input!!pipe!
					set pipe=
				) else if "%%~k"=="27" (
					set "input= "
					echo=¤MW	!PID!.conhost	l!conP!=]!input!
				)
			)
			if defined char (
				set "input=!input!!char!"
				echo=¤MW	!PID!.conhost	l!conP!=]!input!
			)
		)
	) else if "!kernelOut!"=="click=1" (
		set /a "click=1, relativeMouseX=mouseXpos-win[!PID!.conhost]X, relativeMouseY=mouseYpos-win[!PID!.conhost]Y"
		if "!relativeMouseY!"=="0" if !relativeMouseX! geq !closeButtonX! (
			>>"!sst.dir!\temp\kernelPipe" echo=exitProcess	!PID!
			exit 0
		)
	) else if "!kernelOut!"=="exitProcess=!PID!" (
		exit 0
	) else if "!kernelOut!"=="exit" (
		exit 0
	) else set "!kernelOut!" > nul 2>&1
)

:con
for /l %%# in () do (
	set conIn=
	set /p "conIn="
	if defined conIn echo=!conIn!
)