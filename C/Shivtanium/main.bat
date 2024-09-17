@echo off
if not defined \e for /f %%a in ('echo prompt $E^| cmd') do set "\e=%%a"
set args=%*
setlocal enabledelayedexpansion
if "!args:~0,1!"==":" (
	call %*
	exit /b
)
set "args=!args:'="!"
for %%A in (
	!args!
) do set sst.%%~A >nul 2>&1
if not exist "%~dp0" exit /b 404

if "!ssvm.ver:~0,1!" neq "3" chcp.com 65001>nul

cd "%~dp0" || exit /b 404
set "sst.dir=!cd!"
pushd ..
set "sst.root=!cd!"
popd
if /I "!sst.noTempClear!" neq "True" (
	if not exist temp md temp
	rd /s /q temp > nul 2>&1
	if exist temp call :halt "{Temp directory deletion}" "There is another instance of Shivtanium currently running.\nThe system will not start to prevent glitches."
)
md temp >nul 2>&1
if not defined sst.localtemp set sst.localtemp=!random!

set counter=0
for /f "tokens=2 delims=:" %%a in ('mode con') do (
	set /a counter+=1
	set "token=%%~a"
	if "!counter!"=="1" set "sys.modeH=!token: =!"
	if "!counter!"=="2" set "sys.modeW=!token: =!"
)
set counter=
<nul set /p "=%\e%[H%\e%[48;2;0;0;0m%\e%[38;2;255;255;255m"
for %%a in (kernelPipe kernelOut kernelErr) do copy nul temp\%%a > nul 2>&1 || call :halt "preparePipe" "Failed to prepare pipe:\n'temp\%%a'"
if not exist "temp\bootStatus-!sst.localtemp!" copy nul "temp\bootStatus-!sst.localtemp!" > nul || call :halt "preparePipe" "Failed to prepare pipe:\n'temp\bootStatus-!sst.localtemp!'"
if /I "!sst.noguiboot!" neq "True" (
	start /b "" cmd /c boot\renderer.bat "temp\bootStatus-!sst.localtemp!" < "temp\bootStatus-!sst.localtemp!"
) else copy nul "!sst.dir!\temp\pf-bootanim" > nul

