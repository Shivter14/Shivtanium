@echo off
if not defined \e for /f %%a in ('echo prompt $E^| cmd') do set "\e=%%a"
if not defined \n set \n=^^^


if not exist "%~dp0" exit /b 404
cd "%~dp0" || exit /b 404
setlocal enabledelayedexpansion
chcp.com 65001>nul
set "sst.dir=!cd!"
if not exist temp md temp
set "sstfs.mainfile=%~f1"
if not exist "%~f1" call :halt "%~nx0" "SSTFS failed to initialize:\n  File not found: `%~1`"
set counter=0
for /f "tokens=2 delims=:" %%a in ('mode con') do (
	set /a counter+=1
	set "token=%%~a"
	if "!counter!"=="1" set "sys.modeH=!token: =!"
	if "!counter!"=="2" set "sys.modeW=!token: =!"
)
set /a "sst.boot.msgY=!sys.modeH!/2+7"
for %%a in (
	":clearEnv|Clearing environment"
	":loadresourcepack init|Loading resources"
	":loadSettings|Loading settings"
	":initSSTFS|Initializing SSTFS lookups"
	":createProcess 0 init.sst|Creating init process"
	"cmd /c boot_FAF.bat|Initialization completed"
) do for /f "tokens=1* delims=|" %%b in (%%a) do (
	set "sst.boot.msg=%%~c"
	set sst.boot.msglen=0
	for /l %%b in (9,-1,0) do (
		set /a "sst.boot.msglen|=1<<%%b"
		for %%c in (!sst.boot.msglen!) do if "!sst.boot.msg:~%%c,1!" equ "" set /a "sst.boot.msglen&=~1<<%%b"
	)
	set /a "sst.boot.msgX=(!sys.modeW!-!sst.boot.msglen!+1)/2"
	if not defined sst.boot.logoX if defined spr.[bootlogo.spr].W (
		set /a "sst.boot.logoX=(!sys.modeW!-!spr.[bootlogo.spr].W!)/2+1", "sst.boot.logoY=(!sys.modeH!-!spr.[bootlogo.spr].H!)/2+1"
		echo(%\e%[H%\e%[48;2;0;0;0m%\e%[38;2;255;255;255m%\e%[J
	)
	<nul set /p "=%\e%[!sst.boot.logoY!;!sst.boot.logoX!H!spr.[bootlogo.spr]!%\e%[!sst.boot.msgY!;!sst.boot.msgX!H%\e%[2K!sst.boot.msg!%\e%[H"
	call %%~b|| call :halt "@boot %%~c" "%%~b: Something went wrong. Errorlevel: !errorlevel!"
)
Shivtanium.bat | dwm.bat
:memoryDump
pushd "!sst.dir!\temp" || exit /b !errorlevel!
set > memoryDump
for %%A in (memoryDump) do (
	popd
	exit /b %%~zA
)
exit /b %errorlevel%
:createProcess
set temp.pid=!random!
if defined pid[!temp.pid!] goto createProcess
REM Todo: This gets slower the more processes are running.
set "temp.scriptcreator=%~1"
set "temp.scriptname=%~2"
set temp.lines=0
if "!sstfs.[%temp.scriptname%]!"=="" call :halt "%~nx0:createProcess" "Script not found: !temp.scriptname!"
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
set sst.processes=!sst.processes! !temp.pid!
set /a sst.proccount+=1
exit /b 0

REM == Modules ==
:loadresourcepack
if not exist "!sst.dir!\resourcepacks\%~1" exit /b 1
for /f "delims=" %%a in ('dir /b "!sst.dir!\resourcepacks\%~1\sprites\*.spr"') do call :loadsprites "!sst.dir!\resourcepacks\%~1\sprites\%%~a" %%~a;
exit /b 0
:loadSprites
if not exist "%~1" call :halt "%~nx0:loadSprites" "File not found: %~1"
if "%~2"=="" call :halt "%~nx0:loadSprites" "Memory location not specified"
set "spr.[%~2]=%\e%7"
set /a "spr.W=0", "spr.[%~2].H=0"
for /f "delims=" %%a in ('type "%~1"') do (
	set "spr.temp=x%%~a"
	set "spr.[%~2]=!spr.[%~2]!%%~a%\e%8%\e%[B%\e%7"
	set spr.tempW=0
	for /l %%b in (9,-1,0) do (
		set /a "spr.tempW|=1<<%%b"
		for %%c in (!spr.tempW!) do if "!spr.temp:~%%c,1!" equ "" set /a "spr.tempW&=~1<<%%b"
	)
	if !spr.tempW! gtr !spr.W! set spr.W=!spr.tempW!
	set /a "spr.[%~2].H+=1"
)
set "spr.[%~2].W=!spr.W!"
set spr.W=
set spr.temp=
set spr.tempW=
exit /b 0
:halt
if defined getInputInitialized call :reInjectDLLs 0 100
for /f "tokens=2 delims=:" %%a in ('mode con') do (
	set /a counter+=1
	set "token=%%~a"
	if "!counter!"=="2" set /a "halt.modeW=!token: =!-7"
)
set "halt.text=%~2"
set halt.text=!halt.text:\n=","!
set "halt.pausemsg= Press any key to exit. . . "
set "halt.tracemsg= At %~1: "
for /l %%a in (!halt.modeW! -1 0) do (
	<nul set /p "=%\e%[2;3H%\e%[48;2;255;0;0m%\e%[38;2;255;255;255m%\e%[?25l Execution halted %\e%[4;3H!halt.tracemsg:~%%a!"
	for /l %%. in (0 1 10000) do rem
	for %%b in ("!halt.text!") do (
		set "halt.line=%%~b "
		<nul set /p "=%\e%[E%\e%[3G     !halt.line:~%%a,%halt.modeW%!%\e%7"
	)
	<nul set /p "=%\e%[999;3H%\e%[A!halt.pausemsg:~%%a!%\e%8%\e%[2E"
)
pause>nul
exit 0
:injectDLLs
cd "!sst.dir!"
set /a "noResize=1", "getinput_tps=200"
if not exist core\getInput64.dll call :halt "%~nx0:injectDLLs" "Missing File: core\getInput64.dll"
rundll32.exe core\getInput64.dll,inject|| call :halt "%~nx0:injectDLLs" "Failed to inject getInput64.dll\nErrorlevel: !errorlevel!"
if not defined getInputInitialized call :halt "%~nx0:injectDLLs" "Failed to inject getInput64.dll: Unknown error.\nErrorlevel: %errorlevel%"
exit /b
:reInjectDLLs
cd "!sst.dir!"
set /a "noResize=%~1", "getinput_tps=%~2"
if not exist core\getInput64.dll exit /b 1
rundll32.exe core\getInput64.dll,inject
exit /b %errorlevel%
:clearEnv
for /f "tokens=1 delims==" %%a in ('set') do for /f "tokens=1 delims=._" %%c in ("%%~a") do (
	set "unload=True"
	for %%b in (
		ComSpec SystemRoot
		ssvm sst sstfs sys
		temp path
		PATHEXT
		\n \e
		PROCESSOR
		NUMBER_OF_PROCESSORS
	) do if /i "%%~c"=="%%~b" set "unload=False"
	if "!unload!"=="True" set "%%a="
)
set unload=
exit /b 0
:initSSTFS
set sstfs.tempcounter=0
set sstfs.temp=
set sstfs.fsend=
if not exist "!sstfs.mainfile!" call :halt "%~nx0:initSSTFS" "Filesystem not found: '!sstfs.mainfile!'"
findstr /N "^!" "!sstfs.mainfile!">nul
if not errorlevel 1 call :halt "%~nx0:initSSTFS" "Found illegal character: <exclamation mark>"
for /f "usebackq tokens=1*" %%a in ("!sstfs.mainfile!") do (
	REM Todo: Add whitelisted characters
	set "command=%%~a"
	set "parameters=%%~b"
	if "!command!"=="@FILE" (
		set error.invalidFileName=
		set "temp.whitelist=!parameters!"
		for %%z in (a b c d e f g h i j k l m n o p q r s t u v w x y z 1 2 3 4 5 6 7 8 9 / _ .) do (
			set "temp.whitelist=!temp.whitelist:%%z=!"
		)
		if defined temp.whitelist set "error.invalidFileName=!temp.whitelist!"

		if defined error.invalidFileName call :halt "%~nx0:initSSTFS" "Error in filesystem: Invalid file name:\n'!parameters!'\nInvalid characters:!error.invalidFileName!"
		set /a "sstfs.[!parameters!]"=!sstfs.tempcounter!+1
		if defined sstfs.temp set /a "sstfs.[!sstfs.temp!].end=!sstfs.tempcounter!-1"
		set "sstfs.temp=!parameters!"
	)
	set /a sstfs.tempcounter+=1
)
if defined sstfs.temp set /a "sstfs.[!sstfs.temp!].end=!sstfs.tempcounter!-1"
set sstfs.fsend=
set sstfs.temp=
set sstfs.tempcounter=
exit /b 0
:loadSettings
set sys.ver=0.1.2
set sys.tag=Alpha
set sys.subvinfo=[24w18a]
title Shivtanium version !sys.tag! !sys.ver!

set dwm.scene=%\e%[H%\e%[0m%\e%[48;2;0;63;127m%\e%[2JDefault ^(Metro^) theme
set dwm.BGcolor=5;231
set dwm.FGcolor=5;16
set dwm.TIcolor=5;12
set dwm.TTcolor=5;231
set dwm.NIcolor=5;4
set dwm.NTcolor=5;7
set dwm.CBUI=%\e%[38;5;231m%\e%[48;2;0;192;192m - %\e%[48;2;0;255;255m □ %\e%[48;2;255;0;0m × 

set dwm.winAnimSpeed=50
set "dwm.barbuffer=                                                                                                                                                                                                                                                                "
set "dwm.bottombuffer=▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄"
set "dwm.outlinebuffer=░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
set sst.bgdelay=0
set dwm.order=
set dwm.focused=
set dwm.char.L=█
set dwm.char.B=▄
set dwm.char.R=█
set dwm.char.S=█
set dwm.char.O=░░
set dwm.moving=
set /a "dwm.tps=100", "dwm.tdt=100/dwm.tps", "sst.proccount=0", "sys.click=0"
for %%a in (
	"PROCESSOR_ARCHITECTURE=sys.CPU.architecture"
	"PROCESSOR_IDENTIFIER=sys.CPU.identifier"
	"PROCESSOR_LEVEL=sys.CPU.level"
	"PROCESSOR_REVISION=sys.CPU.revision"
	"NUMBER_OF_PROCESSORS=sys.CPU.count"
	"FIRMWARE_TYPE=sys.FIRMWARE_TYPE"
) do for /f "tokens=1,2 delims==" %%b in ("%%~a") do (
	set "%%~c=!%%~b!"
	set "%%~b="
	if "!%%~c!"=="" call :halt "%~nx0:loadSettings" "Failed to define variable translation:\n%%~c = %%~b"
)
exit /b 0
REM == Raw window building macro ==
set dwm.window.build=(%\n%
	set triggerevent=True%\n%
	if "^!dwm.[%%~v].fullscreen^!"=="True" (%\n%
		set "dwm.[%%~v].X=1"%\n%
		set "dwm.[%%~v].Y=1"%\n%
		set "dwm.[%%~v].width=^!sst.crrresX^!"%\n%
		set "dwm.[%%~v].height=^!sst.crrresY^!"%\n%
	)%\n%
	set /a "dwm.[%%~v].X=^!dwm.[%%~v].X^!", "dwm.[%%~v].Y=^!dwm.[%%~v].Y^!", "dwm.[%%~v].width=^!dwm.[%%~v].width^!", "dwm.[%%~v].height=^!dwm.[%%~v].height^!"%\n%
	if ^^^!dwm.[%%~v].width^^^! gtr ^^^!sst.crrresX^^^! set "dwm.[%%~v].width=^!sst.crrresX^!"%\n%
	if ^^^!dwm.[%%~v].X^^^! lss 1 set "dwm.[%%~v].X=1"%\n%
	if ^^^!dwm.[%%~v].Y^^^! lss 1 set "dwm.[%%~v].Y=1"%\n%
	if ^^^!dwm.[%%~v].Y^^^! gtr ^^^!sst.defaultresY^^^! set "dwm.[%%~v].Y=^!sst.defaultresY^!"%\n%
	set /a "dwm.[%%~v].boundX=^!dwm.[%%~v].X^!+^!dwm.[%%~v].width^!-1"%\n%
	if ^^^!dwm.[%%~v].boundX^^^! gtr ^^^!sst.crrresX^^^! (%\n%
		set /a "dwm.[%%~v].X=^!sst.crrresX^!-^!dwm.[%%~v].width^!+1"%\n%
		set /a "dwm.[%%~v].boundX=^!dwm.[%%~v].X^!+^!dwm.[%%~v].width^!-1"%\n%
	)%\n%
	set /a "dw.boxE=^!dwm.[%%~v].height^!-1", "dw.boxH=^!dwm.[%%~v].height^!-3", "dwm.[%%~v].contentX=^!dwm.[%%~v].X^!+2", "dwm.[%%~v].contentY=^!dwm.[%%~v].Y^!+2", "dwm.[%%~v].boundY=^!dwm.[%%~v].Y^!+^!dwm.[%%~v].height^!-1", "dwm.[%%~v].CBX=^!dwm.[%%~v].X^!+^!dwm.[%%~v].width^!-3", "dwm.[%%~v].FBX=^!dwm.[%%~v].X^!+^!dwm.[%%~v].width^!-6", "dwm.[%%~v].MBX=^!dwm.[%%~v].X^!+^!dwm.[%%~v].width^!-9"%\n%
	set /a "dw.tbw=^!dwm.[%%~v].width^!-9", "dw.titleW=^!dwm.[%%~v].width^!-2"%\n%
	set "dwrender.[%%~v]=%\e%[^!dwm.[%%~v].Y^!;^!dwm.[%%~v].X^!H%\e%[48;5;^!dwm.[%%~v].BGcolor^!m%\e%[38;5;^!dwm.[%%~v].TIcolor^!m%\e%7"%\n%
	set "dw.FBcolor=^!dwm.[%%~v].FBcolor^!"%\n%
	for /f "tokens=1,2" %%w in ("^!dw.titleW^! ^!dw.tbw^!") do (%\n%
		if "^!dwm.[%%~v].fullscreen^!" neq "True" (%\n%
			for /l %%y in (1 2 ^^^!dw.boxH^^^!) do set "dwrender.[%%~v]=^!dwrender.[%%~v]^!%\e%8%\e%[%%yB%dwm.char.S%^!dwm.barbuffer:~0,%%~w^!%dwm.char.S%%\e%8%\e%[%%yB%\e%[B%dwm.char.S%^!dwm.barbuffer:~0,%%~w^!%dwm.char.S%"%\n%
			set /a "dw.ssc=^!dw.boxH^! %% 2"%\n%
			if "^!dw.ssc^!" equ "0" set "dwrender.[%%~v]=^!dwrender.[%%~v]^!%\e%8%\e%[^!dw.boxE^!B%\e%[A%dwm.char.S%^!dwm.barbuffer:~0,%%~w^!%dwm.char.S%"%\n%
			set "dwrender.[%%~v]=^!dwrender.[%%~v]^!%\e%8%\e%[^!dw.boxE^!B%dwm.char.L%^!dwm.bottombuffer:~0,%%~w^!%dwm.char.R%"%\n%
		) else (%\n%
			set "dwrender.[%%~v]=^!dwrender.[%%~v]^!%\e%[2J"%\n%
			set dw.FBcolor=%\n%
		)%\n%
		set "dwrender.[%%~v]=x^!dwrender.[%%~v]^!%\e%[48;5;^!dwm.[%%~v].TIcolor^!m%\e%[38;5;^!dwm.[%%~v].TTcolor^!m%\e%8^!dwm.barbuffer:~0,%%~x^!^!dwm.[%%~v].MBcolor^! - ^!dw.FBcolor^! □ ^!dwm.[%%~v].CBcolor^! × %\e%[48;5;^!dwm.[%%~v].TIcolor^!m%\e%[38;5;^!dwm.[%%~v].TTcolor^!m%\e%8 ^!dwm.[%%~v].title:~0,%%~w^!%\e%8%\e%[2C%\e%[2B%\e%[48;5;^!dwm.[%%~v].BGcolor^!m%\e%[38;5;^!dwm.[%%~v].FGcolor^!m^!dwm.[%%~v].content^!"%\n%
		set "dw.length=0"%\n%
		for /l %%y in (9,-1,0) do (set /a "dw.length|=1<<%%y"%\n%
			for %%Y in (^^^!dw.length^^^!) do if "^!dwrender.[%%~v]:~%%Y,1^!" equ "" set /a "dw.length&=~1<<%%y"%\n%
		)%\n%
		set /a "dwblitsize.[%%~v]=^!dw.length^!"%\n%
		set "dwrender.[%%~v]=^!dwrender.[%%~v]:~1^!"%\n%
	)%\n%
)

REM == Window creating macro ==
set dwm.window.create=for %%z in (1 2) do if "%%~z"=="2" (%\n%
	set dw.class=%\n%
	for %%w in (^^^!macro.create.args^^^!) do for /f "tokens=1,2 delims==" %%x in ("%%~w") do (%\n%
		if "%%~x"=="class" (set "dw.class=%%~y"%\n%
		) else (%\n%
			if not defined dw.class call :halt dwm.window.create "Class not specified"%\n%
			set "dwm.[^!dw.class^!].%%~x=%%~y"%\n%
	))%\n%
	if not defined dw.class call :halt dwm.window.create "No arguments specified"%\n%
	for %%v in ("^!dw.class^!") do (%\n%
		for %%w in ("fullscreen=" "disableClosing=" "disableMoving=" "disableResizing=" "whileFocused=" "X=8" "Y=4" "width=48" "height=12" "CBcolor=!dwm.CBcolor!" "FBcolor=!dwm.FBcolor!" "MBcolor=!dwm.MBcolor!" "BGcolor=^!dwm.BGcolor^!" "FGcolor=^!dwm.FGcolor^!" "TIcolor=^!dwm.TIcolor^!" "TTcolor=^!dwm.TTcolor^!"%\n%
		) do for /f "tokens=1* delims==" %%x in ("%%~w") do if "^!dwm.[%%~v].%%~x^!"=="" set "dwm.[%%~v].%%~x=%%~y"%\n%
		set "dwm.[%%~v].MBdefault=^!dwm.[%%~v].MBcolor^!"%\n%
		set "dwm.[%%~v].FBdefault=^!dwm.[%%~v].FBcolor^!"%\n%
		set "dwm.[%%~v].CBdefault=^!dwm.[%%~v].CBcolor^!"%\n%
		!dwm.window.build!%\n%
		set dwm.launcher=^^^!dwm.launcher^^^! "%%~v"%\n%
		for /f "tokens=1 delims==" %%a in ('set dw.') do set "%%~a="%\n%
		call :window.focus "class=%%~v"%\n%
		if "^!dwm.[%%~v].whileFocused^!" neq "" call ^^^!dwm.[%%~v].whileFocused^^^! "%%~v" /init%\n%
	)%\n%
) else set macro.create.args=

REM == Window modifying macro ==
set dwm.window.modify=for %%z in (1 2) do if "%%~z" equ "2" (%\n%
	set dw.class=%\n%
	for %%w in (^^^!macro.args^^^!) do for /f "tokens=1,2 delims==" %%x in ("%%~w") do (%\n%
		if "%%~x"=="class" (set "dw.class=%%~y"%\n%
		) else (%\n%
			if not defined dw.class (%\n%
				color 0F%\n%
				cls%\n%
				set macro.args%\n%
				call :halt dwm.window.modify "Class not specified"%\n%
			)%\n%
			set "dwm.[^!dw.class^!].%%~x=%%~y"%\n%
	))%\n%
	if not defined dw.class exit%\n%
	for %%v in ("^!dw.class^!") do !dwm.window.build!%\n%
	for /f "tokens=1 delims==" %%a in ('set dw.') do set "%%~a="%\n%
) else set macro.args=
REM == Window hovering macro, if the cursor is hovering over a diffrent window, returns errorlevel 1 ==
set dwm.window.touch=(%\n%
	set dwm.hoveringover=%\n%
	for %%o in (^^^!dwm.order^^^!) do if ^^^!sst.mvc.crvX^^^! geq ^^^!dwm.[%%~o].X^^^! if ^^^!sst.mvc.crvY^^^! geq ^^^!dwm.[%%~o].Y^^^! if ^^^!sst.mvc.crvX^^^! leq ^^^!dwm.[%%~o].boundX^^^! if ^^^!sst.mvc.crvY^^^! leq ^^^!dwm.[%%~o].boundY^^^! set "dwm.hoveringover=%%~o"%\n%
	if "^!dwm.hoveringover^!" neq "^!dwm.focused^!" call cmd.exe /c exit 1%\n%
)

REM == Window focusing macro. Args: "class=<class>" ==
set dwm.window.focus=for %%z in (1 2) do if "%%~z" equ "2" (%\n%
	if defined dwm.focused call :window.modify "class=^!dwm.focused^!" "TIcolor=^!dwm.NIcolor^!" "TTcolor=^!dwm.NTcolor^!" "MBcolor=" "FBcolor=" "CBcolor="%\n%
	set dw.class=%\n%
	for %%w in (^^^!macro.focus.args^^^!) do for /f "tokens=1,2 delims==" %%x in ("%%~w") do if "%%~x"=="class" set "dw.class=%%~y"%\n%
	if defined dw.class (%\n%
		set dwm.neworder=%\n%
		for %%v in (^^^!dwm.order^^^!) do if "%%~v" neq "^!dw.class^!" set dwm.neworder=^^^!dwm.neworder^^^! "%%~v"%\n%
		set "dwm.focused=^!dw.class^!"%\n%
		set dwm.order=^^^!dwm.neworder^^^! "^!dwm.focused^!"%\n%
		for %%v in ("^!dwm.focused^!") do call :window.modify "class=%%~v" "TIcolor=^!dwm.TIcolor^!" "TTcolor=^!dwm.TTcolor^!" "MBcolor=^!dwm.[%%~v].MBdefault^!" "FBcolor=^!dwm.[%%~v].FBdefault^!" "CBcolor=^!dwm.[%%~v].CBdefault^!"%\n%
		set dwm.neworder=%\n%
	) else set dwm.focused=%\n%
	for /f "tokens=1 delims==" %%a in ('set dw. 2^^^^^>nul') do set "%%a="%\n%
) else set macro.focus.args=

REM == FPS / timings updater macro, do not use. ==
set dwm.updatefps=(%\n%
	for /f "tokens=1-4 delims=:.," %%a in ("^!time: =0^!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000)"%\n%
	if defined t2 set /a "deltaTime=(t1 - t2)", "$TT+=deltaTime", "timer100cs+=deltaTime", "$sec=$TT / 100 %% 60", "$min=$TT / 100 / 60 %% 60"%\n%
	set /a "t2=t1", "global.frameCount=(global.frameCount + 1) %% 0x7FFFFFFF", "fpsFrames+=1"%\n%
	if ^^^!timer100cs^^^! GEQ 100 (%\n%
		set /a "timer100cs-=100,fps=fpsFrames,fpsFrames=0"%\n%
		if ^^^!timer100cs^^^! GEQ 100 set /a timer100cs=0%\n%
		if exist "%sst.dir%\shutdown.txt" exit%\n%
		if exist "%sst.dir%\crashed.txt" exit%\n%
	)%\n%
	if "^!$sec:~1^!" equ "" set "$sec=0^!$sec^!"%\n%
	title SysShivt tools %sst.ver% build %sst.build% [%sst.subvinfo%] Time: ^^^!$min^^^!:^^^!$sec^^^! FPS:^^^!fps^^^! FrameTime: ^^^!deltaTime^^^!cs Frames:^^^!global.frameCount^^^! totalTime:^^^!$TT^^^!%\n%
)

REM == The main renderer ==
set dwm.render=(%\n%
	set dwm.cachesize=0%\n%
	for /l %%b in (9,-1,0) do (set /a "dwm.cachesize|=1<<%%b"%\n%
		for %%c in (^^^!dwm.cachesize^^^!) do if "^!dwm.cache:~%%c,1^!" equ "" set /a "dwm.cachesize&=~1<<%%b"%\n%
	)%\n%
	for %%a in (^^^!dwm.order^^^!) do if "^!dwm.[%%~a].fullscreen^!" equ "True" (%\n%
		set "dwm.cache=^!dwrender.[%%~a]^!"%\n%
		set "dwm.cachesize=^!dwblitsize.[%%~a]^!"%\n%
	) else (%\n%
		set /a "dwm.cachesize+=^!dwblitsize.[%%~a]^!"%\n%
		if ^^^!dwm.cachesize^^^! gtr 8100 (%\n%
			echo( ^| set /p "=^!dwm.cache^!"%\n%
			set dwm.cache=%\n%
			set "dwm.cachesize=^!dwblitsize.[%%~a]^!"%\n%
		)%\n%
		set "dwm.cache=^!dwm.cache^!^!dwrender.[%%~a]^!"%\n%
	)%\n%
	set dwm.taskbar.counter=0%\n%
	set "dwm.taskbar=x%\e%[^!sst.crrresY^!;1H^!dwm.TBcolor^!%\e%[2K SysShivt tools "%\n%
	set /a "dwm.taskbar.max=(^!sst.crrresX^!-16)/18"%\n%
	for %%a in (^^^!dwm.launcher^^^!) do if not "^!dwm.taskbar.counter^!" equ "^!dwm.taskbar.max^!" (%\n%
		set /a "dwm.taskbar.counter+=1"%\n%
		set "dwm.temp=^!dwm.[%%~a].title^!"%\n%
		if "%%~a" equ "^!dwm.focused^!" (%\n%
			set "dwm.taskbar=^!dwm.taskbar^!%\e%[48;5;^!dwm.TIcolor^!m%\e%[38;5;^!dwm.TTcolor^!m                  %\e%[s%\e%[18D ^!dwm.temp:~0,17^!%\e%[u"%\n%
		) else set "dwm.taskbar=^!dwm.taskbar^!%\e%[48;5;^!dwm.NIcolor^!m%\e%[38;5;^!dwm.NTcolor^!m                  %\e%[s%\e%[18D ^!dwm.temp:~0,17^!%\e%[u"%\n%
	)%\n%
	set dwm.tbcsize=0%\n%
	for /l %%b in (9,-1,0) do (set /a "dwm.tbcsize|=1<<%%b"%\n%
		for %%c in (^^^!dwm.tbcsize^^^!) do if "^!dwm.taskbar:~%%c,1^!" equ "" set /a "dwm.tbcsize&=~1<<%%b"%\n%
	)%\n%
	set /a "dwm.cachesize+=^!dwm.tbcsize^!"%\n%
	if ^^^!dwm.cachesize^^^! gtr 8100 (%\n%
		echo( ^| set /p "=^!dwm.cache^!"%\n%
		set dwm.cache=%\n%
		set /a dwm.cachesize=0%\n%
	)%\n%
	set "dwm.cache=^!dwm.cache^!^!dwm.taskbar:~1^!"%\n%
	^<nul set /p "=^!dwm.cache^!%\e%[H"%\n%
	set dwm.cache=%\n%
)
exit /b 0