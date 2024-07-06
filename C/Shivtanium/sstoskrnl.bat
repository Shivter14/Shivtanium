if not defined processes set "processes= "
call :createProcess systemb\systemb-login.bat
set sys.keys=
set keysPressedOld=
set "windows= "
set ioTotal=0
title Shivtanium OS !sys.tag! !sys.ver! !sys.subvinfo!
for /l %%# in () do (
	set "sys.clickOld=!sys.click!"
	set "sys.click=!click!"
	if "!sys.click!" neq "!sys.clickOld!" (
		set sys.mouseXpos=!mouseXpos!
		set sys.mouseYpos=!mouseYpos!
		if !sys.mouseXpos! geq 1 if !sys.mouseXpos! leq !sys.modeW! if !sys.mouseYpos! geq 1 if !sys.mouseYpos! leq !sys.modeH! (
			echo=mouseXpos=!sys.mouseXpos!
			echo=mouseYpos=!sys.mouseYpos!
			echo=click=!sys.click!
			set _focusedWindow=!focusedWindow!
			set focusedWindow=
			if "!sys.click!"=="1" (
				for %%w in (!windows!) do if not defined focusedWindow (
					if !sys.mouseYpos! geq !win[%%~w]Y! if !sys.mouseYpos! leq !win[%%~w]BY! if !sys.mouseXpos! geq !win[%%~w]X! if !sys.mouseXpos! leq !win[%%~w]BX! (
						if "%%~w" neq "!focusedWindow!" (
							set "focusedWindow=%%~w"
							set "windows= %%w!windows: %%w = !"
							echo=focusWindow	%%~w
							>&3 echo=¤FOCUS	%%~w
							set /a ioTotal+=4
							if "!sys.mouseYpos!"=="!win[%%~w]Y!" (
								set /a "movingWindowOffset=sys.mouseXpos-!win[%%~w]X!"
								set "movingWindow=!focusedWindow!"
							)
						)
					)
				)
				if defined _focusedWindow if not defined focusedWindow (
					set /a ioTotal+=1
					echo=focusWindow	
				)
			) else (
				set movingWindow=
				set /a ioTotal+=3
			)
		)
	)
	set sys.mouseXold=!sys.mouseXpos!
	set sys.mouseYold=!sys.mouseYpos!
	if "!random:~0,1!"=="1" (
		set sys.mouseXpos=!mouseXpos!
		set sys.mouseYpos=!mouseYpos!
		if "!sys.mouseXpos!" neq "!sys.mouseXold!" if !sys.mouseXpos! geq 1 if !sys.mouseXpos! leq !sys.modeW! (
			if defined movingWindow (
				set /a "temp=win[!movingWindow!]X=sys.mouseXpos-movingWindowOffset, temps=win[!movingWindow!]BX=win[!movingWindow!]X+win[!movingWindow!]W-1", ioTotal+=1
				if !temp! lss 1 (
					set /a "temp=win[!movingWindow!]X=1, win[!movingWindow!]BX=win[!movingWindow!]W"
				) else if !temps! gtr !sys.modeW! set /a "temp=win[!movingWindow!]X=sys.modeW-win[!movingWindow!]W+1, win[!movingWindow!]BX=sys.modeW"
				echo=win[!movingWindow!]X=!temp!
				>&3 echo=¤MW	!movingWindow!	X=!temp!
				set temp=
				set temps=
			) else if "!sys.click!" neq "0" (
				set /a ioTotal+=1
				echo=mouseXpos=!sys.mouseXpos!
			)
		)
		if "!sys.mouseYpos!" neq "!sys.mouseYold!" if !sys.mouseYpos! geq 1 if !sys.mouseYpos! leq !sys.modeH! (
			if defined movingWindow (
				set /a "temp=win[!movingWindow!]Y=sys.mouseYpos, win[!movingWindow!]BY=win[!movingWindow!]Y+win[!movingWindow!]H-1", ioTotal+=1
				if !temp! lss 1 (
					set /a "temp=win[!movingWindow!]Y=1, win[!movingWindow!]BY=win[!movingWindow!]H"
				) else if !temp! geq !sys.modeH! set /a "temp=win[!movingWindow!]Y=sys.modeH-1, win[!movingWindow!]BY=win[!movingWindow!]Y+win[!movingWindow!]H-1"
				echo=win[!movingWindow!]Y=!temp!
				>&3 echo=¤MW	!movingWindow!	Y=!temp!
				set temp=
			) else if "!sys.click!" neq "0" (
				set /a ioTotal+=1
				echo=mouseYpos=!sys.mouseYpos!
			)
		)
	)
	set "sys.keys= !keysPressed!"
	set "sys.keysRN=!sys.keys:-= !"
	if "!sys.keysRN!" neq "!keysPressedOld!" (
		echo=keysPressed=!sys.keys!
		set /a ioTotal+=1
	)
	for %%k in (!keysPressedOld!) do set "sys.keysRN=!sys.keysRN: %%k = !"
	if "!sys.keysRN: =!" neq "" (
		echo=keysPressedRN=!sys.keysRN!
		set /a ioTotal+=1
	)
	rem if "!sys.keys!"==" -17-18-82-" call :kernelPanic "User triggered crash" "Shivtanium OS !sys.tag! !sys.ver! !sys.subvinfo!\nTotal IO transfers: !ioTotal!"
	set "keysPressedOld=!sys.keys:-= !"

	set io=
	set /p io=
	if defined io for /f "tokens=1* delims=	" %%0 in ("!io!") do (
		if "%%~0"=="registerWindow" (
			for /f "tokens=1-6" %%a in ("%%~1") do (
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
				if "%%~b" neq "!temp.id!" call :kernelPanic	"function registerWindow" "invalid ID"
				set "windows=!windows!"!temp.id!" "
				set "pid[%%~a]windows=!pid[%%~a]windows!"!temp.id!" "
				set "win[!temp.id!]=%%~a"
				set "win[!temp.id!]X=%%~c"
				set "win[!temp.id!]Y=%%~d"
				set "win[!temp.id!]W=%%~e"
				set "win[!temp.id!]H=%%~f"
				set /a "win[!temp.id!]X=win[!temp.id!]X, win[!temp.id!]Y=win[!temp.id!]Y, win[!temp.id!]W=win[!temp.id!]W, win[!temp.id!]H=win[!temp.id!]H, win[!temp.id!]BX=win[!temp.id!]X+win[!temp.id!]W-1, win[!temp.id!]BY=win[!temp.id!]Y+win[!temp.id!]H-1"
			)
		) else if "%%~0"=="unRegisterWindow" (
			set "win[%%~1]="
			set "win[%%~1]X="
			set "win[%%~1]Y="
			set "win[%%~1]W="
			set "win[%%~1]H="
			if "%%~1"=="!focusedWindow!" set focusedWindow=
			if "%%~1"=="!movingWindow!" set movingWindow=
		) else if "%%~0"=="exitProcess" (
			set "PID=%%~1"
			set /a PID=PID
			for /l %%. in (1 1 100) do if exist "!sst.dir!\temp\PID-!PID!" (
				del "!sst.dir!\temp\PID-!PID:\=!" > nul 2>&1 < nul
			) else (
				set "processes=!processes: %%1 = !"
				if "!processes: =!"=="" (
					echo=exit
					echo=¤EXIT>&3
					for /l %%# in (1 1 10000) do rem
					echo=%\e%[48;2;0;0;0m%\e%[H%\e%[2J>con
					call "!sst.dir!\boot\fadeout.bat">con
					exit 0
				) else for %%w in (!pid[%%~1]windows!) do (
					>&3	echo=¤DW	%%~w
					set "windows=!windows: %%w = !"
				)
				for /f "tokens=1 delims==" %%a in ('set pid[%%1] 2^>nul') do set "%%a="
			)
		) else if "%%~0"=="createProcess" call :createProcess %%1
	)
	title !ioTotal!
)
:createProcess
set PID=!random!
if "!processes!" neq "!processes: %PID% =!" goto createProcess
if exist "temp\PID-!PID!" goto createProcess
copy nul "temp\PID-!PID!" > nul
set "pid[!pid!]windows= "
set "processes=!processes!!PID! "
if not defined processes call :kernelPanic "Process list overflow" "The system has started too many processes,\nand it seems like the list has overflown.\nThe system cannot continue."
start /b cmd /c preparePipe.bat %* <"temp\kernelOut" >&3
exit /b 0
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
ping -n 2 127.0.0.1 > nul
pause<con>nul
exit 0
