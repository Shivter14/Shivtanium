@echo off & setlocal enableDelayedExpansion
:main
if "%~1"=="--get" (
	set mode=get
	set "variable=%~2"
	shift /1
) else if "%~1"=="--set" (
	set mode=set
	set "variable=%~2"
	set "value=%~3"
	shift /1
	shift /1
) else exit /b -1

if "!mode!"=="get" (
	for /f "usebackq tokens=1* delims==" %%a in ("!sst.dir!\settings.dat") do (
		if "%%a"=="!variable!" echo=%%a=%%b
	)
) else if "!mode!"=="set" (
	for /f %%a in ('set cfg 2^>nul') do set "%%a="
	for /f "usebackq skip=3 tokens=1* delims==" %%a in ("!sst.dir!\settings.dat") do (
		set "cfg.%%a=%%b" >nul 2>&1
	)
	set "cfg.!variable!=!value!"
	(
		echo=tag=!sys.tag!
		echo=ver=!sys.ver!
		echo=subvinfo=!sys.subvinfo!
		for /f "tokens=1* delims=." %%a in ('set cfg. 2^>nul') do echo=%%b
	) > "!sst.dir!\settings.dat"
	for /f %%a in ('set cfg 2^>nul') do set "%%a="
)


if "%~2" neq "" (
	shift /1
	goto main
)
