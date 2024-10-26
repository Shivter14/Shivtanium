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
if defined sys.autorun (
	set sst.autorun=!sst.autorun! !sys.autorun!
	set sys.autorun=
)
if defined sys.boot.fadeout (
	set sst.boot.fadeout=!sys.boot.fadeout!
	set sys.boot.fadeout=
)
if defined sys.textMode if /I "!sys.textMode!" neq "default" (
	for /f "delims=" %%a in ("!sys.textMode!") do set "sys.textMode=!sst.boot.textmode[%%~a]!"
) else set sys.textMode=
if defined sys.textMode (
	set /a "sys.modeW=!sys.textMode:,=,sys.modeH=!"
	if !sys.modeW! lss 64 set sys.modeW=64
	if !sys.modeH! lss 16 set sys.modeW=16
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

for %%a in (
	"PROCESSOR_ARCHITECTURE=sys.CPU.architecture"
	"PROCESSOR_IDENTIFIER=sys.CPU.identifier"
	"PROCESSOR_LEVEL=sys.CPU.level"
	"PROCESSOR_REVISION=sys.CPU.revision"
	"NUMBER_OF_PROCESSORS=sys.CPU.count"
	"FIRMWARE_TYPE=sys.FIRMWARE_TYPE"
	"USERNAME=sys.host.USERNAME"
) do for /f "tokens=1,2 delims==" %%b in ("%%~a") do (
	set "%%~c=!%%~b!"
	set "%%~b="
	if "!%%~c!"=="" call main.bat :halt "%~nx0:loadSettings" "Failed to define variable translation:\n%%~c = %%~b"
)

if not defined \a for /f "delims=" %%A in ('forfiles /p "%~dp0." /m "%~nx0" /c "cmd /c echo(0x07"') do set "\a=%%A"

set /a "sst.proccount=0", "sys.click=0"
