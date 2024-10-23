@if not defined sst.dir (
	@echo off & setlocal enableDelayedExpansion & for /f %%a in ('echo prompt $E^| cmd') do set "\e=%%a" & call :kernelPanic "Invalid environment" "The Shivtanium kernel requires to be run in main.bat"
)
for /f "tokens=1 delims==" %%a in ('set dwm. 2^>nul ^& set spr. 2^>nul ^& set ssvm. 2^>nul') do set "%%a="
cd "!sst.dir!" || call :kernelPanic "Unable to locate system directory" "The system failed to start:\nValue sst.dir: '!sst.dir!'\n ^^^^^^  Invalid directory."
if not exist "temp\proc" md "temp\proc"
if not defined processes set "processes= "
if !sys.CPU.count! lss 4 (
	if "!sys.lowPerformanceMode!" neq "True" set "temp.nr=o6=%\e%[2C Tip: Set the following value in settings.dat: 	l7= %\e%[7m lowPerformanceMode=True%\e%[23X%\e%[27m"
	call :createProcess 0	systemb-dialog.bat 5 3 59 9 "Performance notification	noCBUI" "l2=  Your CPU only has !sys.CPU.count! logical processor(s).	l3=  This might lead to a bad experience.	l4=  The recommended minimum of logical processors is: 4	!temp.nr!" 50 7 7 " Close "
	set temp.nr=
)
if /I "%~1"=="/forceoobe" (
	call :createProcess 0	systemb-oobe.bat
) else if "%~1"=="/autorun" (
	set args=%*
	call :createProcess 0	!args:*/autorun=!
) else if not exist "!sst.root!\users" (
	call :createProcess 0	systemb-oobe.bat
) else (
	if exist "!asset[\sounds\boot.mp3]!" start "<Shivtanium startup sound handeler> (ignore this)" /min cscript.exe //b core\playsound.vbs "!asset[\sounds\boot.mp3]!"
	for %%a in (!sst.autorun!) do call :createProcess %%~a
)
set sst.autorun=
set sys.keys=
set keysPressedOld=
set "windows= "
set "windowsT= "
set ioTotal=0
title Shivtanium OS !sys.tag! !sys.ver! !sys.subvinfo!