(for %%a in (
	":clearEnv|Clearing environment"
	":loadSettings|Loading settings"
	":loadresourcepack init|Loading resources"
	":checkCompat|Checking compatibility"
	":setFont|Applying font"
	":compileBXF|Compiling BXF applications"
	":startServices|Starting services"
	"boot\cfmsf.bat|Checking for missing files"
	"boot\updateCheckSvc.bat|Checking for updates"
	":injectDLLs|Injecting DLLs"
) do for /f "tokens=1-2* delims=|" %%b in (%%a) do (
	set "sst.boot.command=%%~b"
	set sst.boot.command=!sst.boot.command:'="!
	if "%%~c" neq "" (
		set "sst.boot.msg=%%~c"
		echo=!sst.boot.msg!>> "temp\bootStatus-!sst.localtemp!"
	)
	call !sst.boot.command! || call :halt "Boot" "Something went wrong.\nCommand: %%~b\nText: %%~c\nErrorlevel: !errorlevel!\nError logs are located in: ~\temp\kernelErr"
)
set "processes= "
for /f "tokens=1 delims==" %%a in ('set sst.boot') do if /I "%%~a" neq "sst.boot.logoX" if /I "%%~a" neq "sst.boot.logoY" set "%%a="
cd "%~dp0"
for %%a in (!sys.bootVars!) do set "sys.%%~a="
call sstoskrnl.bat %* < "temp\kernelPipe" > "temp\kernelOut" 3> "temp\DWM-!sst.localtemp!"
) 2>> "temp\kernelErr"
:startup.submsg
set "sst.boot.msg=%~1"
set "sst.boot.submsg=%~2"
set "sst.boot.barMax=%~3"
set "sst.boot.barVal=%~4"
>>"temp\bootStatus-!sst.localtemp!" echo(!sst.boot.msg!;!sst.boot.submsg!;!sst.boot.barMax!;!sst.boot.barVal!
exit /b

# This will never execute
# ) - The purpose of this is to make Notepad++ formatting prettier.

:memoryDump
pushd "!sst.dir!\temp" || exit /b !errorlevel!
set > memoryDump
for %%A in (memoryDump) do (
	popd
	exit /b %%~zA
)
exit /b %errorlevel%

REM == Modules ==
:loadresourcepack
if not exist "!sst.dir!\resourcepacks\%~1" exit /b 1
for /f "delims=" %%a in ('dir /b /a:-D "!sst.dir!\resourcepacks\%~1\sprites\*.spr" 2^>nul') do call :loadsprites "!sst.dir!\resourcepacks\%~1\sprites\%%~a" %%~a
for /f "delims=" %%a in ('dir /b /a:-D "!sst.dir!\resourcepacks\%~1\sounds\*.*" 2^>nul') do set "asset[\sounds\%%~a]=!sst.dir!\resourcepacks\%~1\sounds\%%~a"
if exist "!sst.dir!\resourcepacks\%~1\textmodes.dat" for /f "usebackq tokens=1* delims=:" %%a in ("!sst.dir!\resourcepacks\%~1\textmodes.dat") do set "sst.boot.textmode[%%~a]=%%~b"
set /a "sst.boot.logoX=(sys.modeW-spr.[bootlogo.spr].W)/2+1", "sst.boot.logoY=(sys.modeH-spr.[bootlogo.spr].H)/2+1"
for /f "delims=" %%A in ('dir /b /a:-D "!sys.dir!\resourcepacks\%~1\themes\*"') do (
	set "theme[%%~nA]= "
	for /f "usebackq tokens=1* delims==" %%x in ("!sys.dir!\resourcepacks\%~1\themes\%%~A") do (
		if /I "%%~x" neq "CBUIOffset" set theme[%%~nA]=!theme[%%~nA]! "%%~x=%%~y"
	)
	set "theme[%%~nA]=!theme[%%~nA]:~2!"
)
if exist "!sst.dir!\resourcepacks\%~1\keyboard_init.bat" call "!sst.dir!\resourcepacks\%~1\keyboard_init.bat"
exit /b 0
:loadSprites
if not exist "%~1" call :halt "%~nx0:loadSprites" "File not found: %~1"
if "%~2"=="" call :halt "%~nx0:loadSprites" "Memory location not specified"
set "spr.[%~2]=%\e%7"
set /a "spr.W=0", "spr.[%~2].H=0"
for /f "delims=" %%a in ('type "%~1"') do (
	set "spr.temp=x%%~a"
	set "spr.[%~2]=!spr.[%~2]!%%~a%\e%8%\e%[B%\e%7"
	set spr.tempW=0
	for /l %%b in (9,-1,0) do (
		set /a "spr.tempW|=1<<%%b"
		for %%c in (!spr.tempW!) do if "!spr.temp:~%%c,1!" equ "" set /a "spr.tempW&=~1<<%%b"
	)
	if !spr.tempW! gtr !spr.W! set spr.W=!spr.tempW!
	set /a "spr.[%~2].H+=1"
)
set "spr.[%~2].W=!spr.W!"
set spr.W=
set spr.temp=
set spr.tempW=
exit /b 0
:halt
if exist temp (
	>>"!sst.dir!\temp\bootStatus-!sst.localtemp!" echo=¤EXITANIM
	call :waitForAnimations
)
set "halt.text=%~2"
set halt.text=!halt.text:\n=","!
set "halt.pausemsg= Hold any key to exit. . . "
set "halt.tracemsg= At %~1: "
for /l %%a in (64 -1 0) do (
	<nul set /p "=%\e%[2;3H%\e%[48;2;255;0;0m%\e%[38;2;255;255;255m%\e%[?25l Execution halted %\e%[4;3H!halt.tracemsg:~%%a!"
	for /l %%. in (0 1 10000) do rem
	for %%b in ("!halt.text!") do (
		set "halt.line=%%~b "
		<nul set /p "=%\e%[E%\e%[3G     !halt.line:~%%a!%\e%7"
	)
	<nul set /p "=%\e%[999;3H%\e%[A!halt.pausemsg:~%%a!%\e%8"
)
call :memorydump
start /b cmd /c "pause < con" >nul 2>&1
pause>nul<con
exit 0
:clearEnv
set "sys.SESSIONNAME=!SESSIONNAME!"
for /f "tokens=1 delims==" %%a in ('set') do for /f "tokens=1 delims=._" %%c in ("%%~a") do (
	set "unload=True"
	for %%b in (
		ComSpec SystemRoot SystemDrive temp windir
		ssvm sst sys
		\n \e
		PROCESSOR
		NUMBER
		USERNAME
	) do if /i "%%~c"=="%%~b" set "unload=False"
	if "!unload!"=="True" set "%%a="
)
set PATHEXT=.COM;.EXE;.BAT
set "PATH=!sst.dir!\systemb;!sst.dir!\core;!windir!\System32;!windir!;!windir!\System32\WindowsPowerShell\v1.0\"
set unload=
exit /b 0
:loadSettings
if not exist "!sst.dir!\settings.dat" call :halt "%~nx0:loadSettings" "Failed to load 'settings.dat':\n  File not found."

set "sys.bootVars=bootVars noResize font textMode useAltWinCtrlChars"

set "sys.loginTheme=metroTyper"
set "sys.windowManager=dwm.bat"
set "sst.boot.fadeout=255"
set "sys.noResize=True"

set "sys.fontW=8"
set "sys.fontH=16"
set "sys.font=MxPlus IBM VGA 8x16"

for /f "usebackq tokens=1* delims==" %%a in ("!sst.dir!\settings.dat") do set "sys.%%~a=%%~b"
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
	>>"temp\bootStatus-!sst.localtemp!" echo=¤MODE !sys.modeW!,!sys.modeH!
	set sys.textMode=
)

