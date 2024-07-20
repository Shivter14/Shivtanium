for /f "tokens=1 delims==" %%a in ('set dwm. 2^>nul ^& set spr. 2^>nul ^& set ssvm. 2^>nul') do set "%%a="
cd "!sst.dir!" || call :kernelPanic "Unable to locate system directory" "The system failed to start:\nValue sst.dir: '!sst.dir!'\n ^^^^^^  Invalid directory."
if not exist "temp\proc" md "temp\proc"
if not defined processes set "processes= "
if !sys.CPU.count! lss 4 (
	if "!sys.lowPerformanceMode!" neq "True" set "temp.nr=o6=%\e%[2C Tip: Set the following value in settings.dat: 	l7= %\e%[7m lowPerformanceMode=True%\e%[23X%\e%[27m"
	call :createProcess 0	systemb-dialog.bat 5 3 59 9 "Performance notification	noCBUI" "l2=  Your CPU only has !sys.CPU.count! logical processor(s).	l3=  This might lead to a bad experience.	l4=  The recommended minimum of logical processors is: 4	!temp.nr!" 50 7 7 " Close "
	set temp.nr=
)
if not exist "!sst.root!\Users" (
	call :createProcess 0	systemb-oobe.bat
) else call :createProcess 0	systemb-login.bat
set sys.keys=
set keysPressedOld=
set "windows= "
set ioTotal=0
title Shivtanium OS !sys.tag! !sys.ver! !sys.subvinfo!
(set \n=^^^

)

if /I "!sys.lowPerformanceMode!" neq "True" set @sendWindowPositionData=set /a ioTotal+=2%\n%
	echo=win[^^!movingWindow^^!]X=^^!tempX^^!%\n%
	echo=win[^^!movingWindow^^!]Y=^^!tempY^^!

