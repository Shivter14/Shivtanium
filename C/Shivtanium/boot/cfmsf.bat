@echo off & setlocal enabledelayedexpansion
if not exist "!sst.dir!\temp" (
	echo This program is a Shivtanium service and cannot be called outside of Shivtanium.
	exit /b 1
)
set msfl=
for %%F in (
	befi.dat
	dwm.bat
	main.bat
	sstoskrnl.bat
	core\config.bat
	core\getinput64.dll
	core\playsound.vbs
	resourcepacks\init\sprites\bootlogo.spr
	resourcepacks\init\themes\aero
	resourcepacks\init\themes\classic
	resourcepacks\init\themes\lo-fi
	resourcepacks\init\themes\noCBUI.themeMod
	resourcepacks\init\themes\noUnfocusedColors.themeMod
) do if not exist "!sst.dir!\%%~F" set msfl=!msfl! "%%~F"
if defined msfl (
	>"!sst.dir!\temp\pf-%~n0" echo=Missing files:!msfl:\=/!
) else copy nul "!sst.dir!\temp\pf-%~n0" > nul
exit /b
