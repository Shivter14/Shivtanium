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
set input=
set /p input=

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

set "dwm.barbuffer=                                                                                                                                                                                                                                                                "
set "dwm.bottombuffer=▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄"
set mainbuffer=!dwm.scene!
set "win.order= "
set win.focused=
for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000),t2=t1", "dwm.mouseXpos=modeW/2, dwm.mouseYpos=modeH/2"

for /l %%. in () do (
	for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000)", "deltaTime=(t1 - t2), timer.100cs+=deltaTime, t2=t1, fpsFrames+=1"
	
	if "!input:~0,1!"=="¤" for /f "tokens=1-8* delims=	" %%0 in ("!input:~1!") do (
		if "%%~0"=="SPEED" (
			title Shivtanium %sys.tag% %sys.ver% %sys.subvinfo% Time: %%3 Exec/p: %%1 TickTime: %%2cs FPS: !fps! Frametime: !deltaTime!
		) else if "%%~0"=="MW" (
			set "args=!input:~4!"
			set "args=!args:	=" "!"
			set /a "oldX=win[%%~1]X, oldY=win[%%~1]Y, oldW=win[%%~1]W, oldH=win[%%~1]H, oldBX=oldX+oldW-1, oldBY=oldY+oldH-1"
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
			if "!oldX!;!oldY!;!oldW!;!oldH!" neq "!win[%%~1]X!;!win[%%~1]Y!;!win[%%~1]W!;!win[%%~1]H!" if "!random:~-1!"=="1x" (
				set "mainbuffer=!dwm.scene!"
			) else (
				set /a "win[%%~1]BX=win[%%~1]X+win[%%~1]W, win[%%~1]BY=win[%%~1]Y+win[%%~1]H-1, win[%%~1]DX=win[%%~1]X-oldX, unfY=win[%%~1]Y-1, unfB=win[%%~1]BY+1"
				set "mainbuffer=%\e%[0m%\e%[48;!dwm.sceneBGcolor!m"
				if !win[%%~1]Y! gtr !oldY! for /l %%y in (!unfY! -1 !oldY!) do set "mainbuffer=!mainbuffer!%\e%[%%y;!oldX!H%\e%[48;2;!dwm.aero[%%y]!m%\e%[!oldW!X"
				if !win[%%~1]BY! lss !oldBY! for /l %%y in (!unfB! 1 !oldBY!) do set "mainbuffer=!mainbuffer!%\e%[%%y;!oldX!H%\e%[48;2;!dwm.aero[%%y]!m%\e%[!oldW!X"
				if !win[%%~1]X! gtr !oldX! (
					for /l %%y in (!oldY! 1 !oldBY!) do set "mainbuffer=!mainbuffer!%\e%[%%y;!oldX!H%\e%[48;2;!dwm.aero[%%y]!m%\e%[!win[%%~1]DX!X"
				) else if !win[%%~1]X! lss !oldX! for /l %%y in (!oldY! 1 !oldBY!) do set "mainbuffer=!mainbuffer!%\e%[%%y;!win[%%~1]BX!H%\e%[48;2;!dwm.aero[%%y]!m%\e%[!win[%%~1]DX:~1!X"
			)
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
					if "!win[%%~1]aero!"=="default" (
						for /l %%y in (2 1 !temp.H!) do (
							set "win[%%~1]p%%y=%\e%[48;2;!dwm.aero[%%y]!;38;!win[%%~1]TIcolor!m%dwm.char.L%%\e%[%%~bX%\e%[%%~bC       %dwm.char.R%"
							set "win[%%~1]p!win[%%~1]H!=%\e%[48;2;!dwm.aero[%%y]!;38;!win[%%~1]TIcolor!m%dwm.char.S%!dwm.bottombuffer:~0,%%~b!%dwm.bottombuffer:~0,7%%dwm.char.S%"
						)					
					) else (
						for /l %%y in (2 1 !temp.H!) do (
							set /a "x=(%%y+!win[%%~1]Y!-1)", "!win[%%~1]aero:×=*!"
							set "win[%%~1]p%%y=%\e%[48;2;!r!;!g!;!b!;38;!win[%%~1]TIcolor!m%dwm.char.L%%\e%[%%~bX%\e%[%%~bC       %dwm.char.R%"
						)
						set "win[%%~1]p!win[%%~1]H!=%\e%[48;2;!r!;!g!;!b!;38;!win[%%~1]TIcolor!m%dwm.char.S%!dwm.bottombuffer:~0,%%~b!%dwm.bottombuffer:~0,7%%dwm.char.S%"
						set r=
						set g=
						set b=
						set x=
					)
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
			set "mainbuffer=%\e%[!win[%%~1]Y!;!win[%%~1]X!H"
			set /a "win[%%~1]BY=win[%%~1]Y+win[%%~1]H-1"
			for /l %%y in (!win[%%~1]Y! 1 !win[%%~1]BY!) do set "mainbuffer=!mainbuffer!%\e%[48;2;!dwm.aero[%%y]!m%\e%[!win[%%~1]W!X%\e%[B"
			for /f "tokens=1 delims==" %%a in ('set win[%%~1] 2^>nul') do set "%%a="
			set "win.order=!win.order: "%%~1" = !"
		) else if "%%~0"=="CTRL" (
			set "mainbuffer=!mainbuffer!%\e%[H"
			if "%%~1"=="MINIMIZE" (
				set "mainbuffer=!dwm.scene!"
				set "win.order=!win.order: "%%~2" = !"
			) else if "%%~1"=="RESTORE" (
				if "!win[%%~2]X!" neq "" set "win.order=!win.order: "%%~2" = !"%%~2" "
			) else if "%%~1"=="ORDER" (
				set "win.order= %%~2 "
			) else if "%%~1"=="APPLYTHEME" (
				for %%a in (
					!theme[%%~2]!
				) do set "dwm.%%~a"
				if defined dwm.aero (
					set "dwm.scene=%\e%[H"
					set /a temp=modeH-1
					for /l %%x in (1 1 !temp!) do (
						set /a "x=%%x", "!dwm.aero:×=*!"
						set "dwm.aero[%%x]=!r!;!g!;!b!"
						set dwm.scene=!dwm.scene!%\e%[48;2;!r!;!g!;!b!m%\e%[2K%\e%[B
					)
					set temp=
				)
				set dwm.scene=
				set "mainbuffer=!dwm.scene!"
			) else if "%%~1"=="PAUSE" (
				call :sleep
			) else if "%%~1"=="BSOD" (
				call :bsod "%%~2" "%%~3"
			)
		) else if "%%~0"=="DUMP" (
			if "%%~1"=="WIN" (
				set win%%~2 >&3
			) else if "%%~1"=="ORDER" (
				set win.order >&3
			) else if "%%~1"=="MODE" (
				set mode >&3
			) else if "%%~1"=="LOAD" (
				for /f "usebackq tokens=1* delims==" %%x in ("%%~2") do set "%%x=%%y"
			)
		) else if "%%~0"=="EXIT" exit 0

		if defined mainbuffer (
			rem set dwm.scene=%\e%[H
			rem for /l %%x in (1 1 !modeH!) do (
			rem 	set /a "r=255-(%%x*127/modeH), g=!random:~0,2!/2, b=r*2"
			rem 	set dwm.scene=!dwm.scene!%\e%[48;2;!r!;!g!;!b!m%\e%[2K%\e%[B
			rem )
			rem set "dwm.scene=!dwm.scene!%\e%[999C%\e%[44D%\e%[38;5;15mLo-Fi theme | Shivtanium !sys.tag! !sys.ver! !sys.subvinfo!"
			rem set r=
			rem set g=
			rem set b=
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
	set input=
	if defined io.input (
		set "input=!io.input!"
	) else set /p input=
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
set "halt.cause=#%~1"
set halt.causeLen=0
for /l %%y in (9,-1,0) do (
	set /a "halt.causelen|=1<<%%y"
	for %%Y in (!halt.causelen!) do if "!halt.cause:~%%Y,1!" equ "" set /a "halt.causelen&=~1<<%%y"
)
set "halt.cause=!halt.cause:~1!"
set "halt.message=%~2"
set halt.finalmsg=
set halt.lines=!spr.[bootlogo.spr].H!
set /a "halt.msgW=!spr.[bootlogo.spr].W!-2", "halt.promptX=(!modeW!-24)/2", "halt.causeX=(modeW - halt.causeLen) / 2"
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
		set halt.temp=!halt.msgW!
		set halt.tempmsg=#
	)
	if !halt.temp! gtr !halt.msgW! (
		if defined halt.templine (
			set halt.finalmsg=!halt.finalmsg! "!halt.templine:~0,%halt.msgW%!"
		) else set halt.finalmsg=!halt.finalmsg! ""
		set halt.templine=
		set /a "halt.lines+=1", "halt.temp%%=halt.msgW"
	)
	set "halt.templine=!halt.templine! !halt.tempmsg:~1!"
)
set halt.finalmsg=!halt.finalmsg! "!halt.templine!"
set /a "halt.posX=!sst.boot.logoX!", "halt.posY=(!modeH!-!halt.lines!)/2"

<nul set /p "=%\e%[48;2;;;255;38;5;231m%\e%[2J%\e%[!halt.posY!;!halt.posX!H!spr.[bootlogo.spr]!%\e%[B%\e%[!halt.causeX!G!halt.cause!%\e%[B%\e%[48;2;63;63;255m"
for %%a in (!halt.finalmsg!) do (
	<nul set /p "=%\e%[B%\e%[!halt.posX!G%\e%[!spr.[bootlogo.spr].W!X%%~a"
)
set /p "=%\e%[2B%\e%[!halt.promptX!G%\e%[7m Press any key to exit. %\e%[27m"
exit %3
:sleep
set exit=
for /l %%A in (1 1 10000) do if not defined exit (
	ping -n 2 127.0.0.1 > nul
)
if not defined exit goto sleep
set exit=
exit /b 0