for /l %%# in () do (
	set "sys.clickOld=!sys.click!"
	set "sys.click=!click!"
	if "!sys.click!" neq "!sys.clickOld!" (
		set sys.mouseXpos=!mouseXpos!
		set sys.mouseYpos=!mouseYpos!
		if !sys.mouseXpos! geq 1 if !sys.mouseXpos! leq !sys.modeW! if !sys.mouseYpos! geq 1 if !sys.mouseYpos! leq !sys.modeH! (
			if "!sys.click!"=="1" (
				set "_focusedWindow=!focusedWindow!"
				set focusedWindow=
				for %%w in (!windows!) do if not defined focusedWindow (
					if !sys.mouseYpos! geq !win[%%~w]Y! if !sys.mouseYpos! leq !win[%%~w]BY! if !sys.mouseXpos! geq !win[%%~w]X! if !sys.mouseXpos! leq !win[%%~w]BX! (
						if "%%~w" neq "!_focusedWindow!" (
							set "focusedWindow=%%~w"
							set "windows= %%w!windows: %%w = !"
							echo=focusedWindow=%%~w
							>&3 echo=¤FOCUS	%%~w
							set /a ioTotal+=1
						) else set "focusedWindow=%%~w"
						if "!sys.mouseYpos!"=="!win[%%~w]Y!" if "!win[%%~w]D:~0,1!" neq "1" (
							set /a "movingWindowOffset=sys.mouseXpos-!win[%%~w]X!"
							set "movingWindow=!focusedWindow!"
						)
					)
				)
				if defined _focusedWindow (
					if not defined focusedWindow (
						echo=focusedWindow=
						set /a ioTotal+=4
					) else set /a ioTotal+=3
				) else set /a ioTotal+=3
			) else (
				if defined movingWindow (
					set /a ioTotal+=5
					echo=win[!movingWindow!]X=!tempX!
					echo=win[!movingWindow!]Y=!tempY!
					set tempX=
					set tempY=
					set movingWindow=
				) else (
					set movingWindow=
					set /a ioTotal+=3
				)
			)
			echo=mouseXpos=!sys.mouseXpos!
			echo=mouseYpos=!sys.mouseYpos!
			echo=click=!sys.click!
		)
	)
	set sys.mouseXold=!sys.mouseXpos!
	set sys.mouseYold=!sys.mouseYpos!
	if "!random:~0,1!"=="1" (
		set sys.mouseXpos=!mouseXpos!
		set sys.mouseYpos=!mouseYpos!
		if "!sys.mouseXold!;!sys.mouseYold!" neq "!sys.mouseXpos!;!sys.mouseYpos!" if defined movingWindow (
			set /a "tempX=win[!movingWindow!]X=sys.mouseXpos-movingWindowOffset, temps=win[!movingWindow!]BX=win[!movingWindow!]X+win[!movingWindow!]W-1", "tempY=win[!movingWindow!]Y=sys.mouseYpos, win[!movingWindow!]BY=win[!movingWindow!]Y+win[!movingWindow!]H-1"
			if !tempX! lss 1 (
				set /a "tempX=win[!movingWindow!]X=1, win[!movingWindow!]BX=win[!movingWindow!]W"
			) else if !temps! gtr !sys.modeW! set /a "tempX=win[!movingWindow!]X=sys.modeW-win[!movingWindow!]W+1, win[!movingWindow!]BX=sys.modeW"
			if !tempY! lss 1 (
				set /a "tempY=win[!movingWindow!]Y=1, win[!movingWindow!]BY=win[!movingWindow!]H"
			) else if !tempY! geq !sys.modeH! set /a "tempY=win[!movingWindow!]Y=sys.modeH-1, win[!movingWindow!]BY=win[!movingWindow!]Y+win[!movingWindow!]H-1"
			%@sendWindowPositionData%
			>&3 echo=¤MW	!movingWindow!	X=!tempX!	Y=!tempY!
			set temps=
		) else if "!sys.click!" neq "0" (
			if "!sys.mouseXpos!" neq "!sys.mouseXold!" if !sys.mouseXpos! geq 1 if !sys.mouseXpos! leq !sys.modeW! (
				set /a ioTotal+=1
				echo=mouseXpos=!sys.mouseXpos!
			)
			if "!sys.mouseYpos!" neq "!sys.mouseYold!" if !sys.mouseYpos! geq 1 if !sys.mouseYpos! leq !sys.modeH! (
				set /a ioTotal+=1
				echo=mouseYpos=!sys.mouseYpos!
			)
		)
	)
	set "sys.keys= !keysPressed!"
	set "sys.keysRN=!sys.keys:-= !"
	if defined focusedWindow (
		if "!sys.keysRN!" neq "!keysPressedOld!" (
			echo=keysPressed=!sys.keys!
			set /a ioTotal+=1
		)
		for %%k in (!keysPressedOld!) do set "sys.keysRN=!sys.keysRN: %%k = !"
		if "!sys.keysRN: =!" neq "" (
			echo=keysPressedRN=!sys.keysRN!
			set /a ioTotal+=1
		)
	)
	set "keysPressedOld=!sys.keys:-= !"
	
	if "!sys.keys:~0,8!"==" -17-18-" (
		if "!sys.keysRN!"=="  82 " (
			call :kernelPanic "User triggered crash" "Shivtanium OS !sys.tag! !sys.ver! !sys.subvinfo!\nTotal IO transfers: !ioTotal!\nA memory dump has been created at: ~:\Shivtanium\temp\KernelMemoryDump"
		) else if "!sys.keysRN!"=="  84 " (
			echo=exit
			set /a ioTotal+=1
			(for %%w in (!windows!) do (
				echo=¤DW	%%~w
			))>&3
			for /f %%a in ('set pid 2^>nul ^& set win 2^>nul') do set "%%a="
			set "processes= "
			set "windows= "
			set focusedWindow=
			set movingWindow=
			set movingWindowOffset=
			
			call :createProcess 0	systemb-login.bat
		)
	)

	set io=
	set /p io=
	if defined io for /f "tokens=1* delims=	" %%0 in ("!io!") do (
		if "%%~0"=="registerWindow" (
			for /f "tokens=1-7" %%a in ("%%~1") do (
				set "temp.id=%%~b"
				set "temp.id=!temp.id:,=!"
				set "temp.id=!temp.id:+=!"
				set "temp.id=!temp.id:-=!"
				set "temp.id=!temp.id:/=!"
				set "temp.id=!temp.id:(=!"
				set "temp.id=!temp.id:)=!"
				set "temp.id=!temp.id:>=!"
				set "temp.id=!temp.id:<=!"
				set "temp.id=!temp.id:^^=!"
				if "%%~b" neq "!temp.id!" call :kernelPanic	"Invalid Window ID" "At function 'registerWindow':\n  Window ID contains illegal characters.\n  (For reference, these are listed on the Wiki.)\nA memory dump has been created at: ~:\Shivtanium\temp\KernelMemoryDump"
				set "windows= "!temp.id!"!windows!"
				set "pid[%%~a]windows=!pid[%%~a]windows!"!temp.id!" "
				set "win[!temp.id!]=%%~a"
				set "win[!temp.id!]X=%%~c"
				set "win[!temp.id!]Y=%%~d"
				set "win[!temp.id!]W=%%~e"
				set "win[!temp.id!]H=%%~f"
				set "win[!temp.id!]D=%%~g"
				set /a "win[!temp.id!]X=win[!temp.id!]X, win[!temp.id!]Y=win[!temp.id!]Y, win[!temp.id!]W=win[!temp.id!]W, win[!temp.id!]H=win[!temp.id!]H, win[!temp.id!]BX=win[!temp.id!]X+win[!temp.id!]W-1, win[!temp.id!]BY=win[!temp.id!]Y+win[!temp.id!]H-1", ioTotal+=1
				set "focusedWindow=!temp.id!"
				echo=focusedWindow=!temp.id!
				set temp.id=
			)
		) else if "%%~0"=="unRegisterWindow" (
			for /f "tokens=1 delims==" %%a in ('set "win[%%~1]" 2^>nul') do set "%%a="
			if "%%~1"=="!focusedWindow!" (
				set /a ioTotal+=1
				echo=focusedWindow=
				set focusedWindow=
			)
			if "%%~1"=="!movingWindow!" set movingWindow=
		) else if "%%~0"=="exitProcess" (
			set "PID=%%~1"
			set /a PID=PID
			if "!PID!" neq "%%~1" call :kernelPanic "Invalid Process ID" "At function 'exitProcess':\n  Invalid Process ID: `%%~1` (NaN)\nThis is either a fatal error, or some program missbehaving.\nA memory dump has been created at: ~:\Shivtanium\temp\KernelMemoryDump"
			if exist "temp\proc\PID-!PID!" del "temp\proc\PID-!PID!" >nul 2>&1 <nul
			set "processes=!processes: %%1 = !"
			if "!processes: =!"=="" (
				echo=exit
				echo=¤EXIT>&3
				for /l %%# in (1 1 100000) do rem
				echo=%\e%[48;2;0;0;0m%\e%[H%\e%[2J>con
				copy nul "temp\bootStatus-!sst.localtemp!-exit" > nul 2>&1
				call "!sst.dir!\boot\fadeout.bat">con
				exit 0
			) else for %%w in (!pid[%%~1]windows!) do (
				>&3	echo=¤DW	%%~w
				set "windows=!windows: "%%~w" = !"
				if "%%~w"=="!focusedWindow!" (
					set focusedWindow=
					for %%w in (!windows!) do if not defined focusedWindow set "focusedWindow=%%~w"
					set /a ioTotal+=1
					echo=focusedWindow=!focusedWindow!
				)
				if "%%~w"=="!movingWindow!" set movingWindow=
				for /f "tokens=1 delims==" %%a in ('set "win[%%~w]" 2^>nul') do set "%%a="
			)
			for /f %%a in ("!pid[%%~1]parent!") do set "pid[%%~a]subs=!pid[%%~a]subs: "%%~1"=!"
			for /f "tokens=1 delims==" %%a in ('set pid[%%1] 2^>nul') do set "%%a="
		) else if "%%~0"=="createProcess" (
			call :createProcess %%1
		) else if "%%~0"=="exitProcessTree" (
			call :killProcessTree	%%1
		) else if "%%~0"=="config" (
			for /f "tokens=1* delims==" %%x in ("%%~1") do for %%s in (
				lowPerformanceMode
				reduceMotion
			) do if "%%x"=="%%s" (
				set "sys.%%x=%%y"
				set /a ioTotal+=1
				echo=%%x=%%y
			)
		) else if "%%~0"=="powerState" (
			if /I "%%~1"=="shutdown" (
				cd "!sst.dir!"
				call main.bat :loadResourcePack init
				echo=exit
				echo=¤EXIT>&3
				for /l %%# in (1 1 100000) do rem
				echo=%\e%[48;2;0;0;0m%\e%[H%\e%[2J>con
				copy nul "temp\bootStatus-!sst.localtemp!-exit" > nul 2>&1
				set "sst.boot.fadeout=255"
				call "!sst.dir!\boot\fadeout.bat" Shivtanium is shutting down.%\e%[2;HRemaining processes: !processes! >con
				exit 0
			) else if /I "%%~1"=="reboot" (
				echo=exit
				echo=¤EXIT>&3
				cmd /c ping -n 1 127.0.0.1 >nul 2>&1
				echo=%\e%[48;2;0;0;0m%\e%[H%\e%[2J>con
				exit 27
			)
		)
	)
)
:createProcess
set PID=!random!
if "!processes!" neq "!processes: %PID% =!" goto createProcess
if exist "temp\proc\PID-!PID!" goto createProcess
set args=%*
for /f "tokens=1* delims=	" %%a in ("!args!") do (
	set "pid[!PID!]parent=%%~a"
	set "pid[%%~a]subs=!pid[%%~a]subs! "!PID!""
	set "args=%%~b"
)
(
	echo=!args!
)>"temp\proc\PID-!PID!"

set "pid[!pid!]windows= "
set "pid[!pid!]subs= "
set "pid[!pid!]=%~2"
set "processes=!processes!!PID! "
if not defined processes call :kernelPanic "Process list overflow" "The system has started too many processes,\nand it seems like the list has overflown.\nThe system cannot continue."
start /b cmd /c preparePipe.bat !args! <"temp\kernelOut" >&3
exit /b 0
:killProcessTree
set "PID=%~1"
set /a PID=PID, ioTotal+=1
echo=exitProcess=!PID!
for /l %%. in (1 1 100) do if exist "!sst.dir!\temp\PID-!PID!" (
	del "!sst.dir!\temp\PID-!PID:\=!" > nul 2>&1 < nul
)

set "processes=!processes: %PID% = !"
if "!processes: =!"=="" (
	echo=exit
	echo=¤EXIT>&3
	for /l %%# in (1 1 10000) do rem
	echo=%\e%[48;2;0;0;0m%\e%[H%\e%[2J>con
	copy nul "temp\bootStatus-!sst.localtemp!-exit" > nul 2>&1
	call "!sst.dir!\boot\fadeout.bat">con
	exit 0
) else for %%w in (!pid[%PID%]windows!) do (
	>&3	echo=¤DW	%%~w
	set "windows=!windows: "%%~w" = !"
	if "%%~w"=="!focusedWindow!" (
		set focusedWindow=
		for %%w in (!windows!) do if not defined focusedWindow set "focusedWindow=%%~w"
		set /a ioTotal+=1
		echo=focusedWindow=!focusedWindow!
	)
	if "%%~w"=="!movingWindow!" set movingWindow=
	for /f "tokens=1 delims==" %%a in ('set "win[%%~w]" 2^>nul') do set "%%a="
)
if exist "temp\proc\PID-!PID!" del "temp\proc\PID-!PID!" >nul 2>&1 <nul
if defined pid[!pid[%PID%]parent!]subs for /f %%a in ("!pid[%PID%]parent!") do set "pid[%%~a]subs=!pid[%%~a]subs: "%PID%"=!"
for %%p in (!pid[%PID%]subs!) do call :killProcessTree %%~p
for /f "tokens=1 delims==" %%a in ('set "pid[%~1]" 2^>nul') do set "%%a="
exit /b
:kernelPanic
>&3 echo=¤CTRL	BSOD	%1	%2
echo=¤EXIT>&3
echo=exit
set "halt.color=255;;"
set "halt.text=    %~2"
set "halt.tracemsg= At %~1: "

set "halt.text=!halt.text:\n=","    !"
set "halt.pausemsg= Press any key to attempt an exit. . . "
for /f "tokens=2 delims=:" %%a in ('mode con') do (
	set /a counter+=1
	set "token=%%~a"
	if "!counter!"=="2" set /a "halt.modeW=!token: =!-7"
)>nul
for /l %%# in (1 1 100000) do rem
del "temp\DWM-!sst.localtemp!" >nul 2>&1
if not exist "temp\DWM-!sst.localtemp!" (
	for /l %%a in (!halt.modeW! -1 0) do (
		set /p "=%\e%[2;3H%\e%[48;2;!halt.color!m%\e%[38;2;255;255;255m%\e%[?25l Execution halted %\e%[4;3H!halt.tracemsg:~%%a!"
		for /l %%. in (0 1 10000) do rem
		for %%b in ("!halt.text!") do (
			set "halt.line=%%~b "
			set /p "=%\e%[E%\e%[3G !halt.line:~%%a,%halt.modeW%!%\e%7"
		)
		set /p "=%\e%[999;3H%\e%[A!halt.pausemsg:~%%a!%\e%[4;1H"
	) <nul>con
)
set > "!sst.dir!\temp\kernelMemoryDump"
ping -n 2 127.0.0.1 > nul
for /l %%# in () do if defined keysPressed exit 0
exit 0
