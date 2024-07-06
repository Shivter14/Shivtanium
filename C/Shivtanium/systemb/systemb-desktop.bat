@echo off & setlocal enableDelayedExpansion
echo=¤OV	%\e%[999;1H%\e%[48;2;255;255;255;38;2;0;0;0m%\e%[2K systemb-desktop

set /a "win[%PID%.kernelOut]W=64, win[%PID%.kernelOut]H=16, win[%PID%.kernelOut]X=sys.modeW-win[%PID%.kernelOut]W-1, win[%PID%.kernelOut]Y=sys.modeH-win[%PID%.kernelOut]H-2"

echo=¤CW	!PID!.kernelOut	!win[%PID%.kernelOut]X!	!win[%PID%.kernelOut]Y!	!win[%PID%.kernelOut]W!	!win[%PID%.kernelOut]H!	Kernel output	classic
for /l %%# in () do (
	set kernelOut=
	set /p "kernelOut="
	if "!kernelOut!"=="exit" (
		exit 0
	) else set "!kernelOut!" > nul 2>&1
)

exit /b 70
