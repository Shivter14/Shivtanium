@echo off & setlocal enableDelayedExpansion
if not defined PID (
	echo=This program requires to be run in the Shivtanium Kernel.
	<nul set /p "=Press any key to exit. . ."
	pause>nul
	exit /b 1
)
set /a PID=PID
set /a "nextButtonBX=(nextButtonX=(win[!PID!.oobe]W=64)-8)+5, contentH=(win[!PID!.oobe]H=16)-2, win[!PID!.oobe]X=(sys.modeW - win[!PID!.oobe]W) / 2, win[!PID!.oobe]Y=(sys.modeH - win[!PID!.oobe]H) / 2, inputC=(inputW=win[!PID!.oobe]W-6)-1"
echo=¤CTRL	APPLYTHEME	lo-fi
echo=¤CW	!PID!.oobe	!win[%PID%.oobe]X!	!win[%PID%.oobe]Y!	!win[%PID%.oobe]W!	!win[%PID%.oobe]H!	 	lo-fi noCBUI
>>"!sst.dir!\temp\kernelPipe" echo=registerWindow	!PID!	!PID!.oobe	!win[%PID%.oobe]X!	!win[%PID%.oobe]Y!	!win[%PID%.oobe]W!	!win[%PID%.oobe]H!
if exist "!asset[\sounds\windows-xp-welcome-music-remix.mp3]!" start /b "Shivtanium sound handeler (ignore this)" /min cscript.exe //b core\playsound.vbs "!asset[\sounds\windows-xp-welcome-music-remix.mp3]!"
:start // Initial screen

set "s2=▓▓▓▒▒░░                                             ░░▒▒▓▓"
set "s3=▓▓▒▒░░   ▄▄▄ ▄    ▄      ▄            ▄            ░░▒▒▓▓▓"
set "s4=▓▓▓▒▒░░ █    █          ▄█▄                         ░░▒▒▓▓"
set "s5=▓▓▒▒░░   ▀▀▄ █▀▀▄ █ █ █  █  ▄▀▀▄ █▀▀▄ █ █  █ █▀▄▀▄ ░░▒▒▓▓▓"
set "s6=▓▓▓▒▒░░ ▄▄▄▀ █  █ █ ▀█▀  █  ▀▄▄█ █  █ █ ▀▄▄█ █ █ █  ░░▒▒▓▓"
set "s7=▓▓▒▒░░          ▀         ▀         ▀        ▀     ░░▒▒▓▓▓"
set "s8=▓▓▓▒▒░░                                             ░░▒▒▓▓"

