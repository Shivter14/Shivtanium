@echo off
setlocal enabledelayedexpansion
set "sstfs.temp=%~1"
if "!sstfs.[%sstfs.temp%]!"=="" exit /b 404
if not exist "!sstfs.mainfile!" goto initSSTFS
set /a "sstfs.loc=!sstfs.[%sstfs.temp%]!", "sstfs.eof=!sstfs.[%sstfs.temp%].end!" 2>nul || call :halt "%~nx0:SSTFS.read" "Fatal filesystem error while trying to read:\n'!sstfs.temp:\n=\N!'"
for /f "usebackq skip=%sstfs.loc% delims=" %%a in ("!sstfs.mainfile!") do (
    echo(%%a
    if !sstfs.loc! geq %sstfs.eof% exit /b 0
    set /a sstfs.loc+=1
)
exit /b 0
:halt
set "halt.text=%~2"
set halt.text=!halt.text:\n=","!
set "halt.tracemsg= At %~1: "
:halt.ready
set "halt.pausemsg= The system cannot exit automatically. "
for /f "tokens=2 delims=:" %%a in ('mode con') do (
	set /a counter+=1
	set "token=%%~a"
	if "!counter!"=="2" set /a "halt.modeW=!token: =!-7"
)
for /l %%a in (!halt.modeW! -1 0) do (
	<nul set /p "=%\e%[2;3H%\e%[48;2;255;0;0m%\e%[38;2;255;255;255m%\e%[?25l Execution halted %\e%[4;3H!halt.tracemsg:~%%a!"
	for /l %%. in (0 1 10000) do rem
	for %%b in ("!halt.text!") do (
		set "halt.line=%%~b "
		<nul set /p "=%\e%[E%\e%[3G     !halt.line:~%%a,%halt.modeW%!%\e%7"
	)
	<nul set /p "=%\e%[999;3H%\e%[A!halt.pausemsg:~%%a!%\e%[4;1H"
)>con
for /l %%. in () do (
	echo(%\e%[H>con
	pause>nul
)
exit