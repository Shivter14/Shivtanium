@echo off & setlocal enabledelayedexpansion

	%= Standard BEFI boot menu rev1 =%
	     %= Created by Shivter =%

if not defined \e for /f %%a in ('echo prompt $E^| cmd') do set "\e=%%a"
<nul set /p "=%\e%[?25l"
:main
(
	cd "%~dp0"
	set sst.boot.entries=
	set sst.boot.entrycount=0
	for /f "delims=" %%a in ('dir /b /a:D') do if exist "%%~a\befi.dat" (
		for /f "tokens=1,2* delims=:" %%b in (%%a\befi.dat) do (
			set sst.boot.entries=!sst.boot.entries! "%%~a\%%~b:%%~c"
			set /a sst.boot.entrycount+=1
		)
	)
	if "!sst.boot.entrycount!"=="0" call :halt "%~nx0" "No boot entries were found.             \nYou might need to re-install Shivtanium."
	if "!sst.boot.entrycount!"=="1" for /f "tokens=1 delims=:" %%a in (!sst.boot.entries!) do (
		set sst.boot.errorlevel=
		set "sst.boot.path=%%~a"
		if not exist "%%~a" (
			call :halt "%~nx0" "Invalid boot entry: File not found."
		) else cmd /c %%a %* || set sst.boot.errorlevel=!errorlevel!
	) else goto bootmenu
	cd "%~dp0"
	if defined sst.boot.errorlevel (
		if "!sst.boot.errorlevel!"=="1" if not exist "!sst.boot.path!" call :halt "@CrashHandeler !sst.boot.path!" "The system files were lost.\nIf you're running this off a removable storage device,\nIt might have been disconnected causing this crash.\nIf this problem occurs after a reboot,\nYou should reinstall the system."
		if "!sst.boot.errorlevel!" neq "5783" if "!sst.boot.errorlevel!" neq "27" call :halt "@Errorlevel !sst.boot.path!" "System exited with code !sst.boot.errorlevel!"
	)
)
exit 0
:halt
set "halt.text=%~2"
<nul set /p "=%\e%[2;3H%\e%[48;2;255;0;0m%\e%[38;2;255;255;255m%\e%[?25l Execution halted %\e%[4;3H At %~1: %\e%[5;3H     !halt.text:\n= %\e%[E%\e%[3G     ! "
for /l %%a in (0 1 255) do (
	for /l %%. in (0 1 10000) do rem
	echo(%\e%[999;3H%\e%[A%\e%[38;2;255;%%a;%%am Press any key to exit. . . 
)
pause>nul
exit %~3 %~4
:bootmenu
for /f "tokens=2 delims=:" %%a in ('mode con') do (
	set /a counter+=1
	set "temp.token=%%~a"
	if "!counter!"=="1" set /a "modeH=!temp.token: =!"
	if "!counter!"=="2" set /a "modeW=!temp.token: =!", "textW=modeW - 4"
)
set selection=1
set parameters=
:bootmenu.main
set current=0
(
	set /p "=%\e%[?25l%\e%[0m%\e%[38;2;0;0;0;48;2;255;255;255m%\e%[H%\e%[2K BEFI Boot Menu%\e%[48;2;0;0;0;38;2;255;255;255m%\e%[E%\e%[0J%\e%[3;3HSelect an operating system.%\e%[4;3HControlls: W = up, S = down, X = select, E = quit, P = set parameters%\e%[999;3H%\e%[A!parameters_disp!%\e%[6;3H"
	for %%a in (!sst.boot.entries!) do for /f "tokens=1* delims=:" %%b in ("%%~a") do (
		set /a current+=1
		set "temp.bootentry[!current!]=%%~b"
		set "temp.text=%%~c"
		set "temp.prefix=%\e%[48;2;0;0;0m"
		if "!selection!"=="!current!" (
			set temp.prefix=%\e%[38;2;0;0;0;48;2;255;255;255m
		)
		set /p "=!temp.prefix! !temp.text:~0,%textW%! %\e%[E%\e%[48;2;0;0;0;38;2;255;255;255m  "
	)
) < nul
choice /c "swxep" /N > nul
set input=!errorlevel!
if "!input!"=="1" (
	set /a selection+=1
	if !selection! gtr !sst.boot.entrycount! set selection=!sst.boot.entrycount!
)
if "!input!"=="2" (
	set /a selection-=1
	if !selection! lss 1 set selection=1
)
if "!input!"=="4" exit /b 0
if "!input!"=="5" (
	set parameters=
	set /p "parameters=%\e%[?25h%\e%[0m%\e%[38;2;0;0;0;48;2;255;255;255m%\e%[H%\e%[2K BEFI Boot Menu%\e%[48;2;0;0;0;38;2;255;255;255m%\e%[E%\e%[0J%\e%[3;4HType your parameters:%\e%[5;4H%\e%[38;2;0;0;0;48;2;255;255;255m%\e%[2K"
	set "parameters_disp=!parameters:~0,%textW%!"
)
if "!input!" neq "3" goto bootmenu.main
set sst.boot.errorlevel=
set "sst.boot.path=!temp.bootentry[%selection%]!"
for %%a in (
	"input" "temp" "current" "parameters_disp" "selection" "sst.boot.entr"
) do for /f "tokens=1 delims==" %%b in ('set %%a 2^>nul') do set "%%~a="
cmd /c !sst.boot.path! !parameters! %* || set sst.boot.errorlevel=!errorlevel!
cd "%~dp0"
if defined sst.boot.errorlevel (
	if "!sst.boot.errorlevel!"=="1" if not exist "!sst.boot.path!" call :halt "@CrashHandeler !sst.boot.path!" "The system files were lost.\nIf you're running this off a removable storage device,\nIt might have been disconnected causing this crash.\nIf this problem occurs after a reboot,\nYou should reinstall the system."
	if "!sst.boot.errorlevel!" neq "5783" if "!sst.boot.errorlevel!" neq "27" call :halt "@Errorlevel !sst.boot.path!" "System exited with code !sst.boot.errorlevel!"
)

exit /b
