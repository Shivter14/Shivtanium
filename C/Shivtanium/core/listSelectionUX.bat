@echo off & setlocal enableDelayedExpansion
if not defined PID (
	echo=This program requires to be run in the Shivtanium Kernel with DWM enabled.
	<nul set /p "=Press any key to exit. . ."
	pause>nul
)
set /a PID=PID
if not defined lsux.list set lsux.itemCount=
if not defined lsux.itemCount (
	set "secondary_window_params=l2=  This application is a UX element which	l3=  cannot be started as a standalone	l4=  application."
	call "!sst.dir!\systemb\systemb-dialog.bat" "(sys.modeW-w)/2+1" "(sys.modeH-h)/2" 44 7 "listSelectionUX - Error" _ w-buttonW-2 h-2 7 " Close "
	exit 0
)

if not defined win[!PID!.lsux]W (
	set win[!PID!.lsux]W=0
) else set /a win[!PID!.lsux]W-=4
for /l %%a in (1 1 !lsux.itemCount!) do (
	set "$=A!%lsux.list%[%%a]!"
	set "%lsux.list%[%%a]w=0"
	for %%$ in (4096 2048 1024 512 256 128 64 32 16) do if "!$:~%%$!" NEQ "" (
		set /a "%lsux.list%[%%a]w+=%%$"
		set "$=!$:~%%$!"
	)
	set "$=!$:~1!FEDCBA9876543210"
	set /a "%lsux.list%[%%a]w+=0x!$:~15,1!"
	set $=
	if !%lsux.list%[%%a]w! gtr !win[%PID%.lsux]W! set win[!PID!.lsux]W=!%lsux.list%[%%a]w!
)
if not defined win[!PID!.lsux]X set "win[!PID!.lsux]X=!mouseXpos!"
if not defined win[!PID!.lsux]Y set "win[!PID!.lsux]Y=!mouseYpos!"
if !win[%PID%.lsux]W! lss 8 set "win[!PID!.lsux]W=8"
set /a "win[!PID!.lsux]W=(contentW=win[!PID!.lsux]W)+4, win[!PID!.lsux]H=sys.modeH-win[!PID!.lsux]Y-1"

if !win[%PID%.lsux]H! gtr !lsux.itemCount! set win[!PID!.lsux]H=!lsux.itemCount!
set /a "scrollS=1, scrollE=win[!PID!.lsux]H, win[!PID!.lsux]H+=2, contentH=win[!PID!.lsux]H-1, lsux.topui=win[!PID!.lsux]W-2"
echo=¤CW	!PID!.lsux	!win[%PID%.lsux]X!	!win[%PID%.lsux]Y!	!win[%PID%.lsux]W!	!win[%PID%.lsux]H!	 	noCBUI noUnfocusedColors

set cl=1
set "pipe=¤MW	!PID!.lsux	pt="
for /l %%a in (!scrollS! 1 !scrollE!) do (
	set "_pipe=!pipe!"
	
	if defined %lsux.list%[%%a]o (
		if "!cl!"=="1" set "pipe=!pipe!	l!cl!=%\e%8%\e%[A%\e%[38;^!win[!PID!.lsux]TIcolor^!m█^!dwm.bottombuffer:~0,!lsux.topui!^!█"
		set "pipe=!pipe!	o!cl!=%\e%[2C%\e%[!contentW!X!%lsux.list%[%%a]!"
	) else (
		if "!cl!"=="1" (
			set "pipe=!pipe!	l!cl!=%\e%8%\e%[A%\e%[38;^!win[!PID!.lsux]TIcolor^!m█^!dwm.bottombuffer:~0,!lsux.topui!^!█%\e%8%\e%[C%\e%[38;^!win[!PID!.lsux]FGcolor^!m !%lsux.list%[%%a]!"
		) else set "pipe=!pipe!	l!cl!= !%lsux.list%[%%a]!"
	)
	if "!pipe:~1022,1!" neq "" (
		echo=!_pipe!
		if defined %lsux.list%[%%a]o (
			set "pipe=¤MW	!PID!.lsux	o!cl!=%\e%[2C%\e%[!contentW!X!%lsux.list%[%%a]!"
		) else set "pipe=¤MW	!PID!.lsux	l!cl!= !%lsux.list%[%%a]!"
	)
	set /a cl+=1
)
set _pipe=
echo=!pipe!
set pipe=
set cl=

>>"!sst.dir!\temp\kernelPipe" echo=registerWindow	!PID!	!PID!.lsux	!win[%PID%.lsux]X!	!win[%PID%.lsux]Y!	!win[%PID%.lsux]W!	!win[%PID%.lsux]H!	1
for /l %%# in () do (
	set kernelOut=
	set /p kernelOut= && if "!kernelOut:~0,6!"=="click=" (
		set /a "prevClick=click, !kernelOut!, relativeMouseX=mouseXpos-win[!PID!.lsux]X, relativeMouseY=mouseYpos-win[!PID!.lsux]Y"
		if "!click!"=="1" (
			if "!relativeMouseY!" neq "0" if "!relativeMouseY!" neq "!contentH!" (
				set /a "clr=relativeMouseY+scrollS-1, clp=relativeMouseY"
				for %%a in (!clr!) do if defined %lsux.list%[%%a]o (
					echo=¤MW	!PID!.lsux	o!clp!=%\e%[2C%\e%[7m%\e%[!contentW!X!%lsux.list%[%%a]!%\e%[27m
				) else echo=¤MW	!PID!.lsux	l!clp!= %\e%[7m%\e%[!contentW!X!%lsux.list%[%%a]!%\e%[27m
			)
		) else if "!click!"=="0" if defined clr if not defined scroll (
			for %%a in (!clr!) do if defined %lsux.list%[%%a]o (
				echo=¤MW	!PID!.lsux	o!clr!=%\e%[2C%\e%[!contentW!X!%lsux.list%[%%a]!
			) else echo=¤MW	!PID!.lsux	l!clp!= !%lsux.list%[%%a]!
			if "!relativeMouseY!"=="!clp!" call :exit !clr!
			set clr=
			set clp=
		) else (
			if defined scroll if !scrollS! lss 1 (
				for /l %%b in (!scrollS! 1 0) do (
					set /a "scrollS+=1, scrollE+=1"
					set cl=1
					set "pipe=¤MW	!PID!.lsux	pt="
					for /l %%a in (!scrollS! 1 !scrollE!) do (
						set "_pipe=!pipe!"
						
						if defined %lsux.list%[%%a]o (
							if "!cl!"=="1" (
								set "pipe=!pipe!	l!cl!=%\e%8%\e%[A%\e%[38;^!win[!PID!.lsux]TIcolor^!m█^!dwm.bottombuffer:~0,!lsux.topui!^!█"
							) else set "pipe=!pipe!	l!cl!="
							set "pipe=!pipe!	o!cl!=%\e%[2C%\e%[!contentW!X!%lsux.list%[%%a]!"
						) else (
							if "!cl!"=="1" (
								set "pipe=!pipe!	l!cl!=%\e%8%\e%[A%\e%[38;^!win[!PID!.lsux]TIcolor^!m█^!dwm.bottombuffer:~0,!lsux.topui!^!█%\e%8%\e%[C%\e%[38;^!win[!PID!.lsux]FGcolor^!m !%lsux.list%[%%a]!	o!cl!="
							) else set "pipe=!pipe!	l!cl!= !%lsux.list%[%%a]!	o!cl!="
						)
						if "!pipe:~1022,1!" neq "" (
							echo=!_pipe!
							if defined %lsux.list%[%%a]o (
								set "pipe=¤MW	!PID!.lsux	o!cl!=%\e%[2C%\e%[!contentW!X!%lsux.list%[%%a]!	l!cl!="
							) else set "pipe=¤MW	!PID!.lsux	l!cl!= !%lsux.list%[%%a]!	o!cl!="
						)
						set /a cl+=1
					)
					set _pipe=
					echo=!pipe!
					set pipe=
				)
			) else if !scrollE! gtr !lsux.itemCount! (
				for /l %%b in (!scrollE! -1 !lsux.itemCount!) do if "%%~b" neq "!lsux.itemCount!" (
					set /a "scrollE-=1, scrollS-=1"
					set cl=1
					set "pipe=¤MW	!PID!.lsux	pt="
					for /l %%a in (!scrollS! 1 !scrollE!) do (
						set "_pipe=!pipe!"
						
						if defined %lsux.list%[%%a]o (
							if "!cl!"=="1" (
								set "pipe=!pipe!	l!cl!=%\e%8%\e%[A%\e%[38;^!win[!PID!.lsux]TIcolor^!m█^!dwm.bottombuffer:~0,!lsux.topui!^!█"
							) else set "pipe=!pipe!	l!cl!="
							set "pipe=!pipe!	o!cl!=%\e%[2C%\e%[!contentW!X!%lsux.list%[%%a]!"
						) else (
							if "!cl!"=="1" (
								set "pipe=!pipe!	l!cl!=%\e%8%\e%[A%\e%[38;^!win[!PID!.lsux]TIcolor^!m█^!dwm.bottombuffer:~0,!lsux.topui!^!█%\e%8%\e%[C%\e%[38;^!win[!PID!.lsux]FGcolor^!m !%lsux.list%[%%a]!	o!cl!="
							) else set "pipe=!pipe!	l!cl!= !%lsux.list%[%%a]!	o!cl!="
						)
						if "!pipe:~1022,1!" neq "" (
							echo=!_pipe!
							if defined %lsux.list%[%%a]o (
								set "pipe=¤MW	!PID!.lsux	o!cl!=%\e%[2C%\e%[!contentW!X!%lsux.list%[%%a]!	l!cl!="
							) else set "pipe=¤MW	!PID!.lsux	l!cl!= !%lsux.list%[%%a]!	o!cl!="
						)
						set /a cl+=1
					)
					set _pipe=
					echo=!pipe!
					set pipe=
				)
			)
			set scroll=
		)
	) else if "!kernelOut:~0,14!"=="focusedWindow=" (
		if "!kernelOut:~14!" neq "!PID!.lsux" call :exit 0
	) else if "!kernelOut:~0,10!"=="mouseYpos=" (
		if "!prevClick!;!click!"=="1;1" (
			set /a "scroll=(!kernelOut:~10!-win[!PID!.lsux]Y-relativeMouseY), scrollS-=scroll, scrollE-=scroll"
			if "!scroll!" neq "0" (
				set cl=1
				set "pipe=¤MW	!PID!.lsux	pt="
				for /l %%a in (!scrollS! 1 !scrollE!) do (
					set "_pipe=!pipe!"
					
					if defined %lsux.list%[%%a]o (
						if "!cl!"=="1" (
							set "pipe=!pipe!	l!cl!=%\e%8%\e%[A%\e%[38;^!win[!PID!.lsux]TIcolor^!m█^!dwm.bottombuffer:~0,!lsux.topui!^!█"
						) else set "pipe=!pipe!	l!cl!="
						set "pipe=!pipe!	o!cl!=%\e%[2C%\e%[!contentW!X!%lsux.list%[%%a]!"
					) else (
						if "!cl!"=="1" (
							set "pipe=!pipe!	l!cl!=%\e%8%\e%[A%\e%[38;^!win[!PID!.lsux]TIcolor^!m█^!dwm.bottombuffer:~0,!lsux.topui!^!█%\e%8%\e%[C%\e%[38;^!win[!PID!.lsux]FGcolor^!m !%lsux.list%[%%a]!	o!cl!="
						) else set "pipe=!pipe!	l!cl!= !%lsux.list%[%%a]!	o!cl!="
					)
					if "!pipe:~1022,1!" neq "" (
						echo=!_pipe!
						if defined %lsux.list%[%%a]o (
							set "pipe=¤MW	!PID!.lsux	o!cl!=%\e%[2C%\e%[!contentW!X!%lsux.list%[%%a]!	l!cl!="
						) else set "pipe=¤MW	!PID!.lsux	l!cl!= !%lsux.list%[%%a]!	o!cl!="
					)
					set /a cl+=1
				)
				set _pipe=
				echo=!pipe!
				set pipe=
			)
		)
		set /a "prevClick=click, !kernelOut!, relativeMouseY=mouseYpos-win[!PID!.lsux]Y" >nul 2>&1
	) else if "!kernelOut:~0,14!"=="keysPressedRN=" (
		if "!lsux.exitOnKeyPress!"=="True" call :exit 0
	) else if "!kernelOut!"=="exitProcess=!PID!" (
		exit -1
	) else if "!kernelOut!"=="exit" (
		exit -1
	) else set "!kernelOut!" >nul 2>&1
)
:exit
echo=¤DW	!PID!.lsux
>>"!sst.dir!\temp\kernelPipe" echo=unRegisterWindow	!PID!.lsux
exit %1
