@echo off & setlocal enableDelayedExpansion
if not defined PID (
	echo=This program requires to be run in the Shivtanium OS Kernel / userSpace
	set /p "=Press any key to exit. . ."
	exit /b 0
)
set /a PID=PID
set /a "win[%PID%.systemb_login]W=64, closeButtonX=win[%PID%.systemb_login]W-3, systemb.login.tW=win[%PID%.systemb_login]W-4, win[%PID%.systemb_login]H=8, win[%PID%.systemb_login]X=(sys.modeW-win[%PID%.systemb_login]W)/2, win[%PID%.systemb_login]Y=(sys.modeH-win[%PID%.systemb_login]H)/2"
if defined sys.loginBGTheme echo=¤CTRL	APPLYTHEME	!sys.loginBGTheme!
echo=¤CW	!PID!.systemb_login	!win[%PID%.systemb_login]X!	!win[%PID%.systemb_login]Y!	!win[%PID%.systemb_login]W!	!win[%PID%.systemb_login]H!	Shivtanium Login	!sys.loginTheme!
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
		if "!kernelOut:~0,12!"=="keysPressed=" (
			set "sys.keys=!kernelOut:~12!"
		) else if "!kernelOut:~0,14!;!focusedWindow!"=="keysPressedRN=;!PID!.systemb_login" (
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
					) else if "%%~k"=="27" (
						set "systemb.login.username= "
						echo=¤MW	!PID!.systemb_login	o6=%\e%[2C%\e%[!systemb.login.tW!X
					)
				)
				if defined char (
					set "systemb.login.username=!systemb.login.username!!char!"
					echo=¤MW	!PID!.systemb_login	o6=%\e%[2C%\e%[!systemb.login.tW!X!systemb.login.username:~-60!
				)
			)
			if "!sys.keysRN!" neq "!sys.keysRN: 13 =!" (	
				set "userprofile=!systemb.login.username:~1!"
				set "usernameCheck=!userprofile! "
				set err=
				if not defined userprofile (
					set "err=You must enter a username"
				) else (
					for %%a in (
						- _ a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9
					) do set "usernameCheck=!usernameCheck:%%a=!"
					if "!usernameCheck!" neq " " set "err=Invalid characters: %\e%[7m !usernameCheck:~0,32!%\e%[27m"
				)
				(
					if defined err (
						echo=createProcess	0	systemb-dialog.bat !win[%PID%.systemb_login]X!+3 !win[%PID%.systemb_login]Y!+1 !win[%PID%.systemb_login]W!-6 6 "Invalid username	noCBUI" "l2=  The username you entered is invalid;	l3=  !err!" w-9 h-2 7 " Close "
					) else (
						echo=createProcess	0	systemb-userinit.bat --username "!systemb.login.username:~1!"
						echo=exitProcess	!PID!
						exit 0
					)
				) >> "!sst.dir!\temp\kernelPipe"
			)
		) else if "!kernelOut!"=="click=1" (
			set /a "relativeMouseX=mouseXpos - win[!PID!.systemb_login]X, relativeMouseY=mouseYpos - win[!PID!.systemb_login]Y"
			if "!relativeMouseY!"=="0" if !relativeMouseX! geq !closeButtonX! ((
				echo=exitProcessTree	!PID!
				echo=exitProcess	!PID!
				echo=powerState	shutdown
			)) >> "!sst.dir!\temp\kernelPipe"
		) else if "!kernelOut!"=="exit" (
			exit 0
		) else if "!kernelOut!"=="exitProcess=!PID!" (
			exit 0
		) else set "!kernelOut!" >nul 2>&1
	)
)
