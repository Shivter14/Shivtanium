@echo off
setlocal enableDelayedExpansion
if not exist "!sst.dir!\temp" (
	echo This program is a Shivtanium service and cannot be called outside of Shivtanium.
	exit /b 1
)
REM Under construction
copy nul "!sst.dir!\temp\pf-%~n0" > nul
exit /b