@echo off
if not defined \e for /f %%a in ('echo prompt $E^| cmd') do set "\e=%%a"
if not defined \n set \n=^^^


if not exist "%~dp0" exit /b 404
cd "%~dp0" || exit /b 404
setlocal enabledelayedexpansion
chcp.com 65001>nul
set "sst.dir=!cd!"
if not exist temp md temp
rd /s /q temp > nul || del /F /Q temp > nul
md temp
set sst.localtemp=!random!
copy nul "temp\!sst.localtemp!" > nul

set "sstfs.mainfile=%~f1"
if not exist "!sstfs.mainfile!" set "sstfs.mainfile=!sst.dir!\core\main.sstfs"
set counter=0
for /f "tokens=2 delims=:" %%a in ('mode con') do (
	set /a counter+=1
	set "token=%%~a"
	if "!counter!"=="1" set "sys.modeH=!token: =!"
	if "!counter!"=="2" set "sys.modeW=!token: =!"
)
set /a "sst.boot.msgY=!sys.modeH!/2+7"
<nul set /p "=%\e%[H%\e%[48;2;0;0;0m%\e%[38;2;255;255;255m"
for %%a in (
	":clearEnv|Clearing environment"
	":loadresourcepack init|Loading resources"
	":loadSettings|Loading settings"
	":SSTFS.mount '!sstfs.mainfile!' \mnt\init|Mounting SSTFS file"
	":createProcess 0 \mnt\init\init.sst|Creating init process"
	"cmd /c boot_FAF.bat|Initialization completed"
) do for /f "tokens=1* delims=|" %%b in (%%a) do (
	set "sst.boot.command=%%~b"
	set sst.boot.command=!sst.boot.command:'="!
	set "sst.boot.msg=%%~c"
	set sst.boot.msglen=0
	for /l %%b in (9,-1,0) do (
		set /a "sst.boot.msglen|=1<<%%b"
		for %%c in (!sst.boot.msglen!) do if "!sst.boot.msg:~%%c,1!" equ "" set /a "sst.boot.msglen&=~1<<%%b"
	)
	set /a "sst.boot.msgX=(!sys.modeW!-!sst.boot.msglen!+1)/2"
	<nul set /p "=%\e%[!sst.boot.logoY!;!sst.boot.logoX!H!spr.[bootlogo.spr]!%\e%[!sst.boot.msgY!;!sst.boot.msgX!H%\e%[2K!sst.boot.msg!%\e%[B%\e%[2K%\e%[H"
	call !sst.boot.command! || call :halt "@boot %%~c" "%%~b: Something went wrong. Errorlevel: !errorlevel!"
)
for /f "tokens=1 delims==" %%a in ('set sst.boot') do if /I "%%~a" neq "sst.boot.logoX" if /I "%%~a" neq "sst.boot.logoY" set "%%a="
sysEventHandeler.bat | Shivtanium.bat | dwm.bat
exit /b 0
:startup.submsg

	set "sst.boot.msg=%~1"
	set "sst.boot.submsg=%~2"
	set sst.boot.msglen=0
	set sst.boot.submsglen=0
	for /l %%b in (9,-1,0) do (
		set /a "sst.boot.msglen|=1<<%%b"
		for %%c in (!sst.boot.msglen!) do if "!sst.boot.msg:~%%c,1!" equ "" set /a "sst.boot.msglen&=~1<<%%b"
	)
	
	for /l %%b in (9,-1,0) do (
		set /a "sst.boot.submsglen|=1<<%%b"
		for %%c in (!sst.boot.submsglen!) do if "!sst.boot.submsg:~%%c,1!" equ "" set /a "sst.boot.submsglen&=~1<<%%b"
	)
	
	set /a "sst.boot.msgX=(sys.modeW-sst.boot.msglen+1)/2", "sst.boot.submsgX=(sys.modeW-sst.boot.submsglen+1)/2"
	<nul set /p "=%\e%[!sst.boot.logoY!;!sst.boot.logoX!H!spr.[bootlogo.spr]!%\e%[!sst.boot.msgY!;!sst.boot.msgX!H%\e%[2K!sst.boot.msg!%\e%[B%\e%[!sst.boot.submsgX!G%\e%[2K!sst.boot.submsg!%\e%[H"

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
set "pid[!temp.pid!]cb=0"
set temp.lines=0
if "!sstfs.[%temp.scriptname%]!"=="" call :halt "%~nx0:createProcess" "Script not found: !temp.scriptname!"
set "pid[!temp.pid!]=!temp.scriptname!"
for /f "eol=# delims=" %%a in ('SSTFS-read.bat "!temp.scriptname!"') do (
	set /a temp.lines+=1
	set "temp.line=%%a"
	if not defined temp.line call :halt "%~nx0:createProcess" "Something went wrong when creating the following process:\nPID: !temp.pid!, EXE: !temp.scriptname!"
	if "!temp.line:~0,1!"==":" (
		set "temp.label=!temp.line!"
		for %%a in (a b c d e f g h i j k l m n o p q r s t u v w x y z _ . 1 2 3 4 5 6 7 8 9 0 \) do set "temp.label=!temp.label:%%~a=!"
		if "!temp.label!" neq ":" call :halt "%~nx0:createProcess" "At line !temp.lines!: Invalid label name:\n'!temp.line!'\nWhitelisted characters: A-Z, a-z, 0-9, '_.\'"
		set "pid[!temp.pid!]#!temp.line:~1!=!temp.lines!"
	) else set "pid[!temp.pid!]l[!temp.lines!]=%%a"
)
set "pid[!temp.pid!]cl=1"
set "pid[!temp.pid!]ss=!temp.lines!"
set sst.processes=!sst.processes! !temp.pid!
set /a sst.proccount+=1
set temp.pid=
set temp.scriptcreator=
set temp.scriptname=
set temp.lines=
set temp.line=
exit /b 0

