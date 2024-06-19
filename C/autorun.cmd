@echo off & setlocal enabledelayedexpansion
chcp 65001 > nul
for /f %%a in ('echo prompt $E^| cmd') do set "\e=%%a"
for /f "tokens=2 delims=:" %%a in ('mode con') do (
	set /a counter+=1
	set "token=%%~a"
	if "!counter!"=="1" set /a "modeH=!token: =!"
	if "!counter!"=="2" set /a "modeW=!token: =!"
)
set /a "x=(modeW-56)/2, y=(modeH-4)/2"
echo %\e%[!y!;!x!H█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█%\e%[!x!G%\e%[B█ This program requires to be run in SSVM 3 or later.  █%\e%[!x!G%\e%[B█ If you want to run it without SSVM, run autorun.bat. █%\e%[!x!G%\e%[B█▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█
pause < con > nul
exit /b 1
