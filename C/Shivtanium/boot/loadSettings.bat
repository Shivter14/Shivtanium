if not exist "!sst.dir!\settings.dat" call main.bat :halt "%~0" "Failed to load 'settings.dat':\n  File not found."

set "sys.bootVars=bootVars noResize font textMode useAltWinCtrlChars"
set "sys.activeResourcePacks=init"
set "sys.loginTheme=metroTyper"
set "sys.windowManager=dwm.bat"
set "sst.boot.fadeout=255"
set "sys.noResize=True"

set "sys.fontW=8"
set "sys.fontH=16"
set "sys.font=MxPlus IBM VGA 8x16"

if not defined sst.autorun set sst.autorun="0	systemb-login"

for /f "usebackq tokens=1* delims==" %%a in ("!sst.dir!\settings.dat") do set "sys.%%~a=%%~b"
(
	>&2 echo=[!date! !time!] Shivtanium version !sys.tag! !sys.ver! !sys.subvinfo!
	>&2 echo=[!date! !time!] [Startup/loadSettings] Translating variables:
	for %%a in (
		sys.boot.fadeout:sst.boot.fadeout
		sys.wmReqChainLimit:dwm.commandChainLimit
		PROCESSOR_ARCHITECTURE:sys.CPU.architecture:1
		PROCESSOR_IDENTIFIER:sys.CPU.identifier
		PROCESSOR_LEVEL:sys.CPU.level
		PROCESSOR_REVISION:sys.CPU.revision
		NUMBER_OF_PROCESSORS:sys.CPU.count:1
	) do for /f "tokens=1-3 delims=:" %%i in ("%%~a") do if defined %%i (
		set "%%j=!%%i!"
		set "%%i="
		if defined %%j (
			>&2 echo=    %%i -^> %%j ^| !%%i!
		) else if "%%~k"=="1" call main.bat :halt "%~n0" "Failed to translate variable: %%i -> %%j"
	)
)

if defined sys.autorun (
	>&2 echo=[!date! !time!] [Startup/loadSettings] Additional startup tasks: !sys.autorun!
	set sst.autorun=!sst.autorun! !sys.autorun!
	set sys.autorun=
)
if defined sys.textMode if /I "!sys.textMode!" neq "default" (
	for /f "delims=" %%a in ("!sys.textMode!") do set "sys.textMode=!sst.boot.textmode[%%~a]!"
) else set sys.textMode=
if defined sys.textMode (
	set /a "sys.modeW=!sys.textMode:,=,sys.modeH=!"
	if !sys.modeW! lss 64 set sys.modeW=64
	if !sys.modeH! lss 16 set sys.modeW=16
	>&2 echo=[!date! !time!] [Startup/loadSettings] Changing text mode to !sys.modeW! columns, !sys.modeH! lines
	>>"!sys.dir!\temp\bootStatus-!sst.localtemp!" echo=¤MODE !sys.modeW!,!sys.modeH!
	set sys.textMode=
)

set dwm.scene=%\e%[H%\e%[0m%\e%[48;5;0;38;5;231m%\e%[2JShivtanium OS !sys.tag! !sys.ver! !sys.subvinfo! ^| No theme loaded.
set dwm.sceneBGcolor=5;0
set dwm.BGcolor=5;231
set dwm.FGcolor=5;16
set dwm.TIcolor=5;12
set dwm.TTcolor=5;231
set dwm.NIcolor=5;4
set dwm.NTcolor=5;7
set dwm.CBUI=%\e%[38;5;231m%\e%[48;2;0;192;192m - %\e%[48;2;0;255;255m □ %\e%[48;2;255;0;0m × 

if not defined \a for /f "delims=" %%A in ('forfiles /p "%~dp0." /m "%~nx0" /c "cmd /c echo(0x07"') do set "\a=%%A"

set /a "sst.proccount=0", "sys.click=0"
