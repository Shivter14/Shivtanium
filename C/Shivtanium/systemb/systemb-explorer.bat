@echo off & setlocal enableDelayedExpansion
for %%a in (%*) do (
	if defined next (
		set "!next!=%%~a"
		set next=
	) else (
		set next=
		if "%%a"=="--username" (
			set next=sys.username
		) else if "%%a"=="--UPID" (
			set next=sys.UPID
		) else if "%%a"=="--working-dir" (
			set next=setdir
		)
	)
)
if defined setdir (
	cd "!setdir!">nul 2>&1
	set setdir=
)

if not defined sys.UPID (
	echo=createProcess	!PID!	systemb-dialog.bat 5 !tempY! 44 7 "systemb-launcher	classic" "l2=  The process failed to start:	l3=    You need to be logged in,	l4=    in order to use systemb-launcher." 35 5 7 " Close "
	echo=exitProcess	!PID!
	exit 0
) >> "!sst.dir!\temp\kernelPipe"

set /a "win[!PID!.explorer]W=sys.modeW*2/3, win[!PID!.explorer]H=sys.modeH*2/3, win[!PID!.explorer]X=3, win[!PID!.explorer]Y=2, sidebarW=20"

set icon.directory[1]=%\e%[38;2;;;m▄▄▄▄▄▄▄▄
set icon.directory[2]=%\e%[38;2;;;m█%\e%[38;2;255;255;255;48;2;255;255;m░░░░░░%\e%[38;2;;;m▀█▄▄▄▄▄▄▄
set icon.directory[3]=%\e%[38;2;;;m█%\e%[38;2;255;255;255;48;2;255;255;m░░░░░░░░░░░░░░%\e%[38;2;;;m█
set icon.directory[4]=%\e%[38;2;;;m█%\e%[38;2;255;255;255;48;2;255;255;m░░░░░░░░░░░░░░%\e%[38;2;;;m█
set icon.directory[5]=%\e%[38;2;;;m█%\e%[38;2;255;255;255;48;2;255;255;m░░░░░░░░░░░░░░%\e%[38;2;;;m█
set icon.directory[6]=%\e%[38;2;;;m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

for /l %%a in (1 1 5) do (
	set "icon.directory.hidden[%%a]=!icon.directory[%%a]:255;255;0=127;127;127!"
	set "icon.directory.hidden.system[%%a]=!icon.directory[%%a]:255;255;255;48;2;255;255;0=63;0;63;48;2;127;0;127!"
	set "icon.directory.system[%%a]=!icon.directory[%%a]:255;255;0=127;0;127!"
)
echo=¤CW	!PID!.explorer	!win[%PID%.explorer]X!	!win[%PID%.explorer]Y!	!win[%PID%.explorer]W!	!win[%PID%.explorer]H!	╒═┐ File Explorer
>>"!sst.dir!\temp\kernelPipe" echo=registerWindow	!PID!	!PID!.explorer	!win[%PID%.explorer]X!	!win[%PID%.explorer]Y!	!win[%PID%.explorer]W!	!win[%PID%.explorer]H!

set scrollpos=0
call :reload
for /l %%# in () do (
	set kernelOut=
	set /p "kernelOut="
	if defined kernelOut if "!kernelOut:~0,6!;!focusedWindow!"=="click=;!PID!.explorer" (
		set "!kernelOut!">nul 2>&1
		set /a "relativeMouseX=mouseXpos - win[!PID!.explorer]X, relativeMouseY=mouseYpos - win[!PID!.explorer]Y"
		if "!relativeMouseY!"=="0" (
			if "!click!"=="1" (
				if !relativeMouseX! geq !closeButtonX! (
					>>"!sst.dir!\temp\kernelPipe" echo=exitProcess	!PID!
					exit 0
				)
			)
		) else if !relativeMouseX! geq !sidebarW! (
			if "!relativeMouseY!"=="1" (
				set "addressbar= !cd!"
				for /f "" %%w in ("!ftW!") do (
					echo=¤MW	!PID!.explorer	l1=%\e%[!sidebarW!C%\e%[D%\e%[7m!addressbar:~-%%~w!%\e%[27m
				)
			) else (
				for /l %%Y in (0 1 !gfY!) do for /l %%X in (0 1 !gridW!) do if !relativeMouseX! geq !item[%%Xx%%Y]X! if !relativeMouseX! leq !item[%%Xx%%Y]BX! if !relativeMouseY! geq !item[%%Xx%%Y]Y! if !relativeMouseY! leq !item[%%Xx%%Y]BY! for %%F in ("!item[%%Xx%%Y]!") do (
					set "temp.attr=%%~aF"
					if "!click!"=="1" (
						if "!temp.attr:~0,1!"=="d" (
							set "dir=%%~fF"
							cd "!dir!" > nul 2>&1
							set scrollpos=0
							call :reload
						) else if "%%~xF"==".bat" (
							>>"!sst.dir!\temp\kernelPipe" echo=createProcess	!sys.UPID!	%%~F
						) else (
							pushd "%%~dpF"
							start %%~nxF
							popd
							call :reload
						)
					)
				)
			)
		) else (
			if "!relativeMouseY!;!click!"=="1;1" if !relativeMouseX! leq 3 if !relativeMouseX! geq 1 (
				cd .. >nul 2>&1
				set scrollpos=0
				call :reload
			)
		)
	) else if "!kernelOut:~0,14!"=="keysPressedRN=" (
		set "!kernelOut!" > nul 2>&1
		if "!focusedWindow!"=="!PID!.explorer" if defined addressbar (for %%k in (!keysPressedRN!) do (
			set "char=!charset_L:~%%k,1!"
			if "!keysPressed!" neq "!keysPressed:-16-=!" set "char=!charset_U:~%%k,1!"
			if "!keysPressed!" neq "!keysPressed:-17-=!" set "char=!charset_A:~%%k,1!"
			if "!char!"==" " (
				if "%%~k" neq "32" set char=
				if "%%~k"=="8" (
					if "!addressbar!" neq " " (
						set "addressbar=!addressbar:~0,-1!"
						if "!keysPressed!" neq "!keysPressed:-16-=!" set "addressbar= "
						for /f "" %%w in ("!ftW!") do (
							echo=¤MW	!PID!.explorer	l1=%\e%[!sidebarW!C%\e%[D%\e%[7m!addressbar:~-%%~w!%\e%[27m
						)
					)
				) else if "%%~k"=="13" (
					cd "!addressbar:~1!">nul 2>&1 || (
						for /f "" %%w in ('set /a !ftW!-4') do (
							set /a "Xpos=win[!PID!.explorer]X+sidebarW+2, Ypos=win[!PID!.explorer]Y+2"
							echo=createProcess	!sys.UPID!	systemb-dialog.bat !Xpos! !Ypos! !rsW! 7 "File Explorer: Invalid directory" "l2=  The directory you entered is invalid:	o3=%\e%[3C!addressbar:~-%%~w!" w-buttonW-2 h-2 7 " Close "
							set Xpos=
							set Ypos=
						) >> "!sst.dir!\temp\kernelPipe"
					)
					set scrollpos=0
					call :reload
				) else if "%%~k"=="27" (
					echo=¤MW	!PID!.explorer	l1=!l1!
					set addressbar=
				)
			)
			if defined char (
				set "addressbar=!addressbar!!char!"
				for /f "" %%w in ("!ftW!") do (
					echo=¤MW	!PID!.explorer	l1=%\e%[!sidebarW!C%\e%[D%\e%[7m!addressbar:~-%%~w!%\e%[27m
				)
			)
		)) else (
			if "!keysPressedRN!"=="  38 " (
				set /a scrollpos-=1
				call :reload
			)
			if "!keysPressedRN!"=="  40 " (
				set /a scrollpos+=1
				call :reload
			)
		)
	) else if "!kernelOut!"=="exitProcess=!PID!" (
		exit 0
	) else if "!kernelOut!"=="exit" (
		exit 0
	) else set "!kernelOut!" > nul 2>&1
)

:reload
if !scrollpos! lss 0 set scrollpos=0
set addressbar=
for /f "tokens=1 delims==" %%a in ('set item 2^>nul') do set "%%a="
set /a "pos=0, spacingW=2, spacingH=1, iconC=(iconW=16)-1, iconH=7, gridW=(ftW=rsW=win[!PID!.explorer]W - sidebarW - 4) / (iconW + spacingW), gfY=(rsH=win[!PID!.explorer]H - 3) / (iconH + spacingH), win[!PID!.explorer]RH=win[!PID!.explorer]H-1, ftW+=2, closeButtonX=win[!PID!.explorer]W-3"
for /l %%y in (1 1 !win[%PID%.explorer]H!) do (
	set "o%%y=%\e%[!sidebarW!X"
	set "l%%y="
)
for /f %%a in ('set tile[ 2^>nul') do set "%%a="
for /f "delims=^!*" %%F in ('dir /b /o:GN 2^>nul ^& dir /b /a:S 2^>nul') do (
	set /a "posX=pos %% gridW, posY=(lines=pos / gridW) - scrollpos, pos+=1"
	if !posY! geq 0 if !posY! leq !gfY! (
		set "temp.attrib=%%~aF"
		set "item[!posX!x!posY!]attrib=!temp.attrib!"
		set "item[!posX!x!posY!]=%%~fF"
		set "item[!posX!x!posY!]name=%%~nxF"
		set "item[!posX!x!posY!]icon=[%%~xF]"
		if "!temp.attrib:~2,1!" neq "a" set "item[!posX!x!posY!]icon="
		
		for %%a in (
			"0 d directory"
			"3 h hidden"
			"4 s system"
			"2 a file"
		) do for /f "tokens=1-4*" %%v in ("!posX! !posY! %%~a") do (
			if "!temp.attrib:~%%~x,1!"=="%%~y" set "item[%%vx%%w]icon=!item[%%vx%%w]icon!.%%~z"
		)
		
		set /a "item[!posX!x!posY!]X=rsW / gridW * posX + spacingW + sidebarW, item[!posX!x!posY!]Y=posY * (iconH + spacingH) + spacingH + 1, item[!posX!x!posY!]BX=item[!posX!x!posY!]X+iconW-1, item[!posX!x!posY!]BY=item[!posX!x!posY!]Y+iconH-1"
	)
)
set "scY=!gfY!"
if !posY! lss !gfY! set gfY=!posY!
if !posY! lss 0 (
	set /a scrollpos+=posY
	goto reload
)

if "!scrollpos!"=="0" (
	set "pipe=¤MW	!PID!.explorer	p!win[%PID%.explorer]RH!="
	for /l %%y in (1 1 !win[%PID%.explorer]RH!) do set "pipe=!pipe!	o%%y=%\e%[!sidebarW!X	l%%y="
	echo=!pipe!
)



for /l %%Y in (0 1 !gfY!) do for /l %%X in (0 1 !gridW!) do for /f "tokens=1-3 delims=;" %%a in ("!item[%%Xx%%Y]Y!;!item[%%Xx%%Y]BY!;!item[%%Xx%%Y]icon!") do (
	set temp=0
	for /l %%y in (%%a 1 %%b) do (
		set /a temp+=1
		for /f %%z in ("!temp!") do (
			if defined icon%%c[%%z] set "l%%y=!l%%y!%\e%8%\e%[!item[%%Xx%%Y]X!C!icon%%c[%%z]!"
		)
	)
	set "o%%b=!o%%b!%\e%8%\e%[!item[%%Xx%%Y]X!C%\e%[!iconW!X !item[%%Xx%%Y]name:~0,%iconC%!"
)
if !lines! geq !gfY! (
	set /a "scrollbar.S=scrollpos * rsH / lines + 1, scrollbar.E=(scrollpos + scY - 1) * rsH / lines + 1"
	for /l %%y in (!scrollbar.S! 1 !scrollbar.E!) do (
		set "o%%y=!o%%y!%\e%8%\e%[!win[%PID%.explorer]W!C%\e%[2D "
	)
)


set "dcd= !cd!"
set "l1=%\e%[!sidebarW!C%\e%[D!dcd:~-%ftW%!"
set "o1=!o1!%\e%8 %\e%[7m ▲ %\e%[27m"
set "o!win[%PID%.explorer]RH!=%\e%[!win[%PID%.explorer]W!X"
set "pipe=¤MW	!PID!.explorer"
for /l %%y in (1 1 !win[%PID%.explorer]RH!) do (
	if "!pipe:~500,1!" neq "" (
		echo=!pipe!
		set "pipe=¤MW	!PID!.explorer"
	)
	set "pipe=!pipe!	o%%y=!o%%y!"
	set "pipe=!pipe!	l%%y=!l%%y!"
)
echo=!pipe!
set pipe=
set > "!sst.dir!\temp\proc\PID-!PID!-memoryDump"
exit /b 0
