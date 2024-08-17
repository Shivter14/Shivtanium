@echo off & setlocal enableDelayedExpansion
if not defined PID (
	echo=This program is a Shivtanium startup service.
	<nul set /p "=Press any key to exit. . ."
	pause > nul
	exit /b 1
)
set /a PID=PID
