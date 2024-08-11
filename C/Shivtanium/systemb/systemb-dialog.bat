@echo off & setlocal enableDelayedExpansion
set "initial_window_params=%~5"
set "secondary_window_params=%~6"
set /a PID=PID
set /a "closeButtonX=(w=win[!PID!.systemb_dialog]W=%~3)-4, bx=x+w-1, h=win[!PID!.systemb_dialog]H=%~4, x=win[!PID!.systemb_dialog]X=%~1, y=win[!PID!.systemb_dialog]Y=%~2, buttonW=%~9, buttonX=%~7, buttonY=%~8, buttonB=buttonX+buttonW-1" || >&2 echo=^^^^^^ At %~n0
if !win[%PID%.systemb_dialog]W! lss 16 set /a "closeButtonX=(win[!PID!.systemb_dialog]W=32)-4"
if !win[%PID%.systemb_dialog]H! lss 3 set "win[!PID!.systemb_dialog]H=7"
if !win[%PID%.systemb_dialog]W! gtr !sys.modeW! set /a "x=win[!PID!.systemb_dialog]X=1, w=bx=win[!PID!,systemb_dialog]W=modeW, buttonW=%~9, buttonX=%~7, buttonB=buttonX+buttonW-1" || >&2 echo=^^^^^^ At %~n0
if !win[%PID%.systemb_dialog]Y! geq !sys.modeH! set /a "win[!PID!.systemb_dialog]Y=sys.modeH-1, buttonY=%~8" || >&2 echo=^^^^^^ At %~n0
if !bx! gtr !sys.modeW! set /a "x=win[!PID!.systemb_dialog]X=(bx=sys.modeW)-w+1, buttonW=%~9, buttonX=%~7, buttonB=buttonX+buttonW-1" || >&2 echo=^^^^^^ At %~n0

shift /1
set "buttonName=%~9"
echo=¤CW	!PID!.systemb_dialog	!win[%PID%.systemb_dialog]X!	!win[%PID%.systemb_dialog]Y!	!win[%PID%.systemb_dialog]W!	!win[%PID%.systemb_dialog]H!	!initial_window_params!
echo=¤MW	!PID!.systemb_dialog	!secondary_window_params!	o!buttonY!=%\e%[!buttonX!C!buttonName!
>>"!sst.dir!\temp\kernelPipe" echo=registerWindow	!PID!	!PID!.systemb_dialog	!win[%PID%.systemb_dialog]X!	!win[%PID%.systemb_dialog]Y!	!win[%PID%.systemb_dialog]W!	!win[%PID%.systemb_dialog]H!
set "focusedWindow=!PID!.systemb_dialog"
for /l %%# in () do (
	set kernelOut=
	set /p "kernelOut="
	if defined kernelOut (
		if "!kernelOut!"=="exit" (
			exit
		) else if "!kernelOut!"=="exitProcess=!PID!" (
			exit
		) else if "!kernelOut!"=="click=1" (
			if "!focusedWindow!"=="!PID!.systemb_dialog" (
				set /a "relativeMouseX=mouseXpos-win[!PID!.systemb_dialog]X, relativeMouseY=mouseYpos-win[!PID!.systemb_dialog]Y"
				if "!relativeMouseY!"=="0" if !relativeMouseX! geq !closeButtonX! (
					>>"temp\kernelPipe" echo=exitProcess	!PID!
					exit 0
				)
				if "!relativeMouseY!"=="!buttonY!" if !relativeMouseX! geq !buttonX! if !relativeMouseX! leq !buttonB! (
					echo=¤MW	!PID!.systemb_dialog	o!buttonY!=%\e%[!buttonX!C%\e%[7m!buttonName!%\e%[27m
				)
			)
		) else if "!kernelOut!"=="click=0" (
			if "!focusedWindow!"=="!PID!.systemb_dialog" (
				set /a "relativeMouseX=mouseXpos-win[!PID!.systemb_dialog]X, relativeMouseY=mouseYpos-win[!PID!.systemb_dialog]Y"
				if "!relativeMouseY!"=="!buttonY!" if !relativeMouseX! geq !buttonX! if !relativeMouseX! leq !buttonB! (
					>>"temp\kernelPipe" echo=exitProcess	!PID!
					exit 0
				)
				echo=¤MW	!PID!.systemb_dialog	o!buttonY!=%\e%[!buttonX!C!buttonName!
			)
		) else set "!kernelOut!" > nul 2>&1
	)
)
