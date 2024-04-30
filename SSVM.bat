@echo off
setlocal enabledelayedexpansion
for /f %%a in ('echo prompt $E^| cmd') do set "\e=%%a"
set "ssvm.args=%~1"
:init
<nul set /p "=%\e%[1;1H%\e%[48;2;0;0;0m%\e%[38;2;255;255;255m%\e%[?25l%\e%[J"
chcp 65001>nul || (
	< nul set /p "=%\e%[2;3HYour computer doesn't support UTF-8 [Codepage 65001]%\e%[4;3HThe system cannot continue. Press any key to exit. . .%\e%[?25h"
	pause > nul
	exit /b
) 2>nul
set ssvm.ver=3.0.0
title SSVM %ssvm.ver%
if not exist "%~dp0ssvm.cww" (
	echo(# SSVM Settings #> "%~dp0ssvm.cww:
	for %%a in (
		"mode=128,32	# The default text mode"
	) do echo(%%~a>> "%~dp0ssvm.cww"
)
for /f %%a in ('echo prompt $E^| cmd') do set "\e=%%a"

for %%a in ("mode=128,32" "temp.fadein=0") do set "ssvm.%%~a"
for /f "skip=1 eol=# tokens=1,2 delims==#	 " %%a in ('type "%~dp0ssvm.cww"') do set "ssvm.%%~a=%%~b"

for /f "tokens=1,2 delims=," %%x in ("!ssvm.mode!") do set /a "ssvm.modeW=%%~x", "ssvm.modeH=%%~y" 2>nul || (
	< nul set /p "=%\e%[2;3HThe SSVM configuration is invalid. Try deleting the 'ssvm.cww' file to reset it.%\e%[4;3HThe system cannot continue. Press any key to exit. . ."
	pause>nul
	exit /b
)
mode !ssvm.modeW!,!ssvm.modeH!
<nul set /p "=%\e%[1;1H%\e%[48;2;0;0;0m%\e%[38;2;255;255;255m%\e%[?25l%\e%[J%\e%[!ssvm.modeH!;!ssvm.modeW!H%\e%[27DPress ESC to enter boot menu%\e%[38;2;0;0;0m"
call :loadsprites "%~dp0SSVM.sprite"
set /a "ssvm.boot.logoX=(!SSVM.modeW!-!spr.[SSVM].W!)/2+1", "ssvm.boot.logoY=(!SSVM.modeH!-!spr.[SSVM].H!)/2+2"
for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000)", "t2=t1", "global.frameCount=(global.frameCount + 1) %% 0x7FFFFFFF", "fpsFrames+=1"
:bootanim.1

	< nul set /p "=%\e%[38;2;!ssvm.temp.fadein!;!ssvm.temp.fadein!;!ssvm.temp.fadein!m%\e%[%ssvm.boot.logoY%;%ssvm.boot.logoX%H!spr.[SSVM]!"
	for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000)", "deltaTime=(t1 - t2)", "$TT+=deltaTime", "timer100cs+=deltaTime", "$sec=$TT / 100 %% 60", "$min=$TT / 100 / 60 %% 60", "t2=t1", "global.frameCount=(global.frameCount + 1) %% 0x7FFFFFFF", "fpsFrames+=1", "ssvm.temp.fadein+=deltaTime*3"
	if !timer100cs! GEQ 100 (
		set /a "timer100cs-=100,fps=fpsFrames,fpsFrames=0"
		if !timer100cs! GEQ 100 set /a timer100cs=0
	)
	if "^!$sec:~1^!" equ "" set "$sec=0^!$sec^!"%\n%
	title Time: !$min!:!$sec! FPS:!fps! FrameTime: !deltaTime!cs Frames:!global.frameCount! totalTime:!$TT!
if !ssvm.temp.fadein! lss 255 goto bootanim.1
set ssvm.temp.fadein=

for /f "delims=" %%a in ('dir /b /a:d "%~dp0"') do if /I "%%~a" neq "A" (
	call :boot "%~dp0%%a"
	if not "!ssvm.exitcode!" == "27" goto init
	exit /b
)
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
set ssvm.BEFI=
if exist "%~1\SSVM.cww" for /f "tokens=1,2 delims==" %%a in ('type "%~1\SSVM.cww"') do if "%%~a"=="BEFI" set "ssvm.BEFI=%%~b"
cd "%~1"
if defined ssvm.BEFI (
	setlocal enabledelayedexpansion
	call autorun "!ssvm.args!"
	endlocal
	set ssvm.exitcode=!errorlevel!
) else (
	< nul set /p =%\e%[38;2;255;255;255m%\e%[48;2;0;0;0m%\e%[HBooting from "%~1"
	call :bootanim.fadeout
	call cmd /V:ON /c autorun "!ssvm.args!"
	set ssvm.exitcode=!errorlevel!
)
exit /b !ssvm.exitcode!
:bootanim.fadeout
	< nul set /p "=%\e%[38;2;!ssvm.temp.fadein!;!ssvm.temp.fadein!;!ssvm.temp.fadein!m%\e%[%ssvm.boot.logoY%;%ssvm.boot.logoX%H!spr.[SSVM]!%\e%[%ssvm.modeH%;%ssvm.modeW%H%\e%[27DPress ESC to enter boot menu"
	for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000)", "deltaTime=(t1 - t2)", "$TT+=deltaTime", "timer100cs+=deltaTime", "$sec=$TT / 100 %% 60", "$min=$TT / 100 / 60 %% 60", "t2=t1", "global.frameCount=(global.frameCount + 1) %% 0x7FFFFFFF", "fpsFrames+=1", "ssvm.temp.fadein-=deltaTime*3"
	if !timer100cs! GEQ 100 (
		set /a "timer100cs-=100,fps=fpsFrames,fpsFrames=0"
		if !timer100cs! GEQ 100 set /a timer100cs=0
	)
	if "^!$sec:~1^!" equ "" set "$sec=0^!$sec^!"%\n%
	title Time: !$min!:!$sec! FPS:!fps! FrameTime: !deltaTime!cs Frames:!global.frameCount! totalTime:!$TT!
if !ssvm.temp.fadein! gtr 0 goto bootanim.fadeout
exit /b