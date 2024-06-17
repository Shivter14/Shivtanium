@echo off
setlocal enabledelayedexpansion
if not exist "!sst.dir!\temp" (
	echo This program is a Shivtanium service and cannot be called outside of Shivtanium.
	exit /b 1
)
set msfl=
for %%F in (

	befi.dat
	dwm.bat
	main.bat
	Shivtanium.bat
	SSTFS-read.bat
	core\getinput64.dll
	core\ic-shutdown.bat
	core\main.sstfs
	core\playsound.vbs
	resourcepacks\init\sounds\boot.mp3
	resourcepacks\init\sounds\shutdown.mp3
	resourcepacks\init\sprites\bootlogo.spr
	resourcepacks\init\themes\aero
	resourcepacks\init\themes\classic
	resourcepacks\init\themes\lo-fi

) do if not exist "!sst.dir!\%%~F" set msfl=!msfl! "%%~F"
copy nul "!sst.dir!\temp\pf-%~n0" > nul
if defined msfl (
	>"!sst.dir!\temp\pf-%~n0" echo=Missing files:!msfl!
)
exit
