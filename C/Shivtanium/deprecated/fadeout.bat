@echo off
setlocal enabledelayedexpansion
echo=>> "!sst.dir!\temp\bootStatus-!sst.localtemp!"
echo=¤EXIT>> "!sst.dir!\temp\bootStatus-!sst.localtemp!"
set wait=1
:autisticLoop
set /a wait+=1
if !wait! lss 10000 if not exist "!sst.dir!\temp\bootStatus-!sst.localtemp!-exit" goto autisticLoop
del "!sst.dir!\temp\bootStatus-!sst.localtemp!" > nul 2>&1
del "!sst.dir!\temp\bootStatus-!sst.localtemp!-exit" > nul 2>&1
set sst.boot.fadeout=255
for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000),t2=t1"
for /l %%. in () do (
	for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000)", "DeltaTime=(t1-t2)", "t2=t1", "sst.boot.fadeout-=deltaTime*500/sst.boot.fadeout"
	if "!deltaTime!" neq "0" (
		echo=%\e%[38;2;!sst.boot.fadeout!;!sst.boot.fadeout!;!sst.boot.fadeout!;48;2;;;m%\e%[!sst.boot.logoY!;!sst.boot.logoX!H!spr.[bootlogo.spr]!%\e%[!sst.boot.msgY!;!sst.boot.msgX!H%\e%[2K!sst.boot.msg!
	) < nul
	if !sst.boot.fadeout! lss 1 (
		echo=%\e%[48;2;;;;38;2;255;255;255m%\e%[H%\e%[2J%*
		copy nul "!sst.dir!\temp\pf-fadeout" > nul
		exit 0
	)
)