REM == Modules ==
:loadresourcepack
if not exist "!sst.dir!\resourcepacks\%~1" exit /b 1
for /f "delims=" %%a in ('dir /b "!sst.dir!\resourcepacks\%~1\sprites\*.spr" 2^>nul') do call :loadsprites "!sst.dir!\resourcepacks\%~1\sprites\%%~a" %%~a
set /a "sst.boot.logoX=(!sys.modeW!-!spr.[bootlogo.spr].W!)/2+1", "sst.boot.logoY=(!sys.modeH!-!spr.[bootlogo.spr].H!)/2+1"
echo(%\e%[H%\e%[48;2;0;0;0m%\e%[38;2;255;255;255m%\e%[2J
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
set "halt.text=%~2"
set halt.text=!halt.text:\n=","!
set "halt.pausemsg= Press any key to exit. . . "
set "halt.tracemsg= At %~1: "
for /l %%a in (64 -1 0) do (
	<nul set /p "=%\e%[2;3H%\e%[48;2;255;0;0m%\e%[38;2;255;255;255m%\e%[?25l Execution halted %\e%[4;3H!halt.tracemsg:~%%a!"
	for /l %%. in (0 1 10000) do rem
	for %%b in ("!halt.text!") do (
		set "halt.line=%%~b "
		<nul set /p "=%\e%[E%\e%[3G     !halt.line:~%%a!%\e%7"
	)
	<nul set /p "=%\e%[999;3H%\e%[A!halt.pausemsg:~%%a!%\e%8%\e%[2E"
)
call :memorydump
pause>nul<con
exit 0
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
:SSTFS.mount
set sstfs.tempcounter=0
set sstfs.temp=
set sstfs.fsend=
if not exist "%~1" call :halt "%~nx0:SSTFS.mount" "Filesystem not found: '%~1'"
if "%~2"=="" call :halt "%~nx0:SSTFS.mount" "Path not specified"
findstr /N "^!" "%~f1">nul
if not errorlevel 1 call :halt "%~nx0:SSTFS.mount" "Found illegal character: <exclamation mark>"

set "temp.whitelist= %~2"
for %%z in (a b c d e f g h i j k l m n o p q r s t u v w x y z 1 2 3 4 5 6 7 8 9 \ / _ .) do (
	set "temp.whitelist=!temp.whitelist:%%z=!"
)
if "!temp.whitelist!" neq " " call :halt "%~nx0:SSTFS.mount" "Illegal mount destination path: %~2\nIllegal characters:!temp.whitelist!"
set "sstfs.dest=%~2"
set "sstfs.dest=!sstfs.dest:/=\!"

for /f "usebackq tokens=1*" %%a in ("%~f1") do (
	REM Todo: Add whitelisted characters
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
		call :startup.submsg "Mounting SSTFS File for !sstfs.dest!" "Registered file: !parameters!"
	)
	set /a sstfs.tempcounter+=1
)
if defined sstfs.temp set /a "sstfs.[!sstfs.dest!\!sstfs.temp!].end=!sstfs.tempcounter!-1"
set "sstfs.mnt[!sstfs.dest!]=%~f1"
set sstfs.fsend=
set sstfs.temp=
set sstfs.tempcounter=
exit /b 0
:loadSettings
set sys.ver=0.3.0
set sys.tag=Alpha
set sys.subvinfo=[24w20a]
title Shivtanium version !sys.tag! !sys.ver!

set dwm.scene=%\e%[H%\e%[0m%\e%[48;2;0;63;127m%\e%[2JDefault ^(Metro^) theme
set dwm.BGcolor=5;231
set dwm.FGcolor=5;16
set dwm.TIcolor=5;12
set dwm.TTcolor=5;231
set dwm.NIcolor=5;4
set dwm.NTcolor=5;7
set dwm.CBUI=%\e%[38;5;231m%\e%[48;2;0;192;192m - %\e%[48;2;0;255;255m □ %\e%[48;2;255;0;0m × 

cd "%~dp0" > nul 2>&1 || exit /b
set "sys.dir=!cd!"

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