set "sst.processes= "
set "sst.processes.paused= "

set dwm.scene=%\e%[H%\e%[0m%\e%[48;5;0;38;5;231m%\e%[2JShivtanium OS !sys.tag! !sys.ver! !sys.subvinfo! ^| No theme loaded.
set dwm.sceneBGcolor=5;0
set dwm.BGcolor=5;231
set dwm.FGcolor=5;16
set dwm.TIcolor=5;12
set dwm.TTcolor=5;231
set dwm.NIcolor=5;4
set dwm.NTcolor=5;7
set dwm.CBUI=%\e%[38;5;231m%\e%[48;2;0;192;192m - %\e%[48;2;0;255;255m □ %\e%[48;2;255;0;0m × 

cd "%~dp0" > nul 2>&1 || exit /b
set "sys.dir=!cd!"

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
	if "!%%~c!"=="" call :halt "%~nx0:loadSettings" "Failed to define variable translation:\n%%~c = %%~b"
)

if not defined \a for /f "delims=" %%A in ('forfiles /p "%~dp0." /m "%~nx0" /c "cmd /c echo(0x07"') do set "\a=%%A"

set /a "sst.proccount=0", "sys.click=0"
exit /b 0
:injectDLLs

>>"!sst.dir!\temp\bootStatus-!sst.localtemp!" (
	echo=Startup Finished
	echo=¤EXITANIM
)
call :waitForAnimations
if /I "!sys.noResize!"=="True" set sys.noResize=1
set noResize=!sys.noResize!
cd "!sst.dir!" || exit /b
if not exist core\getInput64.dll call :halt "%~nx0:injectDLLs" "Missing File: core\getInput64.dll"
rundll32.exe core\getInput64.dll,inject || call :halt "%~nx0:injectDLLs" "Failed to inject getInput64.dll\nErrorlevel: !errorlevel!"
if not defined getInputInitialized call :halt "%~nx0:injectDLLs" "Failed to inject getInput64.dll: Unknown error.\nErrorlevel: !errorlevel!"

set sys.noResize=
set noResize=
set getInputInitialized=
set getInput_builtOn=
set sys.SESSIONNAME=
exit /b
:startServices
setlocal enabledelayedexpansion

set "sys.logoX=!sst.boot.logoX!"
set "sys.logoY=!sst.boot.logoY!"
for %%a in (
	"ssvm"
	"temp"
	"pid"
	"asset"
	"charset"
	"sst.boot"
) do for /f "tokens=1 delims==" %%b in ('set %%a 2^>nul') do set "%%b="
if /I "!sys.useAltWinCtrlChars!"=="True" for /f "tokens=1* delims==" %%a in ('set theme[ 2^>nul') do (
	set "%%a=!%%a: - = ▿ !"
	set "%%a=!%%a: □ = o !"
	set "%%a=!%%a: × = x !"
)
for %%a in (!sys.bootVars!) do set "sys.%%~a="

set modeW=
set modeH=
set dwm.char.L=█
set dwm.char.B=▄
set dwm.char.R=█
set dwm.char.S=█

for /f "tokens=2 delims=:" %%a in ('mode con') do (
	set "token=%%~a"
	if not defined modeH (
		set "modeH=!token: =!"
	) else if not defined modeW set "modeW=!token: =!"
)

copy nul "temp\DWM-!sst.localtemp!" > nul
copy nul "temp\DWMResp-!sst.localtemp!" > nul
start /b cmd /c !sys.windowManager! < "temp\DWM-!sst.localtemp!" 3> "temp\DWMResp-!sst.localtemp!"
endlocal
set sys.windowManager=
exit /b 0
:waitForBootServices
cmd /c "%~f0" :waitForBootServices
exit /b
:waitForBootServices.service
set "services=cfmsf updateCheckSvc bootanim"
for /l %%. in () do (
	for %%F in (!services!) do if exist "!sst.dir!\temp\pf-%%~F" (
		set svcIn=
		set /p svcIn=<"!sst.dir!\temp\pf-%%~F"
		if defined svcIn (
			call :halt "service %%~F" "!svcIn!"
		)
		del "!sst.dir!\temp\pf-%%~F" > nul
		set new_services=
		for %%a in (!services!) do if "%%~a" neq "%%~F" set new_services=!new_services! %%a
		if not defined new_services exit 0
		set "services=!new_services!"
		set new_services=
		if "!services!"=="!services:bootanim=!" call :startup.submsg "Waiting for startup tasks:" "!services!" /nologo
	)
)
:checkCompat
if "!sys.CPU.architecture!" neq "AMD64" call :halt "%~nx0:checkCompat" "Incompatible processor architecture: !sys.CPU.architecture!\nShivtanium requires processor architecture AMD64/x86_64"
exit /b
:compileBXF
set bxf.failed=
> "!sst.dir!\temp\BXFstartup.log" echo=Something went wrong while compiling BXF applications. This log has been saved to "temp\BXFstartup.log"
cd "!sst.dir!" || exit /b

set BXF_toCompile=0
set BXF_compiled=0
for %%F in (dwm.bxf "systemb\*.bxf") do if not exist "%%~dpnF.bat" set /a BXF_toCompile+=1

(for %%F in (dwm.bxf "systemb\*.bxf") do if not exist "%%~dpnF.bat" (
	set /a BXF_compiled+=1
	call :startup.submsg "!sst.boot.msg!" "File: %%F" !BXF_toCompile! !BXF_compiled!
	<nul set /p "=%\e%[48;2;0;0;0;38;2;255;255;255m"
	if not exist "%%~dpn.bat" call bxf.bat "%%~fF" || set bxf.failed=True
)) >> "!sst.dir!\temp\BXFstartup.log" 2>&1
if not defined bxf.failed (
	del "!sst.dir!\temp\BXFstartup.log"
	exit /b 0
)
>>"!sst.dir!\temp\bootStatus-!sst.localtemp!" echo=¤EXITANIM
call :waitForAnimations
echo=%\e%[48;2;0;0;0;38;2;255;255;255m%\e%[H%\e%[2J
call :compileBXF.failed < "!sst.dir!\temp\BXFstartup.log"
set BXF_toCompile=
exit /b 0
:compileBXF.failed
set lineDef=
for /l %%# in (2 1 !sys.modeH!) do (
	set line=
	set /p "line="
	echo(!line!
)
if not defined line (
	pause<con>con
	exit /b
)
<nul set /p "=-- More --"
pause<con>nul
echo=%\e%[2K%\e%[F
goto compileBXF.failed
:waitForAnimations
if not exist "!sst.dir!\temp\pf-bootanim" goto waitForAnimations
exit /b
:setfont
if /I "!sys.SESSIONNAME!" == "CONSOLE" exit /b 0
setlocal DisableDelayedExpansion
set setfont=for %%# in (1 2) do if %%#==2 (^
%=% for /f "tokens=1-3*" %%- in ("? ^^!arg^^!") do endlocal^&powershell.exe -nop -ep Bypass -c ^"Add-Type '^
%===% using System;^
%===% using System.Runtime.InteropServices;^
%===% [StructLayout(LayoutKind.Sequential,CharSet=CharSet.Unicode)] public struct FontInfo{^
%=====% public int objSize;^
%=====% public int nFont;^
%=====% public short fontSizeX;^
%=====% public short fontSizeY;^
%=====% public int fontFamily;^
%=====% public int fontWeight;^
%=====% [MarshalAs(UnmanagedType.ByValTStr,SizeConst=32)] public string faceName;}^
%===% public class WApi{^
%=====% [DllImport(\"kernel32.dll\")] public static extern IntPtr CreateFile(string name,int acc,int share,IntPtr sec,int how,int flags,IntPtr tmplt);^
%=====% [DllImport(\"kernel32.dll\")] public static extern void GetCurrentConsoleFontEx(IntPtr hOut,int maxWnd,ref FontInfo info);^
%=====% [DllImport(\"kernel32.dll\")] public static extern void SetCurrentConsoleFontEx(IntPtr hOut,int maxWnd,ref FontInfo info);^
%=====% [DllImport(\"kernel32.dll\")] public static extern void CloseHandle(IntPtr handle);}';^
%=% $hOut=[WApi]::CreateFile('CONOUT$',-1073741824,2,[IntPtr]::Zero,3,0,[IntPtr]::Zero);^
%=% $fInf=New-Object FontInfo;^
%=% $fInf.objSize=84;^
%=% [WApi]::GetCurrentConsoleFontEx($hOut,0,[ref]$fInf);^
%=% If('%%~.'){^
%===% $fInf.nFont=0; $fInf.fontSizeX=0; $fInf.fontFamily=0; $fInf.fontWeight=0;^
%===% If([Int16]'%%~.' -gt 0){$fInf.fontSizeX=[Int16]'%%~.'}^
%===% If([Int16]'%%~/' -gt 0){$fInf.fontSizeY=[Int16]'%%~/'}^
%===% If('%%~0'){$fInf.faceName='%%~0'}^
%===% [WApi]::SetCurrentConsoleFontEx($hOut,0,[ref]$fInf);}^
%=% Else{(''+$fInf.fontSizeY+' '+$fInf.faceName)}^
%=% [WApi]::CloseHandle($hOut);^") else setlocal EnableDelayedExpansion^&set arg=
endlocal &set "setfont=%setfont%"
if !!# neq # set "setfont=%setfont:^^!=!%"
(
	set setFont=
	%setFont% !sys.fontW! !sys.fontH! "!sys.font!"
) >&2
exit /b 0
