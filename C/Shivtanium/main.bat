@echo off
if not defined \e for /f %%a in ('echo prompt $E^| cmd') do set "\e=%%a"

setlocal enabledelayedexpansion
if "%~1"==":waitForBootServices" goto waitForBootServices.service
set "arg1=%~1"
if "!arg1:~0,1!"==":" (
	call %*
	exit /b
)

if not exist "%~dp0" exit /b 404
chcp.com 65001>nul

cd "%~dp0" || exit /b 404
pushd ..
set "sst.root=!cd!"
popd
set "sst.dir=!cd!"
if /I "!sst.noTempClear!" neq "True" (
	if not exist temp md temp
	rd /s /q temp > nul 2>&1 || del /F /Q temp > nul 2>&1
	if exist temp call :halt "{Temp directory deletion}" "There is another instance of Shivtanium currently running.\nThe system will not start to prevent glitches."
)
md temp >nul 2>&1
if not defined sst.localtemp set sst.localtemp=!random!

set counter=0
for /f "tokens=2 delims=:" %%a in ('mode con') do (
	set /a counter+=1
	set "token=%%~a"
	if "!counter!"=="1" set "sys.modeH=!token: =!"
	if "!counter!"=="2" set "sys.modeW=!token: =!"
)
set /a "sst.boot.msgY=!sys.modeH!/2+7"
<nul set /p "=%\e%[H%\e%[48;2;0;0;0m%\e%[38;2;255;255;255m"
if not exist "temp\bootStatus-!sst.localtemp!" copy nul "temp\bootStatus-!sst.localtemp!" > nul

if /I "!sst.noguiboot!" neq "True" (
	start /b "" cmd /c boot\renderer.bat "temp\bootStatus-!sst.localtemp!" < "temp\bootStatus-!sst.localtemp!"
)
set "processes= "
copy nul temp\kernelPipe > nul 2>&1 || call :halt "preparePipe" "Failed to prepare pipe:\n'temp\kernelPipe'"
copy nul temp\kernelOut  > nul 2>&1 || call :halt "preparePipe" "Failed to prepare pipe:\n'temp\kernelOut'"

for %%a in (
	":clearEnv|Clearing environment"
	":loadresourcepack init|Loading resources"
	":loadSettings|Loading settings"
	":checkCompat|Checking compatibility"
	":startServices|Starting services"
	"start /b cmd /c boot\cfmsf.bat|Checking for missing files"
	"start /b cmd /c boot\updateCheckSvc.bat|Checking for updates"
	"cmd /c boot\fadeout.bat|Startup finished"
	":injectDLLs"
	":waitForBootServices"
) do for /f "tokens=1-2* delims=|" %%b in (%%a) do (
	set "sst.boot.command=%%~b"
	set sst.boot.command=!sst.boot.command:'="!
	if "%%~c"=="" (
		echo=%\e%[!sst.boot.msgY!;!sst.boot.msgX!H%\e%[2K>> "temp\bootStatus-!sst.localtemp!"
	) else (
		set "sst.boot.msg=%%~c"
		set sst.boot.msglen=0
		for /l %%b in (9,-1,0) do (
			set /a "sst.boot.msglen|=1<<%%b"
			for %%c in (!sst.boot.msglen!) do if "!sst.boot.msg:~%%c,1!" equ "" set /a "sst.boot.msglen&=~1<<%%b"
		)
		set /a "sst.boot.msgX=(!sys.modeW!-!sst.boot.msglen!+1)/2"
		echo=%\e%[!sst.boot.logoY!;!sst.boot.logoX!H!spr.[bootlogo.spr]!%\e%[!sst.boot.msgY!;!sst.boot.msgX!H%\e%[2K!sst.boot.msg!%\e%[B%\e%[2K%\e%[H>> "temp\bootStatus-!sst.localtemp!"
	)
	call !sst.boot.command! || call :halt "Boot" "Something went wrong.\nCommand: %%~b\nText: %%~c\nErrorlevel: !errorlevel!"
)
for /f "tokens=1 delims==" %%a in ('set sst.boot') do if /I "%%~a" neq "sst.boot.logoX" if /I "%%~a" neq "sst.boot.logoY" set "%%a="
cd "%~dp0"
call sstoskrnl.bat < "temp\kernelPipe" > "temp\kernelOut" 2>"temp\kernelErr" 3> "temp\DWM-!sst.localtemp!"

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
	set "buffer=%\e%[!sst.boot.logoY!;!sst.boot.logoX!H!spr.[bootlogo.spr]!"
	if "%~3"=="/nologo" set buffer=
	echo=!buffer!%\e%[!sst.boot.msgY!;!sst.boot.msgX!H%\e%[2K!sst.boot.msg!%\e%[B%\e%[!sst.boot.submsgX!G%\e%[2K!sst.boot.submsg!%\e%[H

exit /b
:memoryDump
pushd "!sst.dir!\temp" || exit /b !errorlevel!
set > memoryDump
for %%A in (memoryDump) do (
	popd
	exit /b %%~zA
)
exit /b %errorlevel%

REM == Modules ==
:loadresourcepack
if not exist "!sst.dir!\resourcepacks\%~1" exit /b 1
for /f "delims=" %%a in ('dir /b /a:-D "!sst.dir!\resourcepacks\%~1\sprites\*.spr" 2^>nul') do call :loadsprites "!sst.dir!\resourcepacks\%~1\sprites\%%~a" %%~a
for /f "delims=" %%a in ('dir /b /a:-D "!sst.dir!\resourcepacks\%~1\sounds\*.*" 2^>nul') do set "asset[\sounds\%%~a]=!sst.dir!\resourcepacks\%~1\sounds\%%~a"
set /a "sst.boot.logoX=(sys.modeW-spr.[bootlogo.spr].W)/2+1", "sst.boot.logoY=(sys.modeH-spr.[bootlogo.spr].H)/2+1"
echo=%\e%[H%\e%[48;2;0;0;0m%\e%[38;2;255;255;255m%\e%[2J
if exist "!sst.dir!\resourcepacks\%~1\keyboard_init.bat" call "!sst.dir!\resourcepacks\%~1\keyboard_init.bat"
if /I "!sst.noguiboot!"=="True" (
	set spr.[bootlogo.spr]=
	set spr.[bootlogo.spr]W=
	set spr.[bootlogo.spr]H=
)
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
if exist temp (
	echo=¤EXIT>> "temp\bootStatus-!sst.localtemp!"
)
set "halt.text=%~2"
set halt.text=!halt.text:\n=","!
set "halt.pausemsg= Press any key to exit. . . "
set "halt.tracemsg= At %~1: "
for /l %%. in (0 1 100000) do rem
for /l %%a in (64 -1 0) do (
	<nul set /p "=%\e%[2;3H%\e%[48;2;255;0;0m%\e%[38;2;255;255;255m%\e%[?25l Execution halted %\e%[4;3H!halt.tracemsg:~%%a!"
	for /l %%. in (0 1 10000) do rem
	for %%b in ("!halt.text!") do (
		set "halt.line=%%~b "
		<nul set /p "=%\e%[E%\e%[3G     !halt.line:~%%a!%\e%7"
	)
	<nul set /p "=%\e%[999;3H%\e%[A!halt.pausemsg:~%%a!%\e%8"
)
call :memorydump
pause>nul<con
exit 0
:clearEnv
for /f "tokens=1 delims==" %%a in ('set') do for /f "tokens=1 delims=._" %%c in ("%%~a") do (
	set "unload=True"
	for %%b in (
		ComSpec SystemRoot SystemDrive temp windir
		ssvm sst sstfs sys
		\n \e
		PROCESSOR
		NUMBER
		USERNAME
	) do if /i "%%~c"=="%%~b" set "unload=False"
	if "!unload!"=="True" set "%%a="
)
set PATHEXT=.COM;.EXE;.BAT
set "PATH=!windir!\system32;!windir!;!sst.dir!\systemb"
set unload=
exit /b 0
:loadSettings
if not exist "!sst.dir!\settings.dat" call :halt "%~nx0:loadSettings" "Failed to load 'settings.dat':\n  File not found."

set "sys.loginTheme=metroTyper"
set "sst.boot.fadeout=255"
for /f "usebackq tokens=1* delims==" %%a in ("!sst.dir!\settings.dat") do set "sys.%%~a=%%~b"
if defined sys.boot.fadeout (
	set sst.boot.fadeout=!sys.boot.fadeout!
	set sys.boot.fadeout=
)

set "sst.processes= "
set "sst.processes.paused= "

set dwm.scene=%\e%[H%\e%[0m%\e%[48;2;;;;38;5;231m%\e%[2JShivtanium OS !sys.tag! !sys.ver! !sys.subvinfo!
set dwm.sceneBGcolor=2;;;
set dwm.BGcolor=5;231
set dwm.FGcolor=5;16
set dwm.TIcolor=5;12
set dwm.TTcolor=5;231
set dwm.NIcolor=5;4
set dwm.NTcolor=5;7
set dwm.CBUI=%\e%[38;5;231m%\e%[48;2;0;192;192m - %\e%[48;2;0;255;255m □ %\e%[48;2;255;0;0m × 

cd "%~dp0" > nul 2>&1 || exit /b
set "sys.dir=!cd!"

for %%a in (
	"PROCESSOR_ARCHITECTURE=sys.CPU.architecture"
	"PROCESSOR_IDENTIFIER=sys.CPU.identifier"
	"PROCESSOR_LEVEL=sys.CPU.level"
	"PROCESSOR_REVISION=sys.CPU.revision"
	"NUMBER_OF_PROCESSORS=sys.CPU.count"
	"FIRMWARE_TYPE=sys.FIRMWARE_TYPE"
	"USERNAME=sys.host.USERNAME"
) do for /f "tokens=1,2 delims==" %%b in ("%%~a") do (
	set "%%~c=!%%~b!"
	set "%%~b="
	if "!%%~c!"=="" call :halt "%~nx0:loadSettings" "Failed to define variable translation:\n%%~c = %%~b"
)

set /a "dwm.tps=100", "dwm.tdt=100/dwm.tps", "sst.proccount=0", "sys.click=0"
exit /b 0
:injectDLLs
cd "!sst.dir!"
set "noResize=1"
if not exist core\getInput64.dll call :halt "%~nx0:injectDLLs" "Missing File: core\getInput64.dll"
rundll32.exe core\getInput64.dll,inject|| call :halt "%~nx0:injectDLLs" "Failed to inject getInput64.dll\nErrorlevel: !errorlevel!"
cmd /c rem
if not defined getInputInitialized call :halt "%~nx0:injectDLLs" "Failed to inject getInput64.dll: Unknown error.\nErrorlevel: %errorlevel%"
exit /b
:startServices
rem if exist "!asset[\sounds\boot.mp3]!" start "<Shivtanium startup sound handeler> (ignore this)" /min cscript.exe //b core\playsound.vbs "!asset[\sounds\boot.mp3]!"
copy nul "temp\DWM-!sst.localtemp!" > nul
copy nul "temp\DWMResp-!sst.localtemp!" > nul
start /b cmd /c dwm.bat < "temp\DWM-!sst.localtemp!" 3> "temp\DWMResp-!sst.localtemp!"
exit /b 0
:waitForBootServices
cmd /c "%~f0" :waitForBootServices
exit /b
:waitForBootServices.service
set "services=cfmsf updateCheckSvc fadeout"
for /l %%. in () do (
	for %%F in (!services!) do if exist "!sst.dir!\temp\pf-%%~F" (
		set svcIn=
		set /p svcIn=<"!sst.dir!\temp\pf-%%~F"
		if defined svcIn (
			call :halt "service %%~F" "!svcIn!"
		)
		del "!sst.dir!\temp\pf-%%~F" > nul
		set new_services=
		for %%a in (!services!) do if "%%~a" neq "%%~F" set new_services=!new_services! %%a
		if not defined new_services exit 0
		set "services=!new_services!"
		set new_services=
		if "!services!" == "!services:fadeout=!" call :startup.submsg "Waiting for startup tasks:" "!services!" /nologo
	)
)
:checkCompat
if "!sys.CPU.architecture!" neq "AMD64" call :halt "%~nx0:checkCompat" "Incompatible processor architecture: !sys.CPU.architecture!\nShivtanium requires processor architecture AMD64/x86_64"
exit /b
