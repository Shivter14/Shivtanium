@echo off
setlocal enabledelayedexpansion
for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000),t2=t1"
echo=>> "temp\bootStatus-!sst.localtemp!"
echo=¤EXIT>> "temp\bootStatus-!sst.localtemp!"
:autisticLoop
if not exist "temp\bootStatus-!sst.localtemp!-exit" goto autisticLoop
for /l %%# in (1 1 100000) do rem
del "temp\bootStatus-!sst.localtemp!" > nul 2>&1
del "temp\bootStatus-!sst.localtemp!-exit" > nul 2>&1
set /a sst.boot.fadeout+=1
for /l %%. in () do (
	for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000)", "DeltaTime=(t1-t2)", "t2=t1", "sst.boot.fadeout-=deltaTime*800/sst.boot.fadeout"
	if "!deltaTime!" neq "0" (
		echo=%\e%[38;2;!sst.boot.fadeout!;!sst.boot.fadeout!;!sst.boot.fadeout!;48;2;;;m%\e%[!sst.boot.logoY!;!sst.boot.logoX!H!spr.[bootlogo.spr]!%\e%[!sst.boot.msgY!;!sst.boot.msgX!H%\e%[2K!sst.boot.msg!
	) < nul
	if !sst.boot.fadeout! lss 1 (
		echo=%\e%[48;2;;;;38;2;255;255;255m%\e%[H%\e%[2J%*
		copy nul "!sst.dir!\temp\pf-fadeout" > nul
		exit 0
	)
)
