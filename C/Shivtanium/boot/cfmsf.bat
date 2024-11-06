@echo off & setlocal enabledelayedexpansion
if not exist "!sst.dir!\temp" (
	echo This program is a Shivtanium service and cannot be called outside of Shivtanium.
	exit /b 1
)
set msfl=
for %%F in (
	main.bat
	sstoskrnl.bat
	core\config.bat
	core\getinput64.dll
	core\soundEngine\1.1.vbs
	core\soundEngine\1.2.vbs
	core\bxf.bat
	core\sys.bxf
	core\dwm.bxf
	core\str.bxf
	resourcepacks\init\themes\aero
	resourcepacks\init\themes\classic
	resourcepacks\init\themes\lo-fi
) do if not exist "!sst.dir!\%%~F" set msfl=!msfl! "%%~F"
if defined msfl (
	>"!sst.dir!\temp\pf-%~n0" echo=Missing files:!msfl:\=/!
) else copy nul "!sst.dir!\temp\pf-%~n0" > nul
exit /b
