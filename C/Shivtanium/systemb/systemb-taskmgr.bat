@echo off & setlocal enableDelayedExpansion
set /a PID=PID
set /a "win[!PID!.taskmgr]X=5, win[!PID!.taskmgr]Y=3, closeButtonX=(win[!PID!.taskmgr]W=48)-4, win[!PID!.taskmgr]H=16"
echo=¤CW	!PID!.taskmgr	!win[%PID%.taskmgr]X!	!win[%PID%.taskmgr]Y!	!win[%PID%.taskmgr]W!	!win[%PID%.taskmgr]H!	Task Manager	eyeburn
>>"!sst.dir!\temp\kernelPipe" echo=registerWindow	!PID!	!PID!.taskmgr	!win[%PID%.taskmgr]X!	!win[%PID%.taskmgr]Y!	!win[%PID%.taskmgr]W!	!win[%PID%.taskmgr]H!
set glb=──
for /l %%a in (7 2 !win[%PID%.taskmgr]W!) do set "glb=!glb!──"
set "focusedWindow=!PID!.taskmgr"

set processes=
for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t2=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000)", "timer.100cs=100"
for /l %%# in () do (
	for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000), deltaTime=(t1 - t2), t2=t1, timer.100cs+=deltaTime"
	if !timer.100cs! geq 100 (
		set /a "timer.100cs%%=100, procRange=1, procCount=0, procListH=(contentH=win[!PID!.taskmgr]H - 2) - 1, tab2=(contentW=win[!PID!.taskmgr]W - 4) - 4"
		set "_processes=!processes!"
		set "processes="
		for /l %%a in (2 1 !procListH!) do set "pid[%%a]="
		for /f "delims=*^!" %%A in ('dir /b /a:-D "!sst.dir!\temp\proc\PID-*"') do if %%~zA leq 1023 (
			set "temp.PID=%%~A"
			set "temp.PID=!temp.PID:*-=!"
			if /I "!temp.PID:~-11!" neq "-memoryDump" if /I "!temp.PID:~-4!" neq "-err" (
				set /a "procRange+=1, procCount+=1"
				set processes=!processes! "!temp.PID!"
				set "pid[!procRange!]=!temp.PID!"
			)
		)
		set temp.PID=
		if "!_processes!" neq "!processes!" (
			set buffer=¤MW	!PID!.taskmgr	l1=┌[Processes]!glb:~11!┐	l!contentH!=└[%\e%[21C!glb:~22!┘%\e%[!contentW!DRunning processes: !procCount!]
			for /l %%p in (2 1 !procListH!) do if defined pid[%%p] (
				for /f "usebackq" %%P in ("!sst.dir!\temp\proc\PID-!pid[%%p]!") do set "process=%%~P"
				set "buffer=!buffer!	l%%p=│%\e%[!contentW!C│%\e%[!contentW!D!process:~0,%closeButtonX%!%\e%8%\e%[!tab2!C!pid[%%p]!"
			) else set "buffer=!buffer!	l%%p=│%\e%[!contentW!C│"
			echo=!buffer!
			set buffer=
		)
		set > "!sst.dir!\temp\proc\PID-!PID!-memoryDump"
	)
	set kernelOut=
	set /p "kernelOut="
	if defined kernelOut if "!kernelOut!;!focusedWindow!"=="click=1;!PID!.taskmgr" (
		set /a "relativeMouseX=mouseXpos - win[!PID!.taskmgr]X, relativeMouseY=mouseYpos - win[!PID!.taskmgr]Y"
		if "!relativeMouseY!"=="0" (
			if !relativeMouseX! geq !closeButtonX! (
				>>"!sst.dir!\temp\kernelPipe" echo=exitProcess	!PID!
				exit 0
			)
		) 
	) else if "!kernelOut!"=="exitProcess=!PID!" (
		exit 0
	) else if "!kernelOut!"=="exit" (
		exit 0
	) else set "!kernelOut!">nul 2>&1
)
