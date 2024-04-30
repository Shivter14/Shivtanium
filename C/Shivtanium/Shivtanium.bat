@echo off
setlocal enabledelayedexpansion
for %%a in (
	"sst.boot"
	"ssvm.boot"
	"temp"
	"spr"
) do for /f "tokens=1 delims==" %%b in ('set %%a') do set "%%b="
call :reload
for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000),t2=t1,sendtimer=0"
set windows=
set win.focused=
cmd /c timeout 0 /nobreak > nul
for /l %%- in (.) do (
	for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000)"
	set /a "deltaTime=(t1 - t2)", "$TT+=deltaTime", "timer.100cs+=deltaTime", "$sec=$TT / 100 %% 60", "$min=$TT / 100 / 60 %% 60", "tpsTicks+=1", "t2=t1"
	if !timer.100cs! GEQ 100 (
		set /a "timer.100cs-=100,tps=tpsTicks,tpsTicks=0"
		if !timer.100cs! GEQ 100 set timer.100cs=0
	)
	
	set iobuffers=0
	for %%p in (!sst.processes.paused!) do (
		if defined pid[%%p].timeout (
			set /a "pid[%%p].timeout-=deltaTime"
			if !pid[%%~p].timeout! leq 0 (
				set sst.processes.paused=!sst.processes.paused: %%p=!
				set sst.processes=!sst.processes! %%p
			)
		)
	)
	
	set sys.mouseXpos=!mouseXpos!
	set sys.mouseYpos=!mouseYpos!
	set sys.keys=!keysPressed!
	if "!click!"=="1" (
		if "!sys.click!"=="0" (
			set sys.click=1
		) else set /a sys.click+=deltaTime
		if "!sys.click!"=="1" (
			set temp.focus=
			for %%w in (!windows!) do if not defined temp.focus if !sys.mouseXpos! geq !win[%%~w]X! if !sys.mouseXpos! leq !win[%%~w]BX! (
				if !sys.mouseYpos! geq !win[%%~w]Y! if !sys.mouseYpos! leq !win[%%~w]BY! if "!win.focused!" neq "%%~w" (
					set /a iobuffers+=1
					echo(¤FOCUS	%%~w
					set windows="%%~w" !windows: "%%~w"=!
					set "win.focused=%%~w"
					set temp.focus=True
				)
			)
			set temp.focus=
		)
	) else set sys.click=0
	for %%p in (!sst.processes!) do (
		for %%n in ("!pid[%%~p]cl!") do (
			set "parameters=!pid[%%~p]l[%%~n]:^*=\s!"
			set parameters=!parameters:$=" "$" "!$
			set whitespace=
			set expanded=
			for %%x in ("!parameters:~0,-1!") do (
				if defined whitespace (
					if "%%~x"=="$" (
						for /f "tokens=1* delims=." %%y in ("!whitespace:~1!") do (
							if "!whitespace:~0,7!"=="$global." (
								set "expanded=!expanded!!glob.%%z!"
							) else if "!whitespace:~0,5!"=="$sys." (
								set sys.random=!random!
								set "expanded=!expanded!!sys.%%z!"
							) else if "!whitespace!"=="$" (
								set "expanded=!expanded!$"
							) else if "%%z"=="" (
								set "expanded=!expanded!!pid[%%~p]v%%y!"
							) else set "expanded=!expanded!!pid[%%~p]v%%y.%%z!"
							set whitespace=
						)
					) else set "whitespace=!whitespace!%%~x"
				) else (
					if "%%~x"=="$" (
						set whitespace=$
					) else set "expanded=!expanded!%%~x"
				)
			)
			if "!expanded:~0,4!"=="set	" (
				if "!expanded:~4,7!"=="global." (
					set "glob.!expanded:~4!" > nul
				) else if "!expanded:~4,4!"=="sys." (
					call :haltScripts %%p "Invalid syntax for command 'set'" "The process tried to re-define a system variable:\nFull command: '!expanded:	= !'" sys.var_redef
				) else (
					set "pid[%%~p]v!expanded:~4!"
				)
			) else if "!expanded:~0,5!"=="math	" (
				set /a "pid[%%~p]vresult=!expanded:~5!"
			) else if "!expanded:~0,5!"=="goto	" (
				set runtick=
				for /f "delims=" %%b in ("!expanded:~5!") do (
					if "!pid[%%~p]#%%~b!"=="" call :haltScripts %%p "Invalid syntax for command 'goto'" "Label not found: '%%~b'\nFull command: !expanded:	= !" goto.not_found
					set "pid[%%~p]cl=!pid[%%~p]#%%~b!-1"
				)
			) else if "!expanded:~0,7!"=="expand	" (
				for /f "delims=" %%v in ("!expanded:~7!") do if "!expanded:~7,7!"=="global." (
					"pid[%%~p]vresult=!glob.%%v!"
				) else if "!expanded:~7,4!"=="sys." (
					set "pid[%%~p]vresult=!sys.%%b!"
				) else set "pid[%%~p]vresult=!pid[%%~p]v%%v!"
			) else if "!expanded:~0,5!"=="wait	" (
				set "expanded=!expanded:~5!"
				set /a "pid[%%~p].timeout=expanded" 2>nul || call :haltScripts %%p "Invalid Syntax for command 'wait'" "Expected: wait <number>\nFull command: !expanded:	= !" wait.syntax_error
				set sst.processes=!sst.processes: %%p=!
				set sst.processes.paused=!sst.processes.paused! %%p
				set runtick=
			) else if "!expanded:~0,4!"=="log	" (
				echo(!expanded:~4!
			) else if "!expanded:~0,13!"=="modifyWindow	" (
				set temp.args=!expanded:	=" "!
				for %%a in ("!temp.args!") do if not defined temp.args (
					if defined temp.id (
						set "win[!temp.id!]%%~a" >nul 2>nul
					) else (
						set "temp.id=#%%~p.%%~a"
						for %%c in (a b c d e f g h i j k l m n o p q r s t u v w x y z _ . 1 2 3 4 5 6 7 8 9 0) do set "temp.id=!temp.id:%%c=!"
						if "!temp.id!" neq "#" (
							call :haltScripts %%p "Whitespace error" "Invalid window ID: '%%~a'\nInvalid characters: '!temp.id!'" command.whitespace
						) else set "temp.id=%%~p.%%~a"
						if "!win[%%~p.%%~a]!"=="" call :haltScripts %%p "Attempt to modify non-existent window" "Window ID: '%%~a'" id.undefined
					)
				) else set temp.args=
				if "!temp.id:~127,1!" neq "" call :haltScripts %%p "Parameter too long" "Parameter: ID, lenght: Greater than 127.\nFull command: '!expanded:~0,512!'"
				for /f "delims==" %%a in ("!temp.id!") do (
					set /a "win[%%~a]X=win[%%~a]X", "win[%%~a]Y=win[%%~a]Y", "win[%%~a]W=win[%%~a]W", "win[%%~a]H=win[%%~a]H"
					if !win[%%~a]X! lss 0 set "win[%%~a]X=0"
					if !win[%%~a]Y! lss 0 set "win[%%~a]Y=0"
					if !win[%%~a]W! lss 12 set "win[%%~a]W=12"
					if !win[%%~a]H! lss 3 set "win[%%~a]H=3"
					set /a "win[%%~a]BX=win[%%~a]X+win[%%~a]W-1", "win[%%~a]BY=win[%%~a]Y+win[%%~a]H-1", "iobuffers+=1"
				)
				
				set "iobuffer=¤MW"
				set "temp.args=!expanded:~13!"
				set temp.args=!temp.args:	=" "!
				for %%a in ("!temp.args!") do if not defined temp.args (
					set "iobuffer=!iobuffer!	%%~a"
				) else (
					set temp.args=
					set "iobuffer=!iobuffer!	%%~p.%%~a"
				)
				echo(!iobuffer!
				set iobuffer=
				set temp.args=
			) else if "!expanded:~0,10!"=="setButton	" (
				for /f "tokens=1-6* delims=	" %%0 in ("!expanded:~10!") do (
					if "!win[%%~0!"=="" call :haltScripts %%p "Attempt to modify non-existent window" "Window ID: '%%~0'\nAction: 'setButton'"
					set "temp.id=#%%~1"
					for %%c in (a b c d e f g h i j k l m n o p q r s t u v w x y z _ . 1 2 3 4 5 6 7 8 9 0) do set "temp.id=!temp.id:%%c=!"
					if "!temp.id!" neq "#" call :haltScripts %%p "Whitespace error" "Invalid button ID: '%%~1'\nInvalid characters: '!temp.id!'" command.whitespace
					set "proc[%%~p]btn[%%~1]=%%~6"
					set /a "proc[%%~p]btn[%%~1]X=%%~2", "proc[%%~p]btn[%%~1]Y=%%~3", "proc[%%~p]btn[%%~1]W=%%~4", "proc[%%~p]btn[%%~1]W=%%~5", "iobuffers+=1">nul 2>nul
					set proc[%%~p]buttons="%%~1" !proc[%%~p]buttons!
					for /f "tokens=1,2" %%x in ("!proc[%%~p]btn[%%~0]X! !proc[%%~p]btn[%%~0]Y!") do (
						set "io[!iobuffers!]=MW %%~0 p%%~y=!win[%%~0]p%%~y!"
						rem Todo: add buttons loolololol
					)
				)
			) else if "!expanded:~0,13!"=="createWindow	" (
				set temp.args=!expanded:	=" "!
				set temp.id=
				for %%a in ("!temp.args!") do if not defined temp.args (
					if defined temp.id (
						set "win[!temp.id!]%%~a" >nul 2>nul
					) else (
						set "temp.id=#%%~p.%%~a"
						for %%c in (a b c d e f g h i j k l m n o p q r s t u v w x y z _ . 1 2 3 4 5 6 7 8 9 0) do set "temp.id=!temp.id:%%c=!"
						if "!temp.id!" neq "#" (
							call :haltScripts %%p "Whitespace error" "Invalid window ID: '%%~a'\nInvalid characters: '!temp.id!'" command.whitespace
						) else (
							set "temp.id=%%~p.%%~a"
							set "win[!temp.id!]=x"
						)
					)
				) else set temp.args=
				if "!temp.id:~127,1!" neq "" call :haltScripts %%p "Parameter too long" "Parameter: ID, lenght: Greater than 127.\nFull command: '!expanded:~0,512!'"
				for /f "delims=" %%i in ("!temp.id:~0,127!") do (
					set windows=!windows: "%%~i"=! "%%~i"
					for %%a in (X Y W H title) do if not defined win[!temp.id!]%%a (
						call :haltScripts %%p "Missing window property" "Property not specified: %%a\nFull command: '!expanded!'"
					)
					set "win.focused=%%~i"
					set /a "win[%%~i]X=win[%%~i]X", "win[%%~i]Y=win[%%~i]Y", "win[%%~i]W=win[%%~i]W", "win[%%~i]H=win[%%~i]H", "iobuffers+=1"
					echo(¤CW	%%~i	!win[%%~i]X:~0,3!	!win[%%~i]Y:~0,3!	!win[%%~i]W:~0,3!	!win[%%~i]H:~0,3!	!win[%%~i]title:~0,255!	!win[%%~i]theme!
				)
				set temp.id=
				set temp.args=
				
			) else if "!expanded:~0,4!"=="exit" (
				set sst.processes=!sst.processes: %%p=!
			) else if defined pid[%%p]l[!pid[%%~p]cl!] call :haltScripts %%p "Unknown/Invalid command" "Full command: '!expanded!'" command.unknown
		)
		set /a "pid[%%~p]cl+=1"
	)
	
	if "!$sec:~1!" equ "" set "$sec=0!$sec!"
	if !sendtimer! gtr 1 (
		set sendtimer=-!iobuffers!0
		echo(¤SPEED	!tps!	!deltaTime!	!$min!:!$sec!
	) else set /a sendtimer+=DeltaTime
)
:reload

:injectDLLs
cd "!sst.dir!"
set "noResize=1"
if not exist core\getInput64.dll call :halt "%~nx0:injectDLLs" "Missing File: core\getInput64.dll"
rundll32.exe core\getInput64.dll,inject|| call :halt "%~nx0:injectDLLs" "Failed to inject getInput64.dll\nErrorlevel: !errorlevel!"
if not defined getInputInitialized call :halt "%~nx0:injectDLLs" "Failed to inject getInput64.dll: Unknown error.\nErrorlevel: %errorlevel%"
exit /b
:haltScripts
set "halt.text=%~3"
set "halt.text=!halt.text:	= !"
set halt.text=!halt.text:\n=","!
set "halt.tracemsg= At process PID=%~1, NAME='!pid[%~1]!' Line !pid[%~1]cl!: %~2 "
<nul set /p "=%\e%[9;1H"
set pid[
goto halt.ready
:halt
set "halt.text=%~2"
set halt.text=!halt.text:\n=","!
set "halt.tracemsg= At %~1: "
:halt.ready
set "halt.pausemsg= The system cannot exit automatically. "
for /f "tokens=2 delims=:" %%a in ('mode con') do (
	set /a counter+=1
	set "token=%%~a"
	if "!counter!"=="2" set /a "halt.modeW=!token: =!-7"
)
for /l %%a in (!halt.modeW! -1 0) do (
	<nul set /p "=%\e%[2;3H%\e%[48;2;0;127;255m%\e%[38;2;255;255;255m%\e%[?25l Execution halted %\e%[4;3H!halt.tracemsg:~%%a!"
	for /l %%. in (0 1 10000) do rem
	for %%b in ("!halt.text!") do (
		set "halt.line=%%~b "
		<nul set /p "=%\e%[E%\e%[3G     !halt.line:~%%a,%halt.modeW%!%\e%7"
	)
	<nul set /p "=%\e%[999;3H%\e%[A!halt.pausemsg:~%%a!%\e%[4;1H"
)>con
for /l %%. in () do (
	echo(%\e%[H>con
	pause>nul
)
exit
:memoryDump
pushd "!sst.dir!\temp" || exit /b !errorlevel!
set > memoryDump
for %%A in (memoryDump) do (
	popd
	exit /b %%~zA
)
exit /b %errorlevel%