@echo off
setlocal enabledelayedexpansion
if not defined \e for /f %%a in ('echo prompt $E^| cmd') do set "\e=%%a"
if not defined sys.dir set "sys.dir=!cd!"
set modeW=
set modeH=
for /f "tokens=2 delims=:" %%a in ('mode con') do (
	set "token=%%~a"
	if not defined modeH (
		set "modeH=!token: =!"
	) else if not defined modeW set "modeW=!token: =!"
)

for /f "delims=" %%a in ('dir /b /a:-D "!sys.dir!\resourcepacks\init\themes\*"') do (
	set "theme[%%~a]= "
	for /f "usebackq tokens=1* delims==" %%x in ("!sys.dir!\resourcepacks\init\themes\%%~a") do (
		if /I "%%~x" neq "CBUIOffset" set theme[%%a]=!theme[%%a]! "%%~x=%%~y"
	)
	set "theme[%%~a]=!theme[%%~a]:~2!"
)

set theme[disable_aero]="aero="
for %%a in (
	"ssvm"
	"temp"
	"pid"
) do for /f "tokens=1 delims==" %%b in ('set %%a 2^>nul') do set "%%b="

goto skipThemes
rem == Test theme ==

for %%a in (
	!theme[lo-fi]!
) do set "dwm.%%~a"
if defined dwm.aero (
	set "dwm.scene=%\e%[H"
	set /a temp=modeH-1
	for /l %%x in (1 1 !temp!) do (
		set /a "x=%%x", "!dwm.aero:×=*!"
		set dwm.scene=!dwm.scene!%\e%[48;2;!r!;!g!;!b!m%\e%[2K%\e%[B
	)
	set temp=
)

:skipThemes
set "dwm.barbuffer=                                                                                                                                                                                                                                                                "
set "dwm.bottombuffer=▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄"
set mainbuffer=!dwm.scene!
set "win.order= "
set win.focused=
for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000),t2=t1", "dwm.mouseXpos=modeW/2, dwm.mouseYpos=modeH/2"
call :reload
set dub=
for /l %%. in () do (
	set input=
	if defined io.input (
		set "input=!io.input!"
	) else set /p input=
	for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000)", "deltaTime=(t1 - t2), timer.100cs+=deltaTime, t2=t1, fpsFrames+=1", "doubletimer=!dub! timer.100cs"
	
	if !timer.100cs! GEQ 100 (
		set /a "timer.100cs-=100,fps=fpsFrames,fpsFrames=0"
		if !timer.100cs! GEQ 100 set timer.100cs=0
		if "!dub!"=="100 -" (
			set dub=
		) else set "dub=100 -"
	)
	
	if "!input:~0,1!"=="¤" for /f "tokens=1-8* delims=	" %%0 in ("!input:~1!") do (
		if "%%~0"=="SPEED" (
			title Shivtanium %sys.tag% %sys.ver% %sys.subvinfo% Time: %%3 Exec/p: %%1 TickTime: %%2cs FPS: !fps! Frametime: !deltaTime!
			if "%%~4;%%~5" neq "!dwm.mouseXpos!;!dwm.mouseYpos!" (
				if !random:~-1! == 1 set "mainbuffer=!dwm.scene!"
				set "dwm.mouseXpos=%%~4"
				set "dwm.mouseYpos=%%~5"
			)
			set "extbuffer=!extbuffer!%\e%[48;2;!doubletimer!;!doubletimer!;!doubletimer!m%\e%[!dwm.mouseYpos!;!dwm.mouseXpos!H "
		) else if "%%~0"=="MW" (
			set "args=!input:~4!"
			set "args=!args:	=" "!"
			set "olddim=!win[%%~1]X!;!win[%%~1]Y!;!win[%%~1]W!;!win[%%~1]H!"
			for %%a in ("!args!") do (
				set "temp=%%~a"
				for /f "tokens=1,2* delims==" %%w in ("!win[%%~1]W!=!temp!") do (
					set "temp.x=%%~x"
					set "temp.text=%%~y"
					if "!temp.x:~0,1!"=="l" (
						set /a "temp.x=!temp.x:~1!+1"
						set "win[%%~1]l!temp.x!=%\e%[C%\e%[38;!win[%%~1]FGcolor!m!temp.text!"
					) else if "!temp.x:~0,1!"=="o" (
						set /a "temp.x=!temp.x:~1!+1"
						set "win[%%~1]o!temp.x!=%\e%[38;!win[%%~1]TTcolor!;48;!win[%%~1]TIcolor!m!temp.text!"
					) else set "win[%%~1]%%~x=%%~y"
				)
			)
			set temp.x=
			if !win[%%~1]X! lss 1 set "win[%%~1]X=1"
			if !win[%%~1]Y! lss 1 set "win[%%~1]Y=1"
			if !win[%%~1]W! gtr !modeW! (
				set "win[%%~1]W=!modeW!"
			) else if !win[%%~1]W! lss 12 set "win[%%~1]W=12"
			if !win[%%~1]H! lss 3 set "win[%%~1]H=3"
			set mainbuffer=!mainbuffer!%\e%[H
			if "!olddim!" neq "!win[%%~1]X!;!win[%%~1]Y!;!win[%%~1]W!;!win[%%~1]H!" set mainbuffer=!dwm.scene!
		) else if "%%~0"=="OV" (
			set "overlay=%%~1"
			set "extbuffer=!extbuffer!%\e%[H"
		) else if "%%~0"=="CW" (
			set /a "win[%%~1]X=%%~2", "win[%%~1]Y=%%~3", "win[%%~1]W=%%~4", "win[%%~1]H=%%~5"
			if !win[%%~1]W! lss 10 set "win[%%~1]W=10"
			set /a "win[%%~1]BX=!win[%%~1]X!+!win[%%~1]W!-1", "win[%%~1]BY=!win[%%~1]Y!+!win[%%~1]H!-1", "temp.tl=0"
			set "win[%%~1]title= %%~6"
			set "win[%%~1]theme=%%~7"
			
			set "win[%%~1]FGcolor=!dwm.FGcolor!"
			set "win[%%~1]BGcolor=!dwm.BGcolor!"
			set "win[%%~1]TTcolor=!dwm.TTcolor!"
			set "win[%%~1]TIcolor=!dwm.TIcolor!"
			set "win[%%~1]NTcolor=!dwm.TTcolor!"
			set "win[%%~1]NIcolor=!dwm.TIcolor!"
			set "win[%%~1]CBUI=!dwm.CBUI!"
			set "win[%%~1]aero=!dwm.aero!"
			
			for %%a in (!win[%%~1]theme!) do (
				for %%b in (!theme[%%~a]!) do (
					set "win[%%~1]%%~b"
				)
			)
			set "win[%%~1]scene="
			set temp=
			set "win.order=!win.order: "%%~1" = ! "%%~1" "
			for /l %%d in (9,-1,0) do (
				set /a "temp.tl|=1<<%%d"
				for %%e in (!temp.tl!) do if "!win[%%~1]title:~%%e,1!" equ "" set /a "temp.tl&=~1<<%%d"
			)
			set /a "temp.tl+=1", "temp.bl=!win[%%~1]W!-9", "temp.H=!win[%%~1]H!-1"
			for /f "tokens=1-3 delims=;" %%a in ("!temp.tl!;!temp.bl!") do (
				set "temp.tlb=!dwm.barbuffer:~0,%%~b!"
				set "win[%%~1]p1=%\e%[48;!win[%%~1]TIcolor!m%\e%[38;!win[%%~1]TTcolor!m!win[%%~1]title:~0,%%~b!!temp.tlb:~-%%~b,-%%~a!!win[%%~1]CBUI!"
				
				if "!win[%%~1]aero!" neq "" (
					for /l %%y in (2 1 !temp.H!) do (
						set /a "x=(%%y+!win[%%~1]Y!-1)", "!win[%%~1]aero:×=*!"
						set "win[%%~1]p%%y=%\e%[48;2;!r!;!g!;!b!;38;!win[%%~1]TIcolor!m%dwm.char.L%%\e%[%%~bX%\e%[%%~bC       %dwm.char.R%"
					)
					set "win[%%~1]p!win[%%~1]H!=%\e%[48;2;!r!;!g!;!b!;38;!win[%%~1]TIcolor!m%dwm.char.S%!dwm.bottombuffer:~0,%%~b!%dwm.bottombuffer:~0,7%%dwm.char.S%"
					set r=
					set g=
					set b=
				) else (
					for /l %%y in (2 1 !temp.H!) do (
						set "win[%%~1]p%%y=%\e%[48;!win[%%~1]BGcolor!;38;!win[%%~1]TIcolor!m%dwm.char.L%!dwm.barbuffer:~0,%%~b!       %dwm.char.R%"
					)
					set "win[%%~1]p!win[%%~1]H!=%\e%[48;!win[%%~1]BGcolor!;38;!win[%%~1]TIcolor!m%dwm.char.S%!dwm.bottombuffer:~0,%%~b!%dwm.bottombuffer:~0,7%%dwm.char.S%"
				)
			)
			set temp.H=
			set temp.tl=
			set temp.tlb=
			set "mainbuffer=!mainbuffer!%\e%[H"
		) else if "%%~0"=="FOCUS" (
			set win.order=!win.order: "%%~1"=! "%%~1"
			set "mainbuffer=!mainbuffer!%\e%[H"
		) else if "%%~0"=="DW" (
			for /f "tokens=1 delims==" %%a in ('set win[%%~1] 2^>nul') do set "%%a="
			set "win.order=!win.order: "%%~1" = !"
			set "mainbuffer=!dwm.scene!"
		) else if "%%~0"=="CTRL" (
			set "mainbuffer=!mainbuffer!%\e%[H"
			if "%%~1"=="MINIMIZE" (
				set "mainbuffer=!dwm.scene!"
				set "win.order=!win.order: "%%~2" = !"
			) else if "%%~1"=="RESTORE" (
				if "!win[%%~2]X!" neq "" set "win.order=!win.order: "%%~2" = !"%%~2" "
			) else if "%%~1"=="ORDER" set "win.order= %%~2 "
		) else if "%%~0"=="DUMP" (
			if "%%~1"=="WIN" (
				set win%%~2 >&3
			) else if "%%~1"=="ORDER" (
				set win.order >&3
			) else if "%%~1"=="MODE" (
				set mode >&3
			) else if "%%~1"=="LOAD" (
				for /f "usebackq tokens=1* delims==" %%x in ("%%~2") do set "%%x=%%y"
			) else if "%%~1"=="BSOD" (
				call :bsod "%%~1" "%%~2"
			)
		) else if "%%~0"=="EXIT" exit 0

		if defined mainbuffer (
			for %%w in (!win.order!) do (
				set "mainbuffer=!mainbuffer!%\e%[!win[%%~w]Y!;!win[%%~w]X!H!win[%%~w]p1!"
				for /l %%l in (2 1 !win[%%~w]H!) do (
					set "mainbuffer=!mainbuffer!%\e%[B%\e%[!win[%%~w]X!G%\e%7!win[%%~w]p%%l!%\e%8!win[%%~w]l%%l!%\e%8!win[%%~w]o%%l!"
				)
			)
			<nul set /p "=!mainbuffer!!overlay!!extbuffer!"
		) else if defined extbuffer (
			<nul set /p "=!overlay!!extbuffer!"
		)
		set mainbuffer=
		set extbuffer=
	)
)
:reload

:injectDLLs
exit /b
cd "!sst.dir!"
set /a "noResize=1", "getinput_tps=200"
if not exist core\getInput64.dll call :halt "%~nx0:injectDLLs" "Missing File: core\getInput64.dll"
rundll32.exe core\getInput64.dll,inject|| call :halt "%~nx0:injectDLLs" "Failed to inject getInput64.dll\nErrorlevel: !errorlevel!"
if not defined getInputInitialized call :halt "%~nx0:injectDLLs" "Failed to inject getInput64.dll: Unknown error.\nErrorlevel: %errorlevel%"
exit /b
:bsod
setlocal enabledelayedexpansion
for /f "tokens=2 delims=:" %%a in ('mode con') do (
	set /a counter+=1
	set "token=%%~a"
	if "!counter!"=="1" set /a "modeH=!token: =!"
	if "!counter!"=="2" set /a "modeW=!token: =!"
)
set "halt.cause=%~1"
set "halt.message=%~2"
set halt.finalmsg=
set halt.lines=!spr.[bootlogo.spr].H!
set /a "halt.msgW=!spr.[bootlogo.spr].W!-11", "halt.promptX=(!modeW!-24)/2"
if not defined halt.message exit 90
set halt.message=!halt.message: =" "!
set halt.message=!halt.message:\n=" \n "!
set halt.temp=-1
for %%l in ("!halt.message!") do (
	set halt.templen=0
	set "halt.tempmsg=#%%~l"
	for /l %%y in (9,-1,0) do (
		set /a "halt.templen|=1<<%%y"
		for %%Y in (!halt.templen!) do if "!halt.tempmsg:~%%Y,1!" equ "" set /a "halt.templen&=~1<<%%y"
	)
	set /a halt.temp+=halt.templen+1
	if "%%~l"=="\n" (
		set halt.temp=10000
		set halt.tempmsg=#
	)
	if !halt.temp! gtr !halt.msgW! (
		set halt.finalmsg=!halt.finalmsg! "   !halt.templine!"
		set halt.templine=
		set /a "halt.lines+=1", "halt.temp-=halt.msgW"
	)
	set "halt.templine=!halt.templine! !halt.tempmsg:~1!"
)
set halt.finalmsg=!halt.finalmsg! "   !halt.templine!"
set /a "halt.posX=!sst.boot.logoX!", "halt.posY=(!modeH!-!halt.lines!)/2"

<nul>con set /p "=%\e%[48;2;;;255;38;5;231m%\e%[2J%\e%[!halt.posY!;!halt.posX!H!spr.[bootlogo.spr]!"
for %%a in (!halt.finalmsg!) do (
	<nul>con set /p "=%\e%[B%\e%[!halt.posX!G%%~a"
)
<con>con set /p "=%\e%[2B%\e%[!halt.promptX!G%\e%[7m Press any key to exit. %\e%[27m"

exit %3
