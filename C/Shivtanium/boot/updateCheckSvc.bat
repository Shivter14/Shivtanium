@echo off & setlocal enableDelayedExpansion
if not exist "!sst.dir!\temp" (
	echo This program is a Shivtanium service and cannot be called outside of Shivtanium.
	exit /b 1
)

if /I "!sys.boot.disableUpdateChecks!" neq "True" (
	set latest.tag=
	set latest.ver=
	set latest.subvinfo=
	for /f "delims=*^!" %%a in ('curl -Lsm 3 "https://raw.githubusercontent.com/Shivter14/Shivtanium/main/update.dat"') do (
		set "latest.%%a"
	)
	if defined latest.tag if "!latest.tag!" neq "!sys.tag!" goto updateFound
	if defined latest.ver if "!latest.ver!" neq "!sys.ver!" goto updateFound
	if defined latest.subvinfo if "!latest.subvinfo!" neq "!sys.subvinfo!" goto updateFound
)

copy nul "!sst.dir!\temp\pf-%~n0" > nul
exit /b 0
:updateFound
(
	echo=!latest.tag!
	echo=!latest.ver!
	echo=!latest.subvinfo!
) > "!sst.dir!\temp\update.dat"
>>"!sst.dir!\temp\kernelPipe" echo=createProcess	0	boot\update.bat
copy nul "!sst.dir!\temp\pf-%~n0" > nul
exit /b 0