set "clamp=(leq=((low-x)>>31)+1)*low+(geq=((x-high)>>31)+1)*high+^^^!(leq+geq)*x"
(
set clamp=
for /l %%# in () do (
	set "keysPressedOld=!sys.keys:-= !"
	
	if "!sys.keys:~0,8!"==" -17-18-" if defined sys.keysRN (
		if "!sys.keysRN!"=="  82 " (
			call :kernelPanic "User triggered crash" "Shivtanium OS !sys.tag! !sys.ver! !sys.subvinfo!\nTotal IO transfers: !ioTotal!\nA memory dump has been created at: ~:\Shivtanium\temp\KernelMemoryDump\nA window manager dump has been created at: ~:\Shivtanium\temp\DWM-!sst.localtemp!-memoryDump"
		) else if "!sys.keysRN!"=="  84 " (
			echo=exit
			set /a ioTotal+=1
			(for %%w in (!windows!) do (
				echo=¤DW	%%~w
			))>&3
			for /f %%a in ('set pid 2^>nul ^& set win 2^>nul') do set "%%a="
			del /q "!sst.dir!\temp\proc\PID-*" > nul
			set "processes= "
			set "windows= "
			set "windowsT= "
			set focusedWindow=
			set movingWindow=
			set movingWindowOffset=
			
			call :createProcess 0	systemb-login.bat
		) else if "!sys.keysRN!"=="  69 " (
			call :createProcess	0	systemb-taskmgr.bat
		) else if "!sys.keysRN!"=="  90 " (
			call :createProcess 0	systemb-devutil.bat
		)
	)
	set "sys.clickOld=!sys.click!"
	set "sys.click=!click!"
	if "!sys.click!" neq "!sys.clickOld!" (
		set sys.mouseXpos=!mouseXpos!
		set sys.mouseYpos=!mouseYpos!
		if !sys.mouseXpos! geq 1 if !sys.mouseXpos! leq !sys.modeW! if !sys.mouseYpos! geq 1 if !sys.mouseYpos! leq !sys.modeH! (
			if "!sys.click!" neq "0" (
				set "_focusedWindow=!focusedWindow!"
				set focusedWindow=
				for %%w in (!windows!) do if not defined focusedWindow (
					if !sys.mouseYpos! geq !win[%%~w]Y! if !sys.mouseYpos! leq !win[%%~w]BY! if !sys.mouseXpos! geq !win[%%~w]X! if !sys.mouseXpos! leq !win[%%~w]BX! (
						if "%%~w" neq "!_focusedWindow!" (
							set "windows= %%w!windows: %%w = !"
							echo=focusedWindow=%%~w
							>&3 echo=¤FOCUS	%%~w
							set /a ioTotal+=1
						)
						set "focusedWindow=%%~w"
						if "!sys.keys!" neq "!sys.keys:-18-=!" (
							if "!win[%%~w]D:~0,1!" neq "1" if "!sys.click!"=="1" (
								set "movingWindow=!focusedWindow!"
								set /a "movingWindowOffsetX=sys.mouseXpos-!win[%%~w]X!, movingWindowOffsetY=sys.mouseYpos-!win[%%~w]Y!, tempX=!win[%%~w]X!, tempY=!win[%%~w]Y!"
							)
						) else if "!sys.mouseYpos!"=="!win[%%~w]Y!" (
							if "!mouseXpos!;!win[%%~w]D:~2,1!"=="!win[%%~w]X!;1" (
								set /a ioTotal+=1
								set "resizingWindow=!focusedWindow!"
								echo=resizingWindow=!focusedWindow!
								set originBY=true
								set originBX=true
							) else if "!win[%%~w]D:~0,1!" neq "1" (
								set /a "movingWindowOffsetX=sys.mouseXpos-!win[%%~w]X!, tempX=!win[%%~w]X!, tempY=!win[%%~w]Y!"
								set "movingWindow=!focusedWindow!"
							)
						) else if "!win[%%~w]D:~2,1!"=="1" if "!mouseYpos!"=="!win[%%~w]BY!" (
							set /a ioTotal+=1
							echo=resizingWindow=!focusedWindow!
							set "resizingWindow=!focusedWindow!"
							set originY=true
							if "!mouseXpos!"=="!win[%%~w]BX!" (
								set originX=true
							) else if "!mouseXpos!"=="!win[%%~w]X!" (
								set originBX=true
							)
						) else if "!mouseXpos!"=="!win[%%~w]BX!" (
							set /a ioTotal+=1
							echo=resizingWindow=!focusedWindow!
							set "resizingWindow=!focusedWindow!"
							set originX=true
						) else if "!mouseXpos!"=="!win[%%~w]X!" (
							set /a ioTotal+=1
							echo=resizingWindow=!focusedWindow!
							set "resizingWindow=!focusedWindow!"
							set originBX=true
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
					if not defined tempX call :kernelPanic "Fatal error in kernel-side window manager" "Attempted to move a window to an undefined position. This is a critical bug, please report it at: github.com/Shivter14/Shivtanium/issues"
					echo=win[!movingWindow!]X=!tempX!
					echo=win[!movingWindow!]Y=!tempY!
					set movingWindow=& set tempX=& set tempY=& set movingWindowOffsetX=& set movingWindowOffsetY=
				) else if defined resizingWindow (
					set /a ioTotal+=8
					echo=win[!resizingWindow!]X=!tempX!
					echo=win[!resizingWindow!]Y=!tempY!
					echo=win[!resizingWindow!]W=!tempW!
					echo=win[!resizingWindow!]H=!tempH!
					echo=resizingWindow=
					set resizingWindow=
					for /f "delims==" %%a in ('set temp 2^>nul ^& set origin 2^>nul') do set "%%a="
				) else set /a ioTotal+=3
			)
			echo=mouseXpos=!sys.mouseXpos!
			echo=mouseYpos=!sys.mouseYpos!
			if "!sys.keys!;!resizingWindow!"=="!sys.keys:-18-=!;" (
				echo=click=!sys.click!
			) else set /a ioTotal-=1
		)
	)
	set sys.mouseXold=!sys.mouseXpos!
	set sys.mouseYold=!sys.mouseYpos!
	if "!random:~0,1!"=="1" (
		set sys.mouseXpos=!mouseXpos!
		set sys.mouseYpos=!mouseYpos!
		if "!sys.mouseXold!;!sys.mouseYold!" neq "!sys.mouseXpos!;!sys.mouseYpos!" if defined movingWindow (
			set /a "tempX=win[!movingWindow!]X=sys.mouseXpos-movingWindowOffsetX, temps=win[!movingWindow!]BX=win[!movingWindow!]X+win[!movingWindow!]W-1", "tempY=win[!movingWindow!]Y=sys.mouseYpos-movingWindowOffsetY, win[!movingWindow!]BY=win[!movingWindow!]Y+win[!movingWindow!]H-1"
			if !tempX! lss 1 (
				set /a "tempX=win[!movingWindow!]X=1, win[!movingWindow!]BX=win[!movingWindow!]W"
			) else if !temps! gtr !sys.modeW! set /a "tempX=win[!movingWindow!]X=sys.modeW-win[!movingWindow!]W+1, win[!movingWindow!]BX=sys.modeW"
			if !tempY! lss 1 (
				set /a "tempY=win[!movingWindow!]Y=1, win[!movingWindow!]BY=win[!movingWindow!]H"
			) else if !tempY! geq !sys.modeH! set /a "tempY=win[!movingWindow!]Y=sys.modeH-1, win[!movingWindow!]BY=win[!movingWindow!]Y+win[!movingWindow!]H-1"
			>&3 echo=¤MW	!movingWindow!	X=!tempX!	Y=!tempY!
			set temps=
		) else if defined resizingWindow (
			if "!sys.mouseXold!" neq "!sys.mouseXpos!" (
				if defined originX (
					set /a "x=sys.mouseXpos, low=tempMX=win[!resizingWindow!]X+win[!resizingWindow!]mW-1, temp.mouseXpos=%clamp:high=sys.modeW%, win[!resizingWindow!]W=tempW=(tempBX=win[!resizingWindow!]BX=temp.mouseXpos)-(tempX=win[!resizingWindow!]X)+1, tempY=win[!resizingWindow!]Y, tempBY=win[!resizingWindow!]BY, tempH=win[!resizingWindow!]H"
				) else if defined originBX (
					set /a "x=sys.mouseXpos, tempMX=win[!resizingWindow!]BX-win[!resizingWindow!]mW+1, low=1, temp.mouseXpos=%clamp:high=tempMX%, win[!resizingWindow!]W=tempW=(tempBX=win[!resizingWindow!]BX)-(tempX=win[!resizingWindow!]X=temp.mouseXpos)+1, tempY=win[!resizingWindow!]Y, tempBY=win[!resizingWindow!]BY, tempH=win[!resizingWindow!]H"
				)
			)
			if "!sys.mouseYold!" neq "!sys.mouseYpos!" (
				if defined originY (
					set /a "x=sys.mouseYpos, low=tempMY=win[!resizingWindow!]Y+win[!resizingWindow!]mH-1, temp.mouseYpos=%clamp:high=(sys.modeH-1)%, tempX=win[!resizingWindow!]X, tempBX=win[!resizingWindow!]BX, tempW=win[!resizingWindow!]W, tempH=win[!resizingWindow!]H=(tempBY=win[!resizingWindow!]BY=temp.mouseYpos)-(tempY=win[!resizingWindow!]Y)+1"
				) else if defined originBY (
					set /a "x=sys.mouseYpos, tempMY=win[!resizingWindow!]BY-win[!resizingWindow!]mH+1, low=1, temp.mouseYpos=%clamp:high=tempMY%, tempX=win[!resizingWindow!]X, tempBX=win[!resizingWindow!]BX, tempW=win[!resizingWindow!]W, tempH=win[!resizingWindow!]H=(tempBY=win[!resizingWindow!]BY)-(tempY=win[!resizingWindow!]Y=temp.mouseYpos)+1"
				)
			)
			set x=& set low=
			if "!sys.mouseXold!;!sys.mouseYold!" neq "!sys.mouseXpos!;!sys.mouseYpos!" (
				echo=¤CW	!resizingWindow!	!tempX!	!tempY!	!tempW!	!tempH!	^^!win[!resizingWindow!]title:~1^^!	^^!win[!resizingWindow!]theme^^!
				echo=¤CTRL	DUMP	mainbuffer=^^!dwm.scene^^!	nul
			)>&3
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
	if "!sys.keysRN!" neq "!keysPressedOld!" (
		echo=keysPressed=!sys.keys!
		set /a ioTotal+=1
	)
	for %%k in (!keysPressedOld!) do set "sys.keysRN=!sys.keysRN: %%k = !"
	if defined focusedWindow (
		if "!sys.keysRN: =!" neq "" (
			echo=keysPressedRN=!sys.keysRN!
			set /a ioTotal+=1
		)
	)

	set /p io=&&for /f "tokens=1* delims=	" %%0 in ("!io!") do if "%%~0"=="registerWindow" (
		for /f "tokens=1-9 delims=	" %%a in ("!io:~15!") do (
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
			set "temp.d=%%~g"
			set "windows= "!temp.id!"!windows!"
			if "!temp.d:~1,1!" neq "1" (
				set "windowsT=!windowsT!"!temp.id!" "
				set /a ioTotal+=1
				echo=windowsT=!windowsT!
			)
			set "pid[%%~a]windows=!pid[%%~a]windows!"!temp.id!" "
			set "win[!temp.id!]=%%~a"
			set "win[!temp.id!]X=%%~c"
			set "win[!temp.id!]Y=%%~d"
			set "win[!temp.id!]W=%%~e"
			set "win[!temp.id!]H=%%~f"
			set "win[!temp.id!]D=!temp.d!"
			if "!temp.d:~2,1!"=="1" if "%%~h"=="" (
				set "win[!temp.id!]mW=%%~e"
				set "win[!temp.id!]mH=%%~f"
			) else if "%%~i"=="" (
				set "win[!temp.id!]mW=%%~h"
				set "win[!temp.id!]mH=%%~f"
			) else (
				set "win[!temp.id!]mW=%%~h"
				set "win[!temp.id!]mH=%%~i"
			)
			set /a "win[!temp.id!]X=win[!temp.id!]X, win[!temp.id!]Y=win[!temp.id!]Y, win[!temp.id!]W=win[!temp.id!]W, win[!temp.id!]H=win[!temp.id!]H, win[!temp.id!]BX=win[!temp.id!]X+win[!temp.id!]W-1, win[!temp.id!]BY=win[!temp.id!]Y+win[!temp.id!]H-1", ioTotal+=1
			set "focusedWindow=!temp.id!"
			echo=focusedWindow=!temp.id!
			set temp.id= & set temp.d=
		)
	) else if "%%~0"=="unRegisterWindow" (
		set "windows=!windows: "%%~1"=!"
		set "windowsT=!windowsT: "%%~1"=!"
		for /f "tokens=1* delims==" %%a in ('set "win[%%~1]" 2^>nul') do (
			if "%%a"=="win[%%~1]" set "pid[%%b]windows=!pid[%%b]windows: "%%~1"=!"
			set "%%a="
		)
		if "%%~1"=="!focusedWindow!" (
			set /a ioTotal+=1
			echo=focusedWindow=
			set focusedWindow=
		)
		for /f "delims==" %%a in ('set temp 2^>nul ^& set origin 2^>nul') do set "%%a="
		if "%%~1"=="!movingWindow!" set movingWindow=
		if "%%~1"=="!resizingWindow!" set resizingWindow=
	) else if "%%~0"=="exitProcess" (
		set "PID=%%~1"
		set /a PID=PID
		if "!PID!" neq "%%~1" call :kernelPanic "Invalid Process ID" "At function 'exitProcess':\n  Invalid Process ID: `%%~1` (NaN)\nThis is either a fatal error, or some program missbehaving.\nA memory dump has been created at: ~:\Shivtanium\temp\KernelMemoryDump"
		for /l %%. in (1 1 100) do if exist "!sst.dir!\temp\proc\PID-!PID!" (
			del "!sst.dir!\temp\proc\PID-!PID:\=!" > nul 2>&1 < nul
		)
		if exist "temp\proc\PID-!PID!" del "temp\proc\PID-!PID!" >nul 2>&1 <nul
		set "processes=!processes: %%1 = !"
		if "!processes: =!"=="" (
			call :shutdown 0
		) else for %%w in (!pid[%%~1]windows!) do (
			>&3	echo=¤DW	%%~w
			set "windows=!windows: "%%~w" = !"
			set "windowsT=!windowsT: "%%~w" = !"
			if "%%~w"=="!focusedWindow!" (
				set focusedWindow=
				for %%w in (!windows!) do if not defined focusedWindow set "focusedWindow=%%~w"
			)
			for /f "delims==" %%a in ('set temp 2^>nul ^& set origin 2^>nul') do set "%%a="
			if "%%~w"=="!movingWindow!" set movingWindow=
			if "%%~w"=="!resizingWindow!" set resizingWindow=
			for /f "tokens=1 delims==" %%a in ('set "win[%%~w]" 2^>nul') do set "%%a="
		)
		set /a ioTotal+=2
		echo=focusedWindow=!focusedWindow!
		echo=windowsT=!windowsT!
		>&3 echo=¤FOCUS	!focusedWindow!
		for /f %%a in ("!pid[%%~1]parent!") do set "pid[%%~a]subs=!pid[%%~a]subs: "%%~1"=!"
		for /f "tokens=1 delims==" %%a in ('set pid[%%1] 2^>nul') do set "%%a="
	) else if "%%~0"=="createProcess" (
		call :createProcess %%1
	) else if "%%~0"=="exitProcessTree" (
		call :killProcessTree	%%1
		set /a ioTotal+=1
		echo=windowsT=!windowsT!
	) else if "%%~0"=="config" (
		for /f "tokens=1* delims==^!" %%x in ("!io:~7!") do for %%s in (
			lowPerformanceMode
			reduceMotion
		) do if "%%x"=="%%s" (
			set "sys.%%x=%%y"
			set /a ioTotal+=1
			echo=sys.%%x=%%y
			if /I "%%x=%%y"=="lowPerformanceMode=True" (
				for %%w in (!windows!) do (
					echo=¤CW	%%~w	!win[%%~w]X!	!win[%%~w]Y!	!win[%%~w]W!	!win[%%~w]H!	^^!win[%%~w]title:~1^^!	classic
				)
			) >&3
		)
	) else if "%%~0"=="minimizeWindow" (
		for /f "tokens=1* delims=	" %%1 in ("!io:~15!") do (
			if not defined win[%%~2] call :kernelPanic "Function minimizeWindow failed" "Tried to minimize a non-existent window.\nProcess: %%~1\nWindow: %%~2"
			set "windows=!windows: "%%~2"=!"
			if "!focusedWindow!"=="%%~2" (
				set focusedWindow=
				for %%w in (!windows!) do if not defined focusedWindow set "focusedWindow=%%~w"
				set /a ioTotal+=1
				echo=focusedWindow=!focusedWindow!
				>&3 echo=¤FOCUS	!focusedWindow!
			)
			if "!movingWindow!"=="%%~2" set movingWindow=
			if defined win[%%~2]off call :kernelPanic "Function minimizeWindow failed" "Tried to minimize a window, which was already minimized.\nProcess: %%~1\nWindow: %%~2"
			if not exist "!sst.dir!\temp\DWM-offload" md "!sst.dir!\temp\DWM-offload" || call :kernelPanic "Function minimizeWindow failed" "Failed to create directory: ~\temp\DWM-offload\nProcess: %%~1\nWindow: %%~2"
			if exist "!sst.dir!\temp\DWM-offload\snapshot.%%~2" call :kernelPanic "Function minimizeWindow failed" "Window is already minimized"
			(
				echo=¤CTRL	DUMP	win[%%~2]	"!sst.dir!\temp\DWM-offload\snapshot.%%~2"
				echo=¤DW	%%~2
			) >&3
			set "win[%%~2]off=1"
		)
	) else if "%%~0"=="restoreWindow" (
		for /f "tokens=1* delims=	" %%1 in ("!io:~14!") do (
			if not defined win[%%~2] call :kernelPanic "Function restoreWindow failed" "Tried to restore a non-existent window.\nProcess: %%~1\nWindow: %%~2"
			set "focusedWindow=%%~2"
			if defined win[%%~2]off (
				if not exist "!sst.dir!\temp\DWM-offload" call :kernelPanic "Function restoreWindow failed" "DWM offload memory was lost.\nProcess: %%~1\nWindow: %%~2"
				if not exist "!sst.dir!\temp\DWM-offload\snapshot.%%~2" call :kernelPanic "Function restoreWindow failed" "DWM offload memory for the window being currently restored was lost.\nProcess: %%~1\nWindow: %%~2"
				echo=win[%%~2]X=!win[%%~2]X!
				echo=win[%%~2]Y=!win[%%~2]Y!
				set /a ioTotal+=3
			) else set /a ioTotal+=1
			(
				if defined win[%%~2]off (
					echo=¤CTRL	LOAD	"!sst.dir!\temp\DWM-offload\snapshot.%%~2"	/deleteAfterLoad
					echo=¤MW	%%~2	x=!win[%%~2]X!	y=!win[%%~2]Y!
				)
				echo=¤FOCUS	%%~2
			) >&3
			set "windows= "%%~2"!windows: "%%~2"=!"
			echo=focusedWindow=!focusedWindow!
			set "win[%%~2]off="
		)
	) else if "%%~0"=="modifyWindowProperties" (
		for /f "tokens=1-6" %%b in ("!io:~23!") do (
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
			if not defined win[!temp.id!] call :kernelPanic "Attempted to modify non-existent window" "At function 'modifyWindowProperties':\n  Unknown window: '!temp.id!'"
			set "win[!temp.id!]X=%%~c"
			set "win[!temp.id!]Y=%%~d"
			if "%%~f" neq "" (
				set "win[!temp.id!]W=%%~e"
				set "win[!temp.id!]H=%%~f"
				if "%%~g" neq "" set "win[!temp.id!]D=%%~g"
			) else if "%%~e" neq "" set "win[!temp.id!]D=%%~e"
			set /a "win[!temp.id!]X=win[!temp.id!]X, win[!temp.id!]Y=win[!temp.id!]Y, win[!temp.id!]W=win[!temp.id!]W, win[!temp.id!]H=win[!temp.id!]H, win[!temp.id!]BX=win[!temp.id!]X+win[!temp.id!]W-1, win[!temp.id!]BY=win[!temp.id!]Y+win[!temp.id!]H-1"
			set temp.id=
		)
	) else if "%%~0"=="powerState" (
		if /I "%%~1"=="shutdown" (
			call :shutdown 0
		) else if /I "%%~1"=="reboot" (
			call :shutdown 27
		) else if /I "%%~1"=="fastReboot" (
			call :shutdown 13
		)
	) else (
		>&2 echo=[!date! !time!] Invalid kernel call: !io!
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
	set "args=%%b"
)
(
	echo=!args!
)>"temp\proc\PID-!PID!"

set "pid[!pid!]windows= "
set "pid[!pid!]subs= "
set "pid[!pid!]=%~2"
set "processes=!processes!!PID! "
if not defined processes call :kernelPanic "Process list overflow" "The system has started too many processes,\nand it seems like the list has overflown.\nThe system cannot continue."
set "startTime=!time!"
start /b cmd /c preparePipe.bat !args! <"temp\kernelOut" >&3
exit /b
:killProcessTree
set "PID=%~1"
set /a PID=PID, ioTotal+=1
if "!PID!" neq "%~1" call :kernelPanic "Invalid Process ID" "At function 'exitProcess':\n  Invalid Process ID: `%%~1` (NaN)\nThis is either a fatal error, or some program missbehaving.\nA memory dump has been created at: ~:\Shivtanium\temp\KernelMemoryDump"
echo=exitProcess=!PID!
for /l %%. in (1 1 100) do if exist "!sst.dir!\temp\proc\PID-!PID!" (
	del "!sst.dir!\temp\proc\PID-!PID:\=!" > nul 2>&1 < nul
)

set "processes=!processes: %PID% = !"
if "!processes: =!"=="" (
	call :shutdown
) else for %%w in (!pid[%PID%]windows!) do (
	>&3	echo=¤DW	%%~w
	set "windows=!windows: "%%~w" = !"
	set "windowsT=!windowsT: "%%~w" = !"
	if "%%~w"=="!focusedWindow!" (
		set focusedWindow=
		for %%w in (!windows!) do if not defined focusedWindow set "focusedWindow=%%~w"
		set /a ioTotal+=1
		echo=focusedWindow=!focusedWindow!
		>&3 echo=¤FOCUS	!focusedWindow!
	)
	for /f "delims==" %%a in ('set temp 2^>nul ^& set origin 2^>nul') do set "%%a="
	if "%%~w"=="!movingWindow!" set movingWindow=
	if "%%~w"=="!resizingWindow!" set resizingWindow=
	for /f "tokens=1 delims==" %%a in ('set "win[%%~w]" 2^>nul') do set "%%a="
)
if exist "temp\proc\PID-!PID!" del "temp\proc\PID-!PID!" >nul 2>&1 <nul
if defined pid[!pid[%PID%]parent!]subs for /f %%a in ("!pid[%PID%]parent!") do set "pid[%%~a]subs=!pid[%%~a]subs: "%PID%"=!"
for %%p in (!pid[%PID%]subs!) do call :killProcessTree %%~p
for /f "delims==" %%a in ('set "pid[%~1]" 2^>nul') do set "%%a="
exit /b
:kernelPanic trace text
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
:shutdown
md "!sst.dir!\temp\shutdown"
echo=exit
(
	echo=¤CTRL	DUMP	dwm.aero	"!sst.dir!\temp\shutdown\DWM-memoryDump"
	echo=¤EXIT
) >&3
for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "timeOut=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100 + 100"
:shutdown.waitForDWM
for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t2=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100"
if not exist "!sst.dir!\temp\shutdown\DWM-memoryDump" if !t2! leq !timeOut! goto shutdown.waitForDWM
for /l %%y in (1 1 !sys.modeH!) do set "dmp.dwm.aero[%%y]=2;%%y;%%y;%%y"
if exist "!sst.dir!\temp\shutdown\DWM-memoryDump" for /f "usebackq tokens=1* delims==" %%a in ("!sst.dir!\temp\shutdown\DWM-memoryDump") do set "dmp.%%~a=%%~b"

set "ts=!t2!"
set "anim=0"
set "fadeout=255"
set "modeH=!sys.modeH!" & set "modeW=!sys.modeW!"

set "_SIN=a-a*a/1920*a/312500+a*a/1920*a/15625*a/15625*a/2560000-a*a/1875*a/15360*a/15625*a/15625*a/16000*a/44800000"
set "sinr=(a=(x)%%62832, c=(a>>31|1)*a, a-=(((c-47125)>>31)+1)*((a>>31|1)*62832)  +  (-((c-47125)>>31))*( (((c-15709)>>31)+1)*(-(a>>31|1)*31416+2*a)  ), !_SIN!) / 10000"
set "sinr=!sinr: =!"
set "cosr=(a=(15708 - x)%%62832, c=(a>>31|1)*a, a-=(((c-47125)>>31)+1)*((a>>31|1)*62832)  +  (-((c-47125)>>31))*( (((c-15709)>>31)+1)*(-(a>>31|1)*31416+2*a)  ), !_SIN!) / 10000"
set "cosr=!cosr: =!"
set "sin=(a=((x*31416/180)%%62832)+(((x*31416/180)%%62832)>>31&62832), b=(a-15708^a-47124)>>31,a=(-a&b)+(a&~b)+(31416&b)+(-62832&(47123-a>>31)),a-a*a/1875*a/320000+a*a/1875*a/15625*a/16000*a/2560000-a*a/1875*a/15360*a/15625*a/15625*a/16000*a/44800000) / 10000"
set "cos=(a=((15708-x*31416/180)%%62832)+(((15708-x*31416/180)%%62832)>>31&62832), b=(a-15708^a-47124)>>31,a=(-a&b)+(a&~b)+(31416&b)+(-62832&(47123-a>>31)),a-a*a/1875*a/320000+a*a/1875*a/15625*a/16000*a/2560000-a*a/1875*a/15360*a/15625*a/15625*a/16000*a/44800000) / 10000"
set /a "PI=(35500000/113+5)/10, HALF_PI=(35500000/113/2+5)/10, TAU=TWO_PI=2*PI, PI32=PI+HALF_PI"
if exist "!sst.boot.dir!" (
	if "%~1"=="27" copy nul "!sst.boot.dir!\befiReboot.cww" > nul
	if "%~1"=="13" >"!sst.boot.dir!\befiReboot.cww" echo 13
)
(for /l %%# in () do (
	for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100, deltaTime=(t1 - t2), t2=t1, x=(t1 - ts) * 200, _anim=anim, shift=(anim = 1 + sys.modeW * !sinr!) - _anim"
	if !shift! geq 1 (
		set "buffer=%\e%[H"
		for /l %%y in (1 1 !sys.modeH!) do (
			set "buffer=!buffer!%\e%[48;!dmp.dwm.aero[%%y]!m%\e%[!shift!P%\e%[E"
		)
		set /p "=!buffer!"
		if !anim! geq !sys.modeW! (
			for /l %%# in () do (
				for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100, fadeout-=(deltaTime=(t1 - t2))*4, t2=t1"
				set "buffer=%\e%[H"
				for /l %%x in (1 1 !sys.modeH!) do (
					set /a "x=%%x", "!dmp.dwm.aero:×=*!", "r=r*fadeout/255, g=g*fadeout/255, b=b*fadeout/255"
					set "buffer=!buffer!%\e%[48;2;!r!;!g!;!b!m%\e%[2K%\e%[B"
				)
				set /p "=!buffer!"
				if !fadeout! lss 1 exit 0
			)
		)
	)
)) < nul > con
exit %1