for /l %%a in (3 4 51) do (
	set /a "off=27-%%a/2"
	echo=¤MW	!PID!.oobe^
	l2=%\e%[!off!C%\e%[7m!s2:~0,%%a!!s2:~-7!%\e%[27m^
	l3=%\e%[!off!C%\e%[7m!s3:~0,%%a!!s3:~-7!%\e%[27m^
	l4=%\e%[!off!C%\e%[7m!s4:~0,%%a!!s4:~-7!%\e%[27m^
	l5=%\e%[!off!C%\e%[7m!s5:~0,%%a!!s5:~-7!%\e%[27m^
	l6=%\e%[!off!C%\e%[7m!s6:~0,%%a!!s6:~-7!%\e%[27m^
	l7=%\e%[!off!C%\e%[7m!s7:~0,%%a!!s7:~-7!%\e%[27m^
	l8=%\e%[!off!C%\e%[7m!s8:~0,%%a!!s8:~-7!%\e%[27m
)
set last=!contentH!
for /l %%a in (!contentH! -1 10) do (
	echo=¤MW	!PID!.oobe	l!last!=	l%%a=%\e%[20CWelcome to Shivtanium‼
	set last=%%a
)
echo=¤MW	!PID!.oobe	l12=%\e%[8CBefore we put you on the desktop, we have some	l13=%\e%[17Ccustomization to go through.	o!contentH!=%\e%[!nextButtonX!C Next 

set last=
set off=
call :pagewait

REM  Transition
echo=¤MW	!PID!.oobe	l12=	l13=
set fall=10
for /l %%a in (51 -4 3) do (
	set /a "off=27-%%a/2", "last=fall, fall+=1"
	if !last! lss !contentH! (
		set add=
		echo=¤MW	!PID!.oobe	l!last!=	l!fall!=%\e%[20CWelcome to Shivtanium‼
	) else set add=	l!contentH!=
	
	echo=¤MW	!PID!.oobe^
	l2=%\e%[!off!C%\e%[7m!s2:~0,%%a!!s2:~-7!%\e%[27m^
	l3=%\e%[!off!C%\e%[7m!s3:~0,%%a!!s3:~-7!%\e%[27m^
	l4=%\e%[!off!C%\e%[7m!s4:~0,%%a!!s4:~-7!%\e%[27m^
	l5=%\e%[!off!C%\e%[7m!s5:~0,%%a!!s5:~-7!%\e%[27m^
	l6=%\e%[!off!C%\e%[7m!s6:~0,%%a!!s6:~-7!%\e%[27m^
	l7=%\e%[!off!C%\e%[7m!s7:~0,%%a!!s7:~-7!%\e%[27m^
	l8=%\e%[!off!C%\e%[7m!s8:~0,%%a!!s8:~-7!%\e%[27m!add!
)
set last=
set fall=
set add=

:accountsetup // User Profile Setup
echo=¤MW	!PID!.oobe	l2=	l3=	l4=	l5=	l6=	l7=	l8=	o!contentH!=%\e%[2C Back %\e%8%\e%[!nextButtonX!C Next 

set "l2= Create a user profile"
set "l4=  Username:           "
set "l7=  Password:           "
for /l %%a in (2 3 23) do echo=¤MW	!PID!.oobe^
	l2= !l2:~-%%a!	l4= !l4:~-%%a!	l7= !l7:~-%%a!^
	o5=%\e%[3C%\e%[7m%\e%[%%aX%\e%[27m	o8=%\e%[3C%\e%[%%aX

for /l %%a in (28 3 !inputW!) do echo=¤MW	!PID!.oobe	o5=%\e%[3C%\e%[7m%\e%[%%aX%\e%[27m	o8=%\e%[3C%\e%[%%aX
set "buttons=username password"
set btn[username]Y=5
set btn[password]Y=8
set /a "btn[username]X=btn[password]X=3, btn[username]BX=btn[password]BX=nextButtonX"
set btn[username]=:textinput username
set btn[password]=:textinput password
set btn[username]N=:textinput password

set "txt.username= "
set "txt.password= "
call :textinput username
call :pagewait

for /l %%a in (!inputW! -4 4) do (
	set /a "x=inputW-%%a+3"
	echo=¤MW	!PID!.oobe^
	l2=%\e%[!x!C!l2:~0,%%a!	l4=%\e%[!x!C!l4:~0,%%a!	l7=%\e%[!x!C!l7:~0,%%a!^
	o5=%\e%[!x!C%\e%[%%aX!txt.username:~0,%%a!	o8=%\e%[!x!C%\e%[%%aX!txt.password:~0,%%a!
)
set x=
echo=¤MW	!PID!.oobe	o5=	o8=	l2=	l4=	l7=
set buttons=
if errorlevel 1 goto start
:fontsetup
set "l2=Font installation                                        "
set "l4=The recommended font for Shivtanium is:                  "
set "l5= MxPlus IBM VGA 8x16                                     "
set "l6=This will download & extract a font pack from int10h.org."
set "l8=If you want to skip this font installation, click 'Next'."
set "o10= Download & Install                                     "
set buttons=install
set btn[install]X=3
set btn[install]BX=22
set btn[install]Y=10
set btn[install]=:getfonts
set "btn[install]title=!o10:~0,20!"
set continue=

for /l %%a in (2 4 56) do echo=¤MW	!PID!.oobe^
	l2=  !l2:~-%%a!	l4=  !l4:~-%%a!	l5=  %\e%[7m!l5:~-%%a,21!%\e%[27m	l6=  !l6:~-%%a!	l8=  !l8:~-%%a!	o10=%\e%[3C!o10:~-%%a,20!
echo=¤MW	!PID!.oobe	l2=  !l2:  =!	l4=  !l4:  =!	l5=  %\e%[7m!l5:~0,21!%\e%[27m	l6=  !l6:  =!	l8=  !l8:  =!	o10=%\e%[3C!o10:~0,20!

call :pagewait
echo=¤MW	!PID!.oobe	l2=	l4=	l5=	l6=	l8=	o10=
if errorlevel 1 goto accountsetup
goto start
:pagewait
for /l %%# in (1 1 1000) do if not defined continue for /l %%# in (1 1 1000) do if not defined continue (
	set kernelOut=
	set /p "kernelOut="
	if defined kernelOut if "!kernelOut!"=="click=1" (
		if "!focusedWindow!"=="!PID!.oobe" (
			set /a "relativeMouseX=mouseXpos - win[!PID!.oobe]X, relativeMouseY=mouseYpos - win[!PID!.oobe]Y"
			if "!relativeMouseY!"=="!contentH!" (
				if !relativeMouseX! geq !nextButtonX! if !relativeMouseX! leq !nextButtonBX! (
					echo=¤MW	!PID!.oobe	o!contentH!=%\e%[2C Back %\e%8%\e%[!nextButtonX!C%\e%[7m Next %\e%[27m
				)
				if !relativeMouseX! geq 2 if !relativeMouseX! leq 7 (
					echo=¤MW	!PID!.oobe	o!contentH!=%\e%[2C%\e%[7m Back %\e%[27m%\e%8%\e%[!nextButtonX!C Next 
				)
			)
			for %%a in (!buttons!) do if "!relativeMouseY!"=="!btn[%%~a]Y!" if !relativeMouseX! geq !btn[%%~a]X! if !relativeMouseX! leq !btn[%%~a]BX! (
				set continue=0
				call !btn[%%~a]!
			)
		)
	) else if "!kernelOut!"=="click=0" (
		if "!focusedWindow!"=="!PID!.oobe" (
			echo=¤MW	!PID!.oobe	o!contentH!=%\e%[2C Back %\e%8%\e%[!nextButtonX!C Next 
			set /a "relativeMouseX=mouseXpos - win[!PID!.oobe]X, relativeMouseY=mouseYpos - win[!PID!.oobe]Y"
			if "!relativeMouseY!"=="!contentH!" (
				if !relativeMouseX! geq !nextButtonX! if !relativeMouseX! leq !nextButtonBX! (
					set continue=0
				)
				if !relativeMouseX! geq 2 if !relativeMouseX! leq 7 (
					set continue=1
				)
			)
		)
	) else if "!kernelOut!"=="exitProcess=!PID!" (
		exit 0
	) else if "!kernelOut!"=="exit" (
		exit 0
	) else set "!kernelOut!">nul 2>&1
)
if not defined continue goto pagewait
for /f "delims=" %%a in ("!continue!") do (
	set continue=
	exit /b %%a
)
:textinput
echo=¤MW	!PID!.oobe	o!btn[%1]Y!=%\e%[3C%\e%[7m%\e%[!inputW!X!txt.%1:~-%inputC%!_%\e%[27m
set continue=
set continue.exit=
:textinput.loop
for /l %%# in (1 1 1000) do if not defined continue for /l %%# in (1 1 1000) do if not defined continue (
	set kernelOut=
	set /p "kernelOut="
	if defined kernelOut if "!kernelOut:~0,12!"=="keysPressed=" (
		set "sys.keys=!kernelOut:~12!"
	) else if "!kernelOut:~0,14!"=="keysPressedRN=" (
		if "!focusedWindow!"=="!PID!.oobe" (
			set "!kernelOut!">nul 2>&1
			for %%k in (!keysPressedRN!) do (
				set "char=!charset_L:~%%k,1!"
				if "!sys.keys!" neq "!sys.keys:-16-=!" set "char=!charset_U:~%%k,1!"
				if "!sys.keys!" neq "!sys.keys:-17-=!" set "char=!charset_A:~%%k,1!"
				if "!char!"==" " (
					if "%%~k" neq "32" set char=
					if "%%~k"=="8" (
						if "!txt.%1!" neq " " set "txt.%~1=!txt.%~1:~0,-1!"
						echo=¤MW	!PID!.oobe	o!btn[%1]Y!=%\e%[3C%\e%[7m%\e%[!inputW!X!txt.%1:~-%inputC%!_%\e%[27m
					)
				)
				if defined char (
					set "txt.%~1=!txt.%~1!!char!"
					echo=¤MW	!PID!.oobe	o!btn[%1]Y!=%\e%[3C%\e%[7m%\e%[!inputW!X!txt.%1:~-%inputC%!_%\e%[27m
				) else if "%%~k"=="13" (
					set continue.exit=0
					set continue=13
					echo=¤MW	!PID!.oobe	o!btn[%1]Y!=%\e%[3C%\e%[!inputW!X!txt.%1:~-%inputC%!
				)
			)
		)
	) else if "!kernelOut!"=="click=1" (
		if "!focusedWindow!"=="!PID!.oobe" (
			set /a "relativeMouseX=mouseXpos - win[!PID!.oobe]X, relativeMouseY=mouseYpos - win[!PID!.oobe]Y"
			if "!relativeMouseY!"=="!contentH!" (
				if !relativeMouseX! geq !nextButtonX! if !relativeMouseX! leq !nextButtonBX! (
					echo=¤MW	!PID!.oobe	o!contentH!=%\e%[2C Back %\e%8%\e%[!nextButtonX!C%\e%[7m Next %\e%[27m
				)
				if !relativeMouseX! geq 2 if !relativeMouseX! leq 7 (
					echo=¤MW	!PID!.oobe	o!contentH!=%\e%[2C%\e%[7m Back %\e%[27m%\e%8%\e%[!nextButtonX!C Next 
				)
			)
		)
	) else if "!kernelOut!"=="click=0" (
		if "!focusedWindow!"=="!PID!.oobe" (
			echo=¤MW	!PID!.oobe	o!contentH!=%\e%[2C Back %\e%8%\e%[!nextButtonX!C Next 
			set /a "relativeMouseX=mouseXpos - win[!PID!.oobe]X, relativeMouseY=mouseYpos - win[!PID!.oobe]Y"
			if "!relativeMouseY!" neq "!btn[%~1]Y!" (
				set continue=True
				echo=¤MW	!PID!.oobe	o!btn[%1]Y!=%\e%[3C%\e%[!inputW!X!txt.%1:~-%inputC%!
				if "!relativeMouseY!"=="!contentH!" (
					if !relativeMouseX! geq !nextButtonX! if !relativeMouseX! leq !nextButtonBX! set continue.exit=True
					if !relativeMouseX! geq 2 if !relativeMouseX! leq 7 set continue.exit=1
				)
			)
		)
	) else if "!kernelOut!"=="exitProcess=!PID!" (
		exit 0
	) else if "!kernelOut!"=="exit" (
		exit 0
	) else set "!kernelOut!">nul 2>&1
)
if not defined continue goto textinput.loop
if "!continue!"=="13" (
	if defined btn[%1]N (
		call !btn[%1]N!
		set continue=0
	)
) else set continue=!continue.exit!
exit /b 0
:getfonts
echo=¤MW	!PID!.oobe	o10=%\e%[3C%\e%[7m!btn[install]title!%\e%[27m
set continue=
for /l %%# in (1 1 1000) do if not defined continue for /l %%# in (1 1 1000) do if not defined continue (
	set kernelOut=
	set /p "kernelOut="
	if defined kernelOut (
		if "!kernelOut!"=="click=0" (
			set continue=True
			if "!focusedWindow!"=="!PID!.oobe" set /a "relativeMouseX=mouseXpos - win[!PID!.oobe]X, relativeMouseY=mouseYpos - win[!PID!.oobe]Y, click=0"
		) else if "!kernelOut!"=="exitProcess=!PID!" (
			exit 0
		) else if "!kernelOut!"=="exit" (
			exit 0
		) else set "!kernelOut!">nul 2>&1
	)
)
if not defined continue goto getfonts
set continue=
echo=¤MW	!PID!.oobe	o10=%\e%[3C!btn[install]title!
if "!click!" neq "0" exit /b 0
if "!relativeMouseY!" neq "!btn[install]Y!" exit /b 0
if !relativeMouseX! lss !btn[install]X! exit /b 0
if !relativeMouseX! gtr !btn[Install]BX! exit /b 0

md "!sst.dir!\temp\proc\PID-!PID!-dir" || exit /b 1
pushd "!sst.dir!\temp\proc\PID-!PID!-dir" || exit /b 1

echo=¤CW	!PID!.getfonts	5	3	84	8	Downloading assets	classic noCBUI
>>"!sst.dir!\temp\kernelPipe" echo=registerWindow	!PID!	!PID!.getfonts	5	3	84	8
set contentW=80
echo=¤MW	!PID!.getfonts	l2=  Downloading %\e%[7m oldschool_pc_font_pack_v2.2_win.zip %\e%[27m . . .	l4=  %% Total    %% Received %% Xferd  Average Speed   Time    Time     Time  Current	l5=                                 Dload  Upload   Total   Spent    Left  Speed

curl -fkLO https://int10h.org/oldschool-pc-fonts/download/oldschool_pc_font_pack_v2.2_win.zip 2>&1 | call "!sst.dir!\core\streamIntoWindow" !PID!.getfonts	l6=  
if errorlevel 1 (
	call :getfonts.fail "Failed to download assets" "The following file failed to download:" "%\e%[7m oldschool_pc_font_pack_v2.2_win.zip %\e%[27m" "Reason: %\e%[7m curl error !errorlevel! %\e%[27m"
	goto getfonts.exit
) else if not exist "oldschool_pc_font_pack_v2.2_win.zip" (
	call :getfonts.fail "Failed to download assets" "The following file failed to download:" "%\e%[7m oldschool_pc_font_pack_v2.2_win.zip %\e%[27m" "Reason: Generic error !errorlevel!"
	goto getfonts.exit
)
echo=¤MW	!PID!.getfonts	l2=  Extracting %\e%[7m oldschool_pc_font_pack_v2.2_win.zip %\e%[27m . . .	l4=	l5=	l6=
tar -xf "oldschool_pc_font_pack_v2.2_win.zip" || (
	call :getfonts.fail "Failed to extract assets" "The following archive failed to extract:" "%\e%[7m oldschool_pc_font_pack_v2.2_win.zip %\e%[27m" "Reason: %\e%[7m tar error !errorlevel! %\e%[27m"
	goto getfonts.exit
)
echo=¤MW	!PID!.getfonts	l2=  Waiting for license agreement . . . (Close the notepad window to continue)
start /wait notepad.exe README.txt
start /wait notepad.exe LICENSE.txt
start /wait "" "ttf - Mx (mixed outline+bitmap)\MxPlus_IBM_VGA_8x16.ttf"



popd
rd /s /q "!sst.dir!\temp\proc\PID-!PID!-dir" >&2
:getfonts.exit
echo=¤DW	!PID!.getfonts
>>"!sst.dir!\temp\kernelPipe" echo=unRegisterWindow	!PID!.getfonts
exit /b 0
:getfonts.fail
set halt.title=
set halt.winparams=
set halt.winW=16
set lines=1
for %%a in (%*) do (
	set "msg=#%%~a"
	set "msglen=0"
	for /l %%b in (9,-1,0) do (
		set /a "msglen|=1<<%%b"
		for %%c in (!msglen!) do if "!msg:~%%c,1!" equ "" set /a "msglen&=~1<<%%b"
	)
	
	if not defined halt.title (
		set /a msglen+=13
		set "halt.title=%%~a"
	) else (
		set /a "msglen+=6, lines+=1"
		set "halt.winparams=!halt.winparams!	l!lines!=  %%~a"
	)
	if !msglen! gtr !halt.winW! set "halt.winW=!msglen!"
)
set /a "halt.winH=lines + 4"

>>"!sst.dir!\temp\kernelPipe" echo=createProcess	!PID!	systemb-dialog 5 3 !halt.winW! !halt.winH! "!halt.title!	classic noCBUI" "!halt.winparams!" w-buttonW-2 h-2 7 " Close "
exit /b 0
