@echo off
setlocal enabledelayedexpansion
for /f "tokens=2 delims=:" %%a in ('mode con') do (
	set /a counter+=1
	set "token=%%~a"
	if "!counter!"=="1" set /a "modeH=!token: =!"
	if "!counter!"=="2" set /a "modeW=!token: =!"
)
cmd /c timeout 1 /nobreak > nul
set /a "sstlogin.w=48", "sstlogin.h=5"
set /a "sstlogin.x=modeW-sstlogin.w-1", "sstlogin.y=modeH-sstlogin.h"
echo(¤CW	sstsvc	!sstlogin.x!	!sstlogin.y!	!sstlogin.w!	!sstlogin.H!	Shivtanium Service Manager	discord
cmd /c timeout 0 /nobreak > nul
echo(¤MW	sstsvc	l2=  Services have been started successfully.
cmd /c timeout 2 /nobreak > nul
for /l %%. in (1 1 10) do (
	for /l %%# in (1 1 1000) do rem
	echo(¤DW	sstsvc
)