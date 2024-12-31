@echo off
setlocal enabledelayedexpansion
for /f %%a in ('echo prompt $E^| cmd') do set "\e=%%a"

set "ssvm.args=%~1"
if "!ssvm.args:~0,1!" neq ":" goto start
	call %*
	exit /b
:start
echo=Starting batch environment. . .
echo=: Applying configuration with reg
reg add "HKCU\Console\SSVM Launcher" /v FontSize /t reg_dword /d 1048576 /f
reg add "HKCU\Console\SSVM Launcher" /v FaceName /t reg_sz /d "MxPlus IBM VGA 8x16" /f
reg add "HKCU\Console\SSVM Launcher" /v QuickEdit /t reg_dword /d 0 /f
echo=: Starting console host

set "ssvm.temp.con=Starting console host%\e%[S%\e%[999E: Applying configuration with reg%\e%[S%\e%[999E: Starting console host%\e%[S%\e%[999E: Exitting launcher session"
start "SSVM Launcher" conhost.exe "!ComSpec!" /c "%~f0" :init %*
echo=: Exitting launcher session
exit /b
:init
reg delete "HKCU\Console\SSVM Launcher" /f >nul
set "ssvm.args=%~1"
set ssvm.ver=3.1.0
title SSVM !ssvm.ver!
set "ssvm.temp.con=!ssvm.temp.con!%\e%[S%\e%[999ELoading SSVM settings. . .%\e%[S%\e%[999E: Changing code page"
<nul set /p "=%\e%[999;H%\e%[48;2;0;0;0;38;2;255;255;255m%\e%[?25l%\e%[2J!ssvm.temp.con!"
chcp 65001>nul 2>&1 || (
	< nul set /p "=%\e%[2S%\e%[999E  Your system doesn't support UTF-8 [Codepage 65001]%\e%[2S%\e%[999E  The system cannot continue. Press any key to exit. . .%\e%[?25h%\e%[S%\e%[999E"
	pause > nul
	exit /b
) 2>nul
if not exist "%~dp0ssvm.cww" (
	echo(# SSVM Settings #> "%~dp0ssvm.cww:
	for %%a in (
		"mode=128,32	# The default text mode"
	) do echo(%%~a>> "%~dp0ssvm.cww"
)
for /f %%a in ('echo prompt $E^| cmd') do set "\e=%%a"

for %%a in ("mode=128,32" "temp.fadein=0") do set "ssvm.%%~a"
for /f "skip=1 eol=# tokens=1,2 delims==#	 " %%a in ('type "%~dp0ssvm.cww"') do set "ssvm.%%~a=%%~b"
set "ssvm.temp.con=!ssvm.temp.con!%\e%[S%\e%[999E: Changing mode"
<nul set /p "=%\e%[999;H%\e%[2J!ssvm.temp.con!"
for /f "tokens=1,2 delims=," %%x in ("!ssvm.mode!") do set /a "ssvm.modeW=%%~x", "ssvm.modeH=%%~y" 2>nul || (
	< nul set /p "=%\e%[2S%\e%[999E  The SSVM configuration is invalid. Try deleting the 'ssvm.cww' file to reset it.%\e%[2S%\e%[999E  The system cannot continue. Press any key to exit. . .%\e%[?25h%\e%[S%\e%[999E"
	pause>nul
	exit /b
)
mode !ssvm.modeW!,!ssvm.modeH!
set "ssvm.temp.con=!ssvm.temp.con!%\e%[S%\e%[999E: Loading sprites"
<nul set /p "=%\e%[999;H%\e%[48;2;0;0;0;38;2;127;127;127m%\e%[?25l%\e%[2J!ssvm.temp.con!"
call :loadsprites "%~dp0SSVM.sprite"
cd "%~dp0" || exit /b
set "ssvm.temp.con=!ssvm.temp.con!%\e%[S%\e%[999E: Injecting getInput DLL"
<nul set /p "=%\e%[999;H%\e%[2J!ssvm.temp.con!"
set GetInputPath=getInput64.dll
if not exist "!GetInputPath!" (
	if not exist "C\Shivtanium\core\!GetInputPath!" goto skipGetInput
	set "getInputPath=C\Shivtanium\core\!GetInputPath!"
)
rundll32.exe !getInputPath!,inject >nul 2>&1
set "ssvm.temp.con=!ssvm.temp.con!%\e%[S%\e%[999EFinished."
<nul set /p "=%\e%[999;H%\e%[48;2;0;0;0;38;2;127;127;127m%\e%[?25l%\e%[2J!ssvm.temp.con!%\e%[!ssvm.modeH!;!ssvm.modeW!H%\e%[27DPress ESC to enter boot menu%\e%[38;2;0;0;0m"
:skipGetInput
set getInputPath=
set /a "ssvm.boot.logoX=(!SSVM.modeW!-!spr.[SSVM].W!)/2+1", "ssvm.boot.logoY=(!SSVM.modeH!-!spr.[SSVM].H!)/2+2"
for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100", "t2=t1", "global.frameCount=(global.frameCount + 1) %% 0x7FFFFFFF", "fpsFrames+=1"
:bootanim.1

	if "!keysPressed!"=="-27-" goto bootmenu
	< nul set /p "=%\e%[38;2;!ssvm.temp.fadein!;!ssvm.temp.fadein!;!ssvm.temp.fadein!m%\e%[%ssvm.boot.logoY%;%ssvm.boot.logoX%H!spr.[SSVM]!"
	for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100", "deltaTime=(t1 - t2)", "$TT+=deltaTime", "timer100cs+=deltaTime", "$sec=$TT / 100 %% 60", "$min=$TT / 100 / 60 %% 60", "t2=t1", "global.frameCount=(global.frameCount + 1) %% 0x7FFFFFFF", "fpsFrames+=1", "ssvm.temp.fadein+=deltaTime*4"
	if !timer100cs! GEQ 100 (
		set /a "timer100cs-=100,fps=fpsFrames,fpsFrames=0"
		if !timer100cs! GEQ 100 set /a timer100cs=0
	)
	if "^!$sec:~1^!" equ "" set "$sec=0^!$sec^!"%\n%
	title Time: !$min!:!$sec! FPS:!fps! FrameTime: !deltaTime!cs Frames:!global.frameCount! totalTime:!$TT!
if !ssvm.temp.fadein! lss 255 goto bootanim.1
set ssvm.temp.fadein=

for /f "delims=" %%a in ('dir /b /a:d "%~dp0"') do if /I "%%~a" neq "A" if exist "%%~a\ssvm.cww" (
	call :boot "%~dp0%%a"
	if "!ssvm.exitcode!" == "27" goto init
	exit 0
)

:bootmenu
title SSVM !ssvm.ver! boot menu
cd "%~dp0" || exit /b
set ssvm.temp.fadein=
set ssvm.boot.entries=
set ssvm.boot.mpW=64
set ssvm.boot.mpH=1
set counter=0
set "addorsub=+"
for /f "delims=" %%a in ('dir /b /a:d') do (
	set ssvm.BOOT=
	set ssvm.BEFI=
	if exist "%%~a\SSVM.cww" (
		for /f "usebackq tokens=1,2 delims==" %%b in ("%%~a\SSVM.cww") do (
			if "%%~b"=="BOOT" (
				set "ssvm.BOOT=%%~c"
			) else if "%%~b"=="BEFI" set /a "ssvm.BEFI=%%~c">nul 2>nul
		)
		
		set "temp.id=%%~a¤Unknown¤!ssvm.BEFI!"
		if defined ssvm.BOOT (
			set "temp.id=%%~a¤!ssvm.boot!¤!ssvm.BEFI!"
		)
		set ssvm.boot.entries=!ssvm.boot.entries! "!temp.id!"
		set /a ssvm.boot.mpH+=1
	)
)
for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t2=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000) %% 100"

set /a "ssvm.boot.mpX=(ssvm.modeW-ssvm.boot.mpW)/2+1", "ssvm.boot.mpY=(ssvm.modeH-ssvm.boot.mpH)/2+1", "ssvm.boot.mpBX=ssvm.boot.mpX+ssvm.boot.mpW-1", "ssvm.boot.mpBY=ssvm.boot.mpY+ssvm.boot.mpH-1"
(for /l %%# in () do (
	set ssvm.boot.bg=%\e%[0m%\e%[H%\e%[38;5;231;48;2;;63;255m%\e%[2K SSVM !ssvm.ver! boot menu%\e%[38;5;231m
	for /l %%y in (2 1 !ssvm.modeH!) do (
		set /a "temp.color=%%y*160/!ssvm.modeH!+!counter!/2"
		set "ssvm.boot.bg=!ssvm.boot.bg!%\e%[48;2;;;!temp.color!m%\e%[E%\e%[2K"
	)
	for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000) %% 100", "deltaTime=(t1 - t2)", "counter!addorsub!=deltaTime", "t2=t1"
	if !counter! gtr 200 (
		set "addorsub=-"
		set counter=200
	)
	if !counter! lss 0 (
		set "addorsub=+"
		set counter=0
	)
	set ssvm.boot.mouseX=!mouseXpos!
	set ssvm.boot.mouseY=!mouseYpos!
	
	set "ssvm.boot.bg=!ssvm.boot.bg!%\e%[38;5;231;48;2;;63;255m%\e%[!ssvm.boot.mpY!;!ssvm.boot.mpX!H%\e%[!ssvm.boot.mpW!X"
	set ssvm.temp.counter=!ssvm.boot.mpY!
	if !deltaTime! geq 1 (
		for %%a in (!ssvm.boot.entries!) do for /f "tokens=1-3 delims=¤" %%1 in ("%%~a") do (
			set /a ssvm.temp.counter+=1
			set temp.prefix=
			if "%%~3"=="" set "temp.prefix=[legacy] "
			if "!ssvm.boot.mouseY!"=="!ssvm.temp.counter!" (
				set "ssvm.boot.bg=!ssvm.boot.bg!%\e%[38;5;231;48;2;63;127;255m%\e%[B%\e%[!ssvm.boot.mpX!G%\e%[!ssvm.boot.mpW!X  !temp.prefix!%%~1: %%~2"
				if "!click!"=="1" (
					<&2 set /p "=%\e%[38;2;255;255;255;48;2;;;m%\e%[2J%\e%[!ssvm.boot.logoY!;!ssvm.boot.logoX!H!spr.[SSVM]!%\e%[?25l"
					call :boot "%%~1"
					cmd /c mode !ssvm.modeW!,!ssvm.modeH!
					<&2 set /p "=%\e%[0m%\e%[H%\e%[38;5;231;48;2;;63;255m%\e%[2K SSVM !ssvm.ver! boot menu%\e%[E%\e%[38;5;231;48;5;12m%\e%[0J%\e%[?25l"
				)
			) else (
				set "ssvm.boot.bg=!ssvm.boot.bg!%\e%[38;5;231;48;2;;63;255m%\e%[B%\e%[!ssvm.boot.mpX!G%\e%[!ssvm.boot.mpW!X  !temp.prefix!%%~1: %%~2"
			)
		)
		<&2 set /p "=!ssvm.boot.bg!%\e%[38;5;231;48;2;;63;255m%\e%[B%\e%[!ssvm.boot.mpX!G%\e%[!ssvm.boot.mpW!X"
	)
)) 2<nul
exit /b
:loadsprites
if not exist "%~1" exit 31232
for /f "delims=" %%a in ('type "%~1"') do (
	for /f "tokens=1,2,3* delims=;" %%b in ("%%~a") do if /I "%%~b" equ "Sprite_Meta" (
		set /a "spr.[%%~e].W=%%~c", "spr.[%%~e].H=%%~d"
		set "spr=%%~e"
	) else set "spr.[!spr!]=%%~a"
)
exit /b
:boot
title SSVM !ssvm.ver! ^| Booting from "%~1"
<nul set /p "=%\e%[0m%\e%[?25h"
for /f "delims==" %%a in ('set ssvm.temp 2^>nul') do set "%%a="
set ssvm.BEFI=
if exist "%~1\SSVM.cww" for /f "tokens=1,2 delims==" %%a in ('type "%~1\SSVM.cww"') do if "%%~a"=="BEFI" set "ssvm.BEFI=%%~b"
cd "%~dp0"
cd "%~1"
set ssvm.temp.check=Failed
for %%e in (BAT CMD VBS SSTFS) do if exist "autorun.%%~e" set ssvm.temp.check=Passed
if "!ssvm.temp.check!" == "Failed" (
	set /p "=%\e%[38;2;255;255;255;48;2;;;m%\e%[2J%\e%[!ssvm.boot.logoY!;!ssvm.boot.logoX!H!spr.[SSVM]!%\e%[?25h%\e%[3;3HAutorun file was not found.%\e%[5;3HPress any key to exit. . ."
	if not defined ssvm.BEFI set /p =%\e%[HBooting from "%~1"%\e%[5;30H
	pause < con > nul
	exit /b
) < nul
if defined ssvm.BEFI (
	setlocal enabledelayedexpansion
	<nul set /p "=%\e%[48;2;0;0;0;38;2;255;255;255m"
	call autorun "!ssvm.args!"
	endlocal
	set ssvm.exitcode=!errorlevel!
) else (
	< nul set /p =%\e%[38;2;255;255;255;48;2;0;0;0m%\e%[HBooting from "%~1"
	for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t2=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000)", ssvm.temp.fadein=255
	call :bootanim.fadeout
	<nul set /p "=%\e%[48;2;0;0;0;38;2;255;255;255m"
	call cmd /c autorun "!ssvm.args!"
	set ssvm.exitcode=!errorlevel!
)
cd "%~dp0"
exit /b !ssvm.exitcode!
:bootanim.fadeout
	< nul set /p "=%\e%[38;2;!ssvm.temp.fadein!;!ssvm.temp.fadein!;!ssvm.temp.fadein!m%\e%[%ssvm.boot.logoY%;%ssvm.boot.logoX%H!spr.[SSVM]!%\e%[%ssvm.modeH%;%ssvm.modeW%H%\e%[27DPress ESC to enter boot menu"
	for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000)", "deltaTime=(t1 - t2)", "$TT+=deltaTime", "timer100cs+=deltaTime", "$sec=$TT / 100 %% 60", "$min=$TT / 100 / 60 %% 60", "t2=t1", "global.frameCount=(global.frameCount + 1) %% 0x7FFFFFFF", "fpsFrames+=1", "ssvm.temp.fadein-=deltaTime*4"
	if !timer100cs! GEQ 100 (
		set /a "timer100cs-=100,fps=fpsFrames,fpsFrames=0"
		if !timer100cs! GEQ 100 set /a timer100cs=0
	)
	if "^!$sec:~1^!" equ "" set "$sec=0^!$sec^!"%\n%
	title Time: !$min!:!$sec! FPS:!fps! FrameTime: !deltaTime!cs Frames:!global.frameCount! totalTime:!$TT!
if !ssvm.temp.fadein! gtr 0 goto bootanim.fadeout
exit /b
