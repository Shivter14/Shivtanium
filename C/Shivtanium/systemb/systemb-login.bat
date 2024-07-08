@echo off & setlocal enableDelayedExpansion
if "%~1"=="/init" exit /b 0
if not defined PID (
	echo=This program requires to be run in the Shivtanium OS Kernel / userSpace
	set /p "=Press any key to exit. . ."
	exit /b 0
)
set /a "win[%PID%.systemb_login]W=64, systemb.login.tW=win[%PID%.systemb_login]W-4, win[%PID%.systemb_login]H=8, win[%PID%.systemb_login]X=(sys.modeW-win[%PID%.systemb_login]W)/2, win[%PID%.systemb_login]Y=(sys.modeH-win[%PID%.systemb_login]H)/2"
echo=¤CTRL	APPLYTHEME	metroTyper
echo=¤CW	!PID!.systemb_login	!win[%PID%.systemb_login]X!	!win[%PID%.systemb_login]Y!	!win[%PID%.systemb_login]W!	!win[%PID%.systemb_login]H!	Shivtanium Login
echo=¤MW	!PID!.systemb_login	l2=  Welcome to Shivtanium.	l4=  Enter your username:	o6=%\e%[2C%\e%[!systemb.login.tW!X
>>"!sst.dir!\temp\kernelPipe" echo=registerWindow	!PID!	!PID!.systemb_login	!win[%PID%.systemb_login]X!	!win[%PID%.systemb_login]Y!	!win[%PID%.systemb_login]W!	!win[%PID%.systemb_login]H!
set "systemb.login.username= "
for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t2=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000)"
set timer.50cs=50
for /l %%# in () do (
	for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000), deltaTime=(t1 - t2), t2=t1, timer.50cs+=deltaTime"
	if !timer.50cs! geq 50 (
		echo=¤OV	%\e%[999;1H%\e%[48;2;0;31;63;38;2;255;255;255m%\e%[2K !focusedWindow!%\e%[999C%\e%[32D!date! !time!
		set /a "timer.50cs%%=50"
	)
	set kernelOut=
	set "sys.keysRN= "
	set /p kernelOut=
	if defined kernelOut (
		if "!kernelOut:~0,5!"=="mouse" (
			set "sys.!kernelOut!" > nul 2>&1
		) else if "!kernelOut:~0,12!"=="keysPressed=" (
			set "sys.keys=!kernelOut:~12!"
		) else if "!kernelOut:~0,14!"=="keysPressedRN=" (if "!focusedWindow!"=="!PID!.systemb_login" (
			set "sys.keysRN=!kernelOut:~14!"
			
			for %%k in (!sys.keysRN!) do (
				set "char=!charset_L:~%%k,1!"
				if "!sys.keys!" neq "!sys.keys:-16-=!" set "char=!charset_U:~%%k,1!"
				if "!sys.keys!" neq "!sys.keys:-17-=!" set "char=!charset_A:~%%k,1!"
				if "!char!"==" " (
					if "%%~k" neq "32" set char=
					if "%%~k"=="8" (
						if "!systemb.login.username!" neq " " set "systemb.login.username=!systemb.login.username:~0,-1!"
						echo=¤MW	!PID!.systemb_login	o6=%\e%[2C%\e%[!systemb.login.tW!X!systemb.login.username:~-60!
					)
				)
				if defined char (
					set "systemb.login.username=!systemb.login.username!!char!"
					echo=¤MW	!PID!.systemb_login	o6=%\e%[2C%\e%[!systemb.login.tW!X!systemb.login.username:~-60!
				)
			)
			if "!sys.keysRN!" neq "!sys.keysRN: 13 =!" (
				echo=createProcess	!PID!	systemb-userinit.bat --username "!systemb.login.username:~1!"
				echo=exitProcess	!PID!
				exit 0
			) >> "!sst.dir!\temp\kernelPipe"
		)) else if "!kernelOut!"=="exit" (
			exit 0
		) else if "!kernelOut!"=="exitProcess=!PID!" (
			exit 0
		) else set "!kernelOut!" >nul 2>&1
	)
)
