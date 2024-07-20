@echo off
setlocal enabledelayedexpansion
set "sstfs.path=%~1"
set "sstfs.path=!sstfs.path:/=\!"

if "!sstfs.path:~0,5!"=="\mnt\" (
	for /f "tokens=1* delims=\" %%a in ("!sstfs.path:~5!") do (
		set "sstfs.source=!sstfs.mnt[\mnt\%%~a]!"
		if "!sstfs.source!"=="" exit /b 2
		if "!sstfs.[\mnt\%%~a\%%~b]!"=="" exit /b 1
		if not exist "!sstfs.source!" exit /b 2
	)
) else if "!sstfs.path:~0,6!"=="\temp\" (
	if not exist "!sst.dir!!sstfs.path!" exit /b 1
	for /f "delims=<>|:?~" %%0 in ("!sst.dir!!sstfs.path:..=!") do (
		if "%%~0" neq "!sst.dir!!sstfs.path!" exit /b 1
		set "temp=%%~f0"
		if "!temp:%sst.dir%\temp\=!" neq "!temp!" exit /b 1
	)
	type "!sst.dir!!sstfs.path!" 2>nul || exit /b 2
	exit /b 0
) else exit /b 3

set /a "sstfs.loc=!sstfs.[%sstfs.path%]!", "sstfs.eof=!sstfs.[%sstfs.path%].end!"
for /f "usebackq skip=%sstfs.loc% delims=" %%a in ("!sstfs.source!") do (
    echo(%%a
    if !sstfs.loc! geq !sstfs.eof! exit /b 0
    set /a sstfs.loc+=1
)
