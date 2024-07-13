@echo off & setlocal enableDelayedExpansion
echo=¤OV	%\e%[!sys.modeH!;1H%\e%[48;2;0;63;127;38;2;255;255;255m Shivtanium %\e%[48;2;0;31;63m%\e%[0K

for /l %%# in () do (
	set kernelOut=
	set /p "kernelOut="
	if defined kernelOut (
		if "!kernelOut!"=="exit" (
			exit 0
		) else if "!kernelOut!"=="exitProcess=!PID!" (
			exit 0
		) else if "!kernelOut:~0,14!"=="focusedWindow=" (
			set "!kernelOut!" >nul 2>&1
			if "!focusedWindow!" neq "systemb_launcher" echo=¤OV	%\e%[999;1H%\e%[48;2;0;63;127;38;2;255;255;255m Shivtanium %\e%[48;2;0;31;63m%\e%[0K !focusedWindow!
		) else if "!kernelOut!"=="click=1" (
			set click=1
			if not defined focusedWindow (
				if "!mouseYpos!"=="!sys.modeH!" if !mouseXpos! leq 12 (
					>>"!sst.dir!\temp\kernelPipe" echo=createProcess	!PID!	systemb-launcher.bat --username "!sys.username!" --UPID !sys.UPID!
				)
			)
		) else set "!kernelOut!" > nul 2>&1
	)
	
)

exit /b 70
