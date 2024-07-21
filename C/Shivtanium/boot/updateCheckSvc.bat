@echo off & setlocal enableDelayedExpansion
if not exist "!sst.dir!\temp" (
	echo This program is a Shivtanium service and cannot be called outside of Shivtanium.
	exit /b 1
)

if /I "!sys.boot.disableUpdateChecks!" neq "True" (
	set latest.tag=
	set latest.ver=
	set latest.subvinfo=
	for /f "delims=*^!" %%a in ('curl -sm 3 "https://github.com/Shivter14/Shivtanium/releases/download/latest/update.dat" 2^>^&1') do (
		set "str=%%a"
			if "!str:~0,4!"=="tag=" set "latest.tag=!str:~4!"
		if "!str:~0,4!"=="ver=" set "latest.ver=!str:~4!"
		if "!str:~0,9!"=="subvinfo=" set "latest.ver=!str:~9!"
	)
	if defined latest.tag if "!latest.tag!" neq "!sys.tag!" goto updateFound
	if defined latest.ver if "!latest.ver!" neq "!sys.ver!" goto updateFound
	if defined latest.subvinfo if "!latest.subvinfo!" neq "!sys.subvinfo!" goto updateFound
)

copy nul "!sst.dir!\temp\pf-%~n0" > nul
exit 0
:updateFound
(
	echo=!latest.tag!
	echo=!latest.ver!
	echo=!latest.subvinfo!
) > "!sst.dir!\temp\update.dat"
>>"!sst.dir!\temp\kernelPipe" echo=createProcess	0	boot\update.bat
copy nul "!sst.dir!\temp\pf-%~n0" > nul
exit 0
