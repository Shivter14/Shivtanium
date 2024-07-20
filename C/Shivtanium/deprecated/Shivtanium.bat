@echo off
setlocal enabledelayedexpansion
set arg=%1
if "!arg:~0,1!"==":" (
	endlocal
	call %*
	exit /b
)
set arg=
if not exist "!sst.dir!\temp\DWM-!sst.localtemp!" (
	echo=This program requires to be run in the Shivtanium OS Kernel with DWM enabled.
	echo=Press any key to exit. . .
	pause < con > nul
)
for %%a in (
	"sst.boot"
	"ssvm"
	"temp"
	"spr"
	"dwm"
) do for /f "tokens=1 delims==" %%b in ('set %%a') do set "%%b="
call :SSTFS.mount "!sstfs.mainfile!" \mnt\init
call :createProcess 0 \mnt\init\init.sst
for /l %%# in (1 1 !ioTotal!) do set /p "="
REM Yeah uhh i just like to save lines :))))))
for /f "delims=" %%a in ('dir /b /a:-D "!sys.dir!\resourcepacks\init\themes\*"') do for /f "usebackq tokens=1* delims==" %%x in ("!sys.dir!\resourcepacks\init\themes\%%~a") do if /I "%%~x" == "CBUIOffset" set "themeCBUI[%%~a]=%%~y"
for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000),t2=t1,sendtimer=0"
set "windows= "
set txtIn.focused=
set txtIn.focused.host=
set win.focused=
set win.moving=
set /a "sst.mouseXpos=sys.modeW*5/2", "sst.mouseYpos=sys.modeH*5", "sys.mouseXpos=sst.mouseXpos/5", "sys.mouseYpos=sst.mouseYpos/10"
set "tabbuffer=	"
goto main
call :main > "!sst.dir!\temp\DWM-!sst.localtemp!"
exit /b
:main
echo=¤SPEED	0	0	0:00	!sys.mouseXpos!	!sys.mouseYpos!
echo=¤OV	%\e%[!sys.modeH!;1H%\e%[48;2;191;0;191;38;2;255;255;255m Shivtanium %\e%[48;2;127;0;127m%\e%[0J
for /l %%- in (.) do (
	for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000)",^
		"deltaTime=(t1 - t2)", "$TT+=deltaTime", "timer.100cs+=deltaTime", "$sec=$TT / 100 %% 60", "$min=$TT / 100 / 60 %% 60", "tpsTicks+=1", "t2=t1", "tt=t1 %% 4"
	if !timer.100cs! GEQ 100 (
		set /a "timer.100cs-=100,tps=tpsTicks,tpsTicks=0"
		if !timer.100cs! GEQ 100 set timer.100cs=0
	)
	set iobuffers=0
	for %%p in (!sst.processes.paused!) do if defined pid[%%p].timeout (
		set /a "pid[%%p].timeout-=deltaTime"
		if !pid[%%~p].timeout! leq 0 (
			set "sst.processes.paused=!sst.processes.paused: %%p = !"
			set "sst.processes=!sst.processes!%%p "
		)
	)
	set kernelOut=
	set "sys.keysRN= "
	set /p kernelOut=
	if defined kernelOut (
		if "!kernelOut:~0,5!"=="mouse" (
			set "sys.!kernelOut!" > nul 2>&1
		) else if "!kernelOut:~0,12!"=="keysPressed=" (
			set "sys.keys=!kernelOut:~12!"
		) else if "!kernelOut:~0,14!"=="keysPressedRN=" (
			set "sys.keysRN=!kernelOut:~14!"
		) else if "!kernelOut:~0,6!"=="click=" (
			set "sst.!kernelOut!"
		) else if "!kernelOut!"=="exit" exit 0
	)
	if "!sys.keys!" neq " " (if defined txtIn.focused for /f "tokens=1,2* delims=." %%p in ("!txtIn.focused!") do (
		for %%k in (!sys.keysRN!) do (
			set "char=!charset_L:~%%k,1!"
			if "!sys.keys!" neq "!sys.keys:-16-=!" set "char=!charset_U:~%%k,1!"
			if "!sys.keys!" neq "!sys.keys:-17-=!" set "char=!charset_A:~%%k,1!"
			if "!char!"==" " (
				if "%%~k" neq "32" set char=
				if "%%~k"=="8" (
					if "!pid[%%~p]v%%~r!" neq "" set "pid[%%~p]v%%~r=!pid[%%~p]v%%~r:~0,-1!"
				)
			)
			set "pid[%%~p]v%%~r=!pid[%%~p]v%%~r!!char!"

			for /l %%y in (1 1 !win[%%~p.%%~q]H!) do set "win[%%~p.%%~q]o%%y="
			for %%b in (!win[%%~p.%%~q]buttons!) do for /f "delims=" %%y in ("!win[%%~p.%%~q]btn[%%~b]WY!") do (
				set "win[%%~p.%%~q]o%%y=!win[%%~p.%%~q]o%%y!%\e%[!win[%%~p.%%~0]btn[%%~b]WX!C!win[%%~p.%%~q]btn[%%~b]#:~0,%%~4!"
				echo=¤MW	%%~p.%%~q	o%%y=!win[%%~p.%%~q]o%%y!
			)
			for /f "tokens=1* delims=;" %%y in ("!win[%%~p.%%~q]txt[%%~r]Y!;!win[%%~p.%%~q]txt[%%~r]W!") do (
				set "temp= !pid[%%~p]v%%~r!"
				set "win[%%~p.%%~q]o%%y=!win[%%~p.%%~q]o%%y!%\e%8%\e%[!win[%%~p.%%~q]txt[%%~r]X!C%\e%[%%~zX!temp:~-%%~z!"
				set temp=
				echo=¤MW	%%~p.%%~q	o%%y=!win[%%~p.%%~q]o%%y!
			)
		)

		if "!sys.keysRN!" neq "!sys.keysRN: 13 =!" (
			set "pid[%%~p]vEvent=textReturn %%q"
			if /I "!pid[%%~p]vResumeOnReturn!"=="True" (
				set "sst.processes.paused=!sst.processes.paused: %%p = !"
				set "sst.processes=!sst.processes: %%p = !%%p "
			)
		)
	)) else set keysPressedOld=
	
	if "!sst.click!"=="1" (
		if "!sys.click!"=="0" (
			set sys.click=1
			set win.focused=
			for %%w in (!windows!) do if not defined win.focused (
				if !sys.mouseXpos! geq !win[%%~w]X! if !sys.mouseXpos! leq !win[%%~w]BX! if !sys.mouseYpos! geq !win[%%~w]Y! if !sys.mouseYpos! leq !win[%%~w]BY! (
					set /a iobuffers+=1
					echo=¤FOCUS	%%~w
					set "windows= "%%~w"!windows: "%%~w" = !"
					set "win.focused=%%~w"
					if "!sys.mouseYpos!"=="!win[%%~w]Y!" (
						set "win.moving=%%~w"
						set /a "win.moving.offset=sys.mouseXpos-!win[%%~w]X!"
					)
				)
			)
			if defined win.focused for /f "delims=" %%w in ("!win.focused!") do for %%b in (!win[%%~w]buttons!) do (
				if "!sys.mouseYpos!"=="!win[%%~w]btn[%%~b]Y!" if !sys.mouseXpos! geq !win[%%~w]btn[%%~b]X! if !sys.mouseXpos! leq !win[%%~w]btn[%%~b]B! (
					for /f "tokens=1* delims=." %%p in ("%%~w") do if "!sst.processes.paused!" neq "!sst.processes.paused: %%p = !" (
						if /I "!pid[%%~p]vResumeOnButtonClick[%%~q.%%~b]!"=="True" (
							set "sst.processes.paused=!sst.processes.paused: %%p = !"
							set "sst.processes=!sst.processes: %%p = !%%p "
						) else (
							call :copyProcess "%%~p" "!pid[%%~p]!" "!win[%%~w]btn[%%~b]!" || call :haltScripts %%p "Failed to launch button scripts" "%%~p\n!pid[%%~p]!\n!win[%%~w]btn[%%~b]!"
							set "pid[!temp.pid!]P="
							set temp.pid=
						)
					)
				)
			)
		) else (
			set /a sys.click+=deltaTime
			if defined win.moving (
				if !sys.mouseYpos! lss 1 set sys.mouseYpos=1
				set /a "temp.X=(leq=((1-(sys.mouseXpos-win.moving.offset))>>31)+1)  +  (geq=(((sys.mouseXpos-win.moving.offset)-(sys.modeW-win[!win.moving!]W+1))>>31)+1)*(sys.modeW-win[!win.moving!]W+1)  +  ^!(leq+geq)*(sys.mouseXpos-win.moving.offset)"
				if !temp.X! lss 1 set temp.X=1
				if "!temp.oX!;!temp.oY!" neq "!temp.X!;!sys.mouseYpos!" (
					set /a "win[!win.moving!]BX=temp.X+win[!win.moving!]W-1", "win[!win.moving!]BY=sys.mouseYpos+win[!win.moving!]H-1", iobuffers+=1
					set "win[!win.moving!]X=!temp.X!"
					set "win[!win.moving!]Y=!sys.mouseYpos!"
					for /f "delims=" %%0 in ("!win.moving!") do for %%1 in (!win[%%~0]buttons!) do (
						set /a "win[%%~0]btn[%%~1]X=win[%%~0]X+win[%%~0]btn[%%~1]WX", "win[%%~0]btn[%%~1]B=win[%%~0]btn[%%~1]X+win[%%~0]btn[%%~1]W-1", "win[%%~0]btn[%%~1]Y=win[%%~0]Y+win[%%~0]btn[%%~1]WY"
					)
					echo(¤MW	!win.moving!	X=!temp.X!	Y=!sys.mouseYpos!
					set temp.oX=!temp.X!
					set temp.oY=!sys.mouseYpos!
				)
				set temp.X=
			)
		)
	) else (
		set sys.click=0
		set win.moving=
		set win.moving.offset=
	)
	for %%p in (!sst.processes!) do (
		for /f "tokens=1,2 delims=;" %%n in ("!pid[%%~p]cl!;!pid[%%~p]cb!") do if "!pid[%%~p]l[%%~n]:~%%~o,1!" neq "	" if "!pid[%%~p]l[%%~n]!" neq "" (
			set "line=!pid[%%~p]l[%%~n]:^*=\s!$"
			set line=!line:$=" "$" "!
			set whitespace=
			set expanded=
			for %%x in ("!line:~%%~o,-1!") do (
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
				set "temp.timeout=!expanded:~5!"
				if "!expanded:~5!" neq "forTrigger" (
					set /a "pid[%%~p].timeout=temp.timeout" 2>nul
					if "!pid[%%~p].timeout!"=="0" if "!temp.timeout!" neq "0" call :haltScripts %%p "Invalid Syntax for command 'wait'" "Expected: wait <number>\nFull command: !expanded:	= !" wait.syntax_error
				)
				set "sst.processes=!sst.processes: %%p = !"
				set "sst.processes.paused=!sst.processes.paused!%%p "
				set temp.timeout=
			) else if "!expanded:~0,3!"=="if	" (
				set temp.IFSM=
				set temp.IFA=1
				set "compare=!expanded:~3!"
				if "!expanded:~3,3!"=="/I	" (
					set temp.IFSM=/I
					set "compare=!expanded:~6!"
				)
				if "!expanded:~3,4!"=="not	" (
					set temp.IFA=-1
					set "compare=!expanded:~7!"
				)
				set temp.pass=-1
				for /f "tokens=1,2* delims=	" %%1 in ("!compare!") do (
					if "%%~2" == "==" (
						if "%%~1"=="%%~3" set temp.pass=1
					) else if "%%~2" == "x=" (
						if "%%~1" neq "%%~3" set temp.pass=1
					) else if "%%~2" == ">=" (
						set "val1=%%~1"
						set "val2=%%~3"
						set /a "val1=val1", "val2=val2"
						if !val1! geq !val2! set temp.pass=1
						set val1=
						set val2=
					) else if "%%~2" == "<=" (
						set "val1=%%~1"
						set "val2=%%~3"
						set /a "val1=val1", "val2=val2"
						if !val1! leq !val2! set temp.pass=1
						set val1=
						set val2=
					) else if "%%~2" == ">" (
						set "val1=%%~1"
						set "val2=%%~3"
						set /a "val1=val1", "val2=val2"
						if !val1! gtr !val2! set temp.pass=1
						set val1=
						set val2=
					) else if "%%~2" == "<" (
						set "val1=%%~1"
						set "val2=%%~3"
						set /a "val1=val1", "val2=val2"
						if !val1! lss !val2! set temp.pass=1
						set val1=
						set val2=
					) else if "%%~2" == "=" (
						if /I "%%~1"=="%%~3" set temp.pass=1
					) else call :haltScripts %%p "Invalid Syntax for command 'if'" "'%%~2' was unexpected at the time.\nFull command: !expanded!" if.syntax_error
				)
				set /a temp.pass*=temp.IFA
				
				if "!temp.pass!"=="1" (
					set "tabbuffer=!tabbuffer!	"
					set /a "pid[%%~p]cb+=1"
				)
				
				set temp.IFSM=
				set temp.IFA=
				set compare=
				set temp.pass=
			) else if "!expanded:~0,13!"=="modifyWindow	" (
				set temp.args=!expanded:	=" "!
				set temp.exec=True
				for %%a in ("!temp.args!") do if not defined temp.args (
					set "temp=%%~a"
					if defined temp.id (
						set "win[!temp.id!]%%~a" >nul 2>nul
						if /I "!temp:~0,2!"=="X=" (
							set math="win[!temp.id!]X=win[!temp.id!]X", "win[!temp.id!]BX=win[!temp.id!]X+win[!temp.id!]W-1"
							for /f "delims=" %%0 in ("!temp.id!") do for %%1 in (!win[%%~0]buttons!) do (
								set math=!math!, "win[%%~0]btn[%%~1]X=win[%%~0]X+win[%%~0]btn[%%~1]WX", "win[%%~0]btn[%%~1]B=win[%%~0]btn[%%~1]X+win[%%~0]btn[%%~1]W-1"
								if "!math:~7000,1!" neq "" (
									set /a !math!
									set math=
								)
							)
							set /a !math!
							set math=
						) else if /I "!temp:~0,2!"=="Y=" (
							set math="win[!temp.id!]Y=win[!temp.id!]Y", "win[!temp.id!]BY=win[!temp.id!]Y+win[!temp.id!]H-1"
							for /f "delims=" %%0 in ("!temp.id!") do for %%1 in (!win[%%~0]buttons!) do (
								set math=!math!, "win[%%~0]btn[%%~1]Y=win[%%~0]Y+win[%%~0]btn[%%~1]WY"
								if "!math:~7000,1!" neq "" (
									set /a !math!
									set math=
								)
							)
							set /a !math!
							set math=
						)
					) else (
						set "temp.id=#%%~p.%%~a"
						for %%c in (a b c d e f g h i j k l m n o p q r s t u v w x y z _ . 1 2 3 4 5 6 7 8 9 0) do set "temp.id=!temp.id:%%c=!"
						if "!temp.id!" neq "#" (
							call :haltScripts %%p "Whitespace error" "Invalid window ID: '%%~a'\nInvalid characters: '!temp.id!'" command.whitespace
						) else set "temp.id=%%~p.%%~a"
						if "!win[%%~p.%%~a]!"=="" set temp.exec=
					)
					set temp=
				) else set temp.args=
				if defined temp.exec (
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
				) else (
					set "sst.processes=!sst.processes: %%p = !"
					set /a sst.proccount-=1
					if "!pid[%%~p]P!" neq "" for /f "delims=" %%a in ("!pid[%%~p]P!") do (
						set "sst.processes=!sst.processes: %%a = !%%a "
						set "sst.processes.paused=!sst.processes.paused: %%a = !"
						set "pid[%%~a]vreturn0=CLOSED"
					)
					for /f "tokens=1 delims==" %%v in ('set "pid[%%~p]"') do set "%%v="
				)
				set temp.exec=
			) else if "!expanded:~0,10!"=="setButton	" (
				for /f "tokens=1-6* delims=	" %%0 in ("!expanded:~10!") do (
					if "!win[%%~p.%%~0]!"=="" call :haltScripts %%p "Attempt to modify non-existent window" "Window ID: '%%~0'\nAction: 'setButton'"
					set "temp.id=#%%~1"
					for %%c in (a b c d e f g h i j k l m n o p q r s t u v w x y z _ . 1 2 3 4 5 6 7 8 9 0) do set "temp.id=!temp.id:%%c=!"
					if "!temp.id!" neq "#" call :haltScripts %%p "Whitespace error" "Invalid button ID: '%%~1'\nInvalid characters: '!temp.id!'" command.whitespace
					set "win[%%~p.%%~0]btn[%%~1]=%%~6"
					if "!win[%%~p.%%~0]btn[%%~1]:~0,1!" neq ":" call :haltScripts %%p "Invalid label" "Expected: ':label'\nRecieved: %%~6\nFull command: !expanded!"
					for /f "tokens=1 delims=	" %%a in ("!win[%%~p.%%~0]btn[%%~1]:~1!") do (
						if "!pid[%%~p]#%%a!"=="" call :haltScripts %%p "Invalid label" "Label not found: '%%~a'"
						set "win[%%~p.%%~0]btn[%%~1]=%%~a"
					)
					set "win[%%~p.%%~0]btn[%%~1]#= %%~5 "
					set "win[%%~p.%%~0]btn[%%~1]WX=%%~2"
					set "win[%%~p.%%~0]btn[%%~1]WY=%%~3"
					set "win[%%~p.%%~0]btn[%%~1]W=%%~4"
					set /a "win[%%~p.%%~0]btn[%%~1]WX=win[%%~p.%%~0]btn[%%~1]WX+1", "win[%%~p.%%~0]btn[%%~1]WY=win[%%~p.%%~0]btn[%%~1]WY", "win[%%~p.%%~0]btn[%%~1]W=win[%%~p.%%~0]btn[%%~1]W",^
					       "win[%%~p.%%~0]btn[%%~1]X=win[%%~p.%%~0]X+win[%%~p.%%~0]btn[%%~1]WX", "win[%%~p.%%~0]btn[%%~1]Y=win[%%~p.%%~0]Y+win[%%~p.%%~0]btn[%%~1]WY",^
						   "win[%%~p.%%~0]btn[%%~1]B=win[%%~p.%%~0]btn[%%~1]X+win[%%~p.%%~0]btn[%%~1]W-1", "iobuffers+=1"
					set win[%%~p.%%~0]buttons=!win[%%~p.%%~0]buttons! "%%~1"
					for /l %%y in (1 1 !win[%%~p.%%~0]H!) do set "win[%%~p.%%~0]o%%y="
					for %%b in (!win[%%~p.%%~0]buttons!) do for /f "delims=" %%y in ("!win[%%~p.%%~0]btn[%%~b]WY!") do (
						set "win[%%~p.%%~0]o%%y=!win[%%~p.%%~0]o%%y!%\e%8%\e%[!win[%%~p.%%~0]btn[%%~b]WX!C!win[%%~p.%%~0]btn[%%~b]#:~0,%%~4!"
						echo=¤MW	%%~p.%%~0	o%%y=!win[%%~p.%%~0]o%%y!
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
				for /f "delims=;" %%i in ("!temp.id:~0,127!") do (
					set "windows= "%%~i"!windows!"
					set "pid[%%~p]windows=!pid[%%~p]windows!"%%~i" "
					for %%a in (X Y W H title) do if not defined win[!temp.id!]%%a (
						call :haltScripts %%p "Missing window property" "Property not specified: %%a\nFull command: '!expanded!'"
					)
					set "win.focused=%%~i"
					set "win[%%~i]CBUI=0"
					for %%a in (!win[%%~i]theme!) do (
						set "win[%%~i]CBUI=!themeCBUI[%%~a]!"
					)
					set /a "win[%%~i]X=win[%%~i]X", "win[%%~i]Y=win[%%~i]Y", "win[%%~i]W=win[%%~i]W", "win[%%~i]H=win[%%~i]H", "win[%%~i]BX=win[%%~i]X+win[%%~i]W-1", "win[%%~i]BY=win[%%~i]Y+win[%%~i]H-1", "iobuffers+=1"
					if !win[%%~i]BX! gtr !sys.modeW! set /a "win[%%~i]X=sys.modeW-win[%%~i]W+1", "win[%%~i]BX=sys.modeW"
					echo(¤CW	%%~i	!win[%%~i]X:~0,3!	!win[%%~i]Y:~0,3!	!win[%%~i]W:~0,3!	!win[%%~i]H:~0,3!	!win[%%~i]title:~0,255!	!win[%%~i]theme!
				)
				set temp.id=
				set temp.args=
			) else if "!expanded:~0,5!"=="call	" (
				for /f "tokens=1* delims=	" %%0 in ("!expanded:~5!") do if "!expanded:~5,1!" neq ":" (
					set "temp.path=%%~0"
					if "!temp.path:~0,2!" == ".\" for /f %%P in ("!pid[%%~p]!") do set "temp.path=%%~pP!temp.path:~2!"
					if "!temp.path:~0,5!" == "\bin\" (
						set "temp.ic=!temp.path:~5!"
						call "%~dp0core\ic-!temp.ic:..=.!.bat" %%p	"%%~1"
						set "pid[%%~p]vreturn0=!errorlevel!"
						set temp.ic=
					) else (
						call :createProcess "%%~p" "!temp.path!"
						if "!errorlevel!" neq "1" (
							set "pid[!errorlevel!]P=%%~p"
							set "sst.processes=!sst.processes: %%p = !"
							set "sst.processes.paused=!sst.processes.paused!%%p "
						)
					)
					set temp.path=
				) else (
					call :copyProcess "%%~p" "!pid[%%~p]!" "%%~1" "%%~2" || call :haltScripts %%p "Invalid function call" "Label not found: %%~1"
					set "sst.processes=!sst.processes: %%p = !"
					set "sst.processes.paused=!sst.processes.paused!%%p "
				)
			) else if "!expanded:~0,4!"=="exit" (
				set /a sst.proccount-=1
				set "sst.processes=!sst.processes: %%p = !"
				if "!pid[%%~p]P!" neq "" for /f "delims=" %%a in ("!pid[%%~p]P!") do if "!sst.processes.paused: %%a = !" neq "!sst.processes.paused!" (
					set "sst.processes=!sst.processes: %%a = !%%a "
					set "sst.processes.paused=!sst.processes.paused: %%a = !"
				)
				for %%a in (!pid[%%~p]windows!) do (
					set "windows=!windows: %%a = !"
					set /a iobuffers+=1
					echo(¤DW	%%a
				)
				for /f "tokens=1 delims==" %%v in ('set "pid[%%~p]"') do set "%%v="
				for /f "tokens=1 delims==" %%v in ('set "win[%%~p." 2^>nul') do set "%%v="
			) else (
				set temp=
				if "!pid[%%~p]cb!" neq "0" if "!line:~0,%%~o!" neq "!tabbuffer:~0,%%~o!" (
					set "tabbuffer=!tabbuffer:~0,-1!"
					set /a "pid[%%~p]cl-=1", "pid[%%~p]cb-=1"
					set temp=True
				)
				if not defined temp if "!expanded:~0,6!" neq "nocap	" call :killScripts %%p "Unknown/Invalid command" "Full command: '!expanded!'" command.unknown
				set temp=
			)
		)
		if "!pid[%%~p]cl!" neq "" set /a "pid[%%~p]cl+=1"
	)
	
	if "!$sec:~1!" equ "" set "$sec=0!$sec!"
	if !sendtimer! gtr 1 (
		set sendtimer=-!iobuffers!
		echo(¤SPEED	!tps!	!deltaTime!	!$min!:!$sec!	!sys.mouseXpos!	!sys.mouseYpos!
	) else set /a sendtimer+=DeltaTime
)
:copyProcess
set temp.pid=!random!
if defined pid[!temp.pid!] goto copyProcess
if "!pid[%~1]#%~3!"=="" call :halt "Invalid label: %~3"
set "pid[!temp.pid!]=%~2"
set "pid[!temp.pid!]C=%~1"
set "pid[!temp.pid!]P=%~1"
set "pid[!temp.pid!]ss=!pid[%~1]ss!"
set "pid[!temp.pid!]cb=0"
for /f "tokens=1* delims=]" %%a in ('set "pid[%~1]l" 2^>nul ^&^& set "pid[%~1]#" 2^>nul') do set "pid[!temp.pid!]%%b"
set "pid[!temp.pid!]cl=!pid[%~1]#%~3!"
set "sst.processes=!sst.processes!!temp.pid! "
set /a sst.proccount+=1
exit /b 0
:createProcess
set temp.pid=!random!
if defined pid[!temp.pid!] goto createProcess
REM Todo: This gets slower the more processes are running.
set "pid[!temp.pid!]C=%~1"
set "temp.scriptname=%~2"
set "pid[!temp.pid!]cb=0"
set temp.lines=0
if "!sstfs.[%temp.scriptname%]!"=="" (
	set "pid[%~1]vreturn=9009"
	exit /b 1
)
set "pid[!temp.pid!]=!temp.scriptname!"
for /f "eol=# delims=" %%a in ('SSTFS-read.bat "!temp.scriptname!"') do (
	set /a temp.lines+=1
	set "temp.line=%%a"
	if not defined temp.line call :halt "%~nx0:createProcess" "Something went wrong when creating the following process:\nPID: !temp.pid!, EXE: !temp.scriptname!"
	if "!temp.line:~0,1!"==":" (
		set "temp.label=!temp.line!"
		for %%a in (a b c d e f g h i j k l m n o p q r s t u v w x y z _ . 1 2 3 4 5 6 7 8 9 0) do set "temp.label=!temp.label:%%~a=!"
		if "!temp.label!" neq ":" call :halt "%~nx0:createProcess" "At line !temp.lines!: Invalid label name:\n'!temp.line!'\nWhitelisted characters: A-Z, a-z, 0-9, '_', '.'"
		set "pid[!temp.pid!]#!temp.line:~1!=!temp.lines!"
	) else set "pid[!temp.pid!]l[!temp.lines!]=%%a"
)

set "pid[!temp.pid!]cl=1"
set "pid[!temp.pid!]ss=!temp.lines!"
set "sst.processes=!sst.processes!!temp.pid! "
set /a sst.proccount+=1
set temp.scriptname=
set temp.lines=
set temp.line=
set temp.pid=&&exit /b %temp.pid%
:killScripts
set /a sst.proccount-=1
set "sst.processes=!sst.processes: %~1 = !"
if "!pid[%~1]P!" neq "" for /f "delims=" %%a in ("!pid[%~1]P!") do (
	set "sst.processes=!sst.processes: %%a = !%%a"
	set "sst.processes.paused=!sst.processes.paused: %%a = !"
	set "pid[%%~a]vreturn0=KILLED"
)
for %%a in (!pid[%~1]windows!) do (
	set "windows=!windows: %%a = !"
	set /a iobuffers+=1
	echo(¤DW	%%a
)
for /f "tokens=1 delims==" %%v in ('set "pid[%~1]"') do set "%%v="
for /f "tokens=1 delims==" %%v in ('set "win[%~1." 2^>nul') do set "%%v="
exit /b
:haltIC
set "halt.color=;127;"
set "halt.text=  %~3\n%~4"
set "halt.text=!halt.text:	= !"
set "halt.tracemsg= At process PID=%~2, NAME='!pid[%~2]!' Line !pid[%~2]cl!: Command '%~1' failed "
goto halt.ready
:haltScripts
set "halt.color=;127;255"
set "halt.text=    %~3"
set "halt.text=!halt.text:	= !"
set "halt.tracemsg= At process PID=%~1, NAME='!pid[%~1]!' Line !pid[%~1]cl!: %~2 "
goto halt.ready
:halt
set "halt.color=255;;"
set "halt.text=    %~2"
set "halt.tracemsg= At %~1: "
:halt.ready
set "halt.text=!halt.text:\n=","    !"
set "halt.pausemsg= Press any key to exit. . . "
for /f "tokens=2 delims=:" %%a in ('mode con') do (
	set /a counter+=1
	set "token=%%~a"
	if "!counter!"=="2" set /a "halt.modeW=!token: =!-7"
)>nul
for /l %%a in (!halt.modeW! -1 0) do (
	set /p "=%\e%[2;3H%\e%[48;2;!halt.color!m%\e%[38;2;255;255;255m%\e%[?25l Execution halted %\e%[4;3H!halt.tracemsg:~%%a!"
	for /l %%. in (0 1 10000) do rem
	for %%b in ("!halt.text!") do (
		set "halt.line=%%~b "
		set /p "=%\e%[E%\e%[3G !halt.line:~%%a,%halt.modeW%!%\e%7"
	)
	set /p "=%\e%[999;3H%\e%[A!halt.pausemsg:~%%a!%\e%[4;1H"
) <nul>con

pause<con>nul
echo=¤EXIT
>"!sst.dir!\temp\kernelPipe" echo=exitProcess !PID!
exit 0
:memoryDump
pushd "!sst.dir!\temp" || exit /b !errorlevel!
set > memoryDump
for %%A in (memoryDump) do (
	popd
	exit /b %%~zA
)
exit /b %errorlevel%
:SSTFS.mount
set sstfs.tempcounter=0
set sstfs.temp=
set sstfs.fsend=
if not exist "%~1" call :halt "%~nx0:SSTFS.mount" "Filesystem not found: '%~1'"
if "%~2"=="" call :halt "%~nx0:SSTFS.mount" "Path not specified"
cmd /c findstr /N "^!" "%~f1">nul
if not errorlevel 1 call :halt "%~nx0:SSTFS.mount" "Found illegal character: <exclamation mark>"

set "temp.whitelist= %~2"
for %%z in (a b c d e f g h i j k l m n o p q r s t u v w x y z 1 2 3 4 5 6 7 8 9 \ / _ .) do (
	set "temp.whitelist=!temp.whitelist:%%z=!"
)
if "!temp.whitelist!" neq " " call :halt "%~nx0:SSTFS.mount" "Illegal mount destination path: %~2\nIllegal characters:!temp.whitelist!"
set "sstfs.dest=%~2"
set "sstfs.dest=!sstfs.dest:/=\!"

for /f "usebackq tokens=1*" %%a in ("%~f1") do (
	set "command=%%~a"
	set "parameters=%%~b"
	if "!command!"=="@FILE" (
		set error.invalidFileName=
		set "temp.whitelist= !parameters!"
		for %%z in (a b c d e f g h i j k l m n o p q r s t u v w x y z 1 2 3 4 5 6 7 8 9 \ _ .) do (
			set "temp.whitelist=!temp.whitelist:%%z=!"
		)
		if "!temp.whitelist!" neq " " set "error.invalidFileName=!temp.whitelist!"

		if defined error.invalidFileName call :halt "%~nx0:SSTFS.mount" "Error in filesystem: Invalid file name:\n'!parameters!'\nInvalid characters:!error.invalidFileName!"
		set /a "sstfs.[!sstfs.dest!\!parameters!]"=!sstfs.tempcounter!+1
		if defined sstfs.temp set /a "sstfs.[!sstfs.dest!\!sstfs.temp!].end=!sstfs.tempcounter!-1"
		set "sstfs.temp=!parameters!"
		rem call :startup.submsg "Mounting SSTFS File for !sstfs.dest!" "Registered file: !parameters!">> "temp\bootStatus-!sst.localtemp!"
	)
	set /a sstfs.tempcounter+=1
)
if defined sstfs.temp set /a "sstfs.[!sstfs.dest!\!sstfs.temp!].end=!sstfs.tempcounter!-1"
set "sstfs.mnt[!sstfs.dest!]=%~f1"
set sstfs.fsend=
set sstfs.temp=
set sstfs.tempcounter=
set command=
set parameters=
exit /b 0
