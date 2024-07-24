@echo off & setlocal enableDelayedExpansion
if not defined PID (
	echo=This program requires to be run in the Shivtanium Kernel.
	<nul set /p "=Press any key to exit. . ."
	pause>nul
	exit /b 1
)
set /a PID=PID
set /a "nextButtonBX=(nextButtonX=(win[!PID!.oobe]W=64)-8)+5, contentH=(win[!PID!.oobe]H=16)-2, originalX=win[!PID!.oobe]X=(sys.modeW - win[!PID!.oobe]W) / 2 + 1, win[!PID!.oobe]Y=(sys.modeH - win[!PID!.oobe]H) / 2, inputC=(inputW=win[!PID!.oobe]W-6)-1"
if exist "!asset[\sounds\windows-xp-welcome-music-remix.mp3]!" (	
	start /b "Shivtanium sound handeler (ignore this)" cscript.exe //b core\playsound.vbs "!asset[\sounds\windows-xp-welcome-music-remix.mp3]!"
	for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "musicStart=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100",^
	"win[!PID!.player]X=(sys.modeW - (win[!PID!.player]W=50)) / 2 + 1, win[!PID!.player]Y=sys.modeH - (win[!PID!.player]H=5) - 1, musicDurationX=(playBarW=(pauseButtonX=win[!PID!.player]W-3)-1)-4"
	For /F "tokens=1 delims=" %%a in (
		'mshta vbscript:Execute^("Dim audio_lenght:With CreateObject(""WMPlayer.OCX""):.settings.mute = True:.url= ""!asset[\sounds\windows-xp-welcome-music-remix.mp3]!"":Do While Not .playstate = 3:CreateObject(""WScript.Shell"").Run ""ping localhost -n 1"",0,true:Loop:audio_lenght = Round(.currentMedia.duration):.Close:End With:CreateObject(""Scripting.FileSystemObject"").GetStandardStream(1).WriteLine(audio_lenght):close"^)'
	) do (
		set /a "musicDuration=%%a, musicDurationPM=%%a / 60, musicDurationPS=%%a %% 60"
		set "musicDurationPS=0!musicDurationPS!"
		set "musicDurationPS=!musicDurationPS:~-2!"
		set "musicDurationPM=  !musicDurationPM!"
		set "musicDurationPM=!musicDurationPM:~-3!"
	)
	set soundChar=■
	echo=¤CW	!PID!.player	!win[%PID%.player]X!	!win[%PID%.player]Y!	!win[%PID%.player]W!	!win[%PID%.player]H!	Currently playing:	lo-fi noCBUI
	>>"!sst.dir!\temp\kernelPipe" echo=registerWindow	!PID!	!PID!.player	!win[%PID%.player]X!	!win[%PID%.player]Y!	!win[%PID%.player]W!	!win[%PID%.player]H!
	echo=¤MW	!PID!.player	o1=%\e%[!win[%PID%.player]W!X %\e%[7m Stray Objects %\e%[27m - Windows XP OOBE Music remix%\e%8%\e%[!pauseButtonX!C ■ 	l2= 0:00%\e%8%\e%[!musicDurationX!C!musicDurationPM!:!musicDurationPS!	l3= %\e%[7m%\e%[!playBarW!X%\e%[27m
) else set musicPaused=0
echo=¤CTRL	APPLYTHEME	lo-fi
echo=¤CW	!PID!.oobe	!win[%PID%.oobe]X!	!win[%PID%.oobe]Y!	!win[%PID%.oobe]W!	!win[%PID%.oobe]H!	 	lo-fi noCBUI

>>"!sst.dir!\temp\kernelPipe" echo=registerWindow	!PID!	!PID!.oobe	!win[%PID%.oobe]X!	!win[%PID%.oobe]Y!	!win[%PID%.oobe]W!	!win[%PID%.oobe]H!	1
set "focusedWindow=!PID!.oobe"
:start // Initial screen

set "s2=▓▓▓▒▒░░                                             ░░▒▒▓▓"
set "s3=▓▓▒▒░░   ▄▄▄ ▄    ▄      ▄            ▄            ░░▒▒▓▓▓"
set "s4=▓▓▓▒▒░░ █    █          ▄█▄                         ░░▒▒▓▓"
set "s5=▓▓▒▒░░   ▀▀▄ █▀▀▄ █ █ █  █  ▄▀▀▄ █▀▀▄ █ █  █ █▀▄▀▄ ░░▒▒▓▓▓"
set "s6=▓▓▓▒▒░░ ▄▄▄▀ █  █ █ ▀█▀  █  ▀▄▄█ █  █ █ ▀▄▄█ █ █ █  ░░▒▒▓▓"
set "s7=▓▓▒▒░░          ▀         ▀         ▀        ▀     ░░▒▒▓▓▓"
set "s8=▓▓▓▒▒░░                                             ░░▒▒▓▓"

for /l %%a in (3 4 51) do (
	set /a "off=27-%%a/2"
	echo=¤MW	!PID!.oobe^
	l2=%\e%[!off!C%\e%[7m!s2:~0,%%a!!s2:~-7!%\e%[27m^
	l3=%\e%[!off!C%\e%[7m!s3:~0,%%a!!s3:~-7!%\e%[27m^
	l4=%\e%[!off!C%\e%[7m!s4:~0,%%a!!s4:~-7!%\e%[27m^
	l5=%\e%[!off!C%\e%[7m!s5:~0,%%a!!s5:~-7!%\e%[27m^
	l6=%\e%[!off!C%\e%[7m!s6:~0,%%a!!s6:~-7!%\e%[27m^
	l7=%\e%[!off!C%\e%[7m!s7:~0,%%a!!s7:~-7!%\e%[27m^
	l8=%\e%[!off!C%\e%[7m!s8:~0,%%a!!s8:~-7!%\e%[27m
)
set last=!contentH!
for /l %%a in (!contentH! -1 10) do (
	echo=¤MW	!PID!.oobe	l!last!=	l%%a=%\e%[20CWelcome to Shivtanium‼
	set last=%%a
)
echo=¤MW	!PID!.oobe	l12=%\e%[8CBefore we put you on the desktop, we have some	l13=%\e%[17Ccustomization to go through.	o!contentH!=%\e%[!nextButtonX!C Next 

set last=
set off=
call :pagewait

REM  Transition
echo=¤MW	!PID!.oobe	l12=	l13=
set fall=10
for /l %%a in (51 -4 3) do (
	set /a "off=27-%%a/2", "last=fall, fall+=1"
	if !last! lss !contentH! (
		set add=
		echo=¤MW	!PID!.oobe	l!last!=	l!fall!=%\e%[20CWelcome to Shivtanium‼
	) else set add=	l!contentH!=
	
	echo=¤MW	!PID!.oobe^
	l2=%\e%[!off!C%\e%[7m!s2:~0,%%a!!s2:~-7!%\e%[27m^
	l3=%\e%[!off!C%\e%[7m!s3:~0,%%a!!s3:~-7!%\e%[27m^
	l4=%\e%[!off!C%\e%[7m!s4:~0,%%a!!s4:~-7!%\e%[27m^
	l5=%\e%[!off!C%\e%[7m!s5:~0,%%a!!s5:~-7!%\e%[27m^
	l6=%\e%[!off!C%\e%[7m!s6:~0,%%a!!s6:~-7!%\e%[27m^
	l7=%\e%[!off!C%\e%[7m!s7:~0,%%a!!s7:~-7!%\e%[27m^
	l8=%\e%[!off!C%\e%[7m!s8:~0,%%a!!s8:~-7!%\e%[27m!add!
)
set last=
set fall=
set add=

:accountsetup // User Profile Setup
echo=¤MW	!PID!.oobe	l2=	l3=	l4=	l5=	l6=	l7=	l8=	o!contentH!=%\e%[2C Back %\e%8%\e%[!nextButtonX!C Next 

set "l2= Create a user profile"
set "l4=  Username:           "
set "l7=  Password:           "
for /l %%a in (2 3 23) do echo=¤MW	!PID!.oobe^
	l2= !l2:~-%%a!	l4= !l4:~-%%a!	l7= !l7:~-%%a!^
	o5=%\e%[3C%\e%[7m%\e%[%%aX%\e%[27m	o8=%\e%[3C%\e%[%%aX

for /l %%a in (28 3 !inputW!) do echo=¤MW	!PID!.oobe	o5=%\e%[3C%\e%[7m%\e%[%%aX%\e%[27m	o8=%\e%[3C%\e%[%%aX
set "buttons=username password"
set btn[username]Y=5
set btn[password]Y=8
set /a "btn[username]X=btn[password]X=3, btn[username]BX=btn[password]BX=nextButtonX"
set btn[username]=:textinput username
set btn[password]=:textinput password
set btn[username]N=:textinput password

set "txt.username= "
set "txt.password= "
call :textinput username
call :pagewait

for /l %%a in (!inputW! -4 4) do (
	set /a "x=inputW-%%a+3"
	echo=¤MW	!PID!.oobe^
	l2=%\e%[!x!C!l2:~0,%%a!	l4=%\e%[!x!C!l4:~0,%%a!	l7=%\e%[!x!C!l7:~0,%%a!^
	o5=%\e%[!x!C%\e%[%%aX!txt.username:~0,%%a!	o8=%\e%[!x!C%\e%[%%aX!txt.password:~0,%%a!
)
set x=
echo=¤MW	!PID!.oobe	o5=	o8=	l2=	l4=	l7=
set buttons=
if errorlevel 1 goto start
:fontsetup
set "l2=Font installation                                        "
set "l4=The recommended font for Shivtanium is:                  "
set "l5= MxPlus IBM VGA 8x16                                     "
set "l6=This will download & extract a font pack from int10h.org."
set "l8=If you want to skip this font installation, click 'Next'."
set "o10= Download & Install                                     "
set buttons=install
set btn[install]X=3
set btn[install]BX=22
set btn[install]Y=10
set btn[install]=:getfonts
set "btn[install]title=!o10:~0,20!"
set continue=

for /l %%a in (2 4 56) do echo=¤MW	!PID!.oobe^
	l2=  !l2:~-%%a!	l4=  !l4:~-%%a!	l5=  %\e%[7m!l5:~-%%a,21!%\e%[27m	l6=  !l6:~-%%a!	l8=  !l8:~-%%a!	o10=%\e%[3C!o10:~-%%a,20!
echo=¤MW	!PID!.oobe	l2=  !l2:  =!	l4=  !l4:  =!	l5=  %\e%[7m!l5:~0,21!%\e%[27m	l6=  !l6:  =!	l8=  !l8:  =!	o10=%\e%[3C!o10:~0,20!

call :pagewait
set "o10=!o10:~0,20!"
set "l5=!l5:~0,21!"
for /l %%a in (!inputW! -4 4) do (
	set /a "y=(x=inputW-%%a+3)+1"
	echo=¤MW	!PID!.oobe	l2=%\e%[!x!C!l2:~0,%%a!	l4=%\e%[!x!C!l4:~0,%%a!	l5=%\e%[!x!C%\e%[7m!l5:~0,%%a!%\e%[27m	l6=%\e%[!x!C!l6:~0,%%a!	l8=%\e%[!x!C!l8:~0,%%a!	o10=%\e%[!y!C!o10:~0,%%a!
)
set x=
set y=
echo=¤MW	!PID!.oobe	l2=	l4=	l5=	l6=	l8=	o10=
if errorlevel 1 goto accountsetup
:loginTheme
set buttons=BGthemePrev BGthemeNext FGthemePrev FGthemeNext


set "l2=Customization  [ 1 / 2 ]      "
set "l5=Login Screen background theme:"
set "l8=Login Screen window theme:    "
set /a "olspX=lspX=originalX+win[!PID!.oobe]W-(lspW=32), lspY=win[!PID!.oobe]Y+(win[!PID!.oobe]H-(lspH=8))/2"
echo=¤CW	!PID!.lsp	!lspX!	!lspY!	!lspW!	!lspH!	Window Preview	!theme[%selectedFGtheme%]!
echo=¤FOCUS	!PID!.oobe
for /l %%a in (4 4 40) do (
	set /a "win[%PID%.oobe]X=originalX-%%a/2, lspX=olspX+%%a/2"
	echo=¤MW	!PID!.oobe^
	l2=  !l2:~-%%a,26!	l5=  !l5:~-%%a!	l6=%\e%[7m%\e%[%%aX%\e%[27m	l8=  !l8:~-%%a!	l9=%\e%[7m%\e%[%%aX%\e%[27m^
	x=!win[%PID%.oobe]X!
	echo=¤MW	!PID!.lsp	x=!lspX!
	echo=¤OV	%\e%[999;!win[%PID%.oobe]X!H%\e%[48;2;;;;38;5;231m%\e%[0K%\e%[1KShivtanium !sys.tag! !sys.ver! !sys.subvinfo! ^| !date! !time!%\e%[0K
)
(
	echo=unRegisterWindow	!PID!.oobe
	echo=registerWindow	!PID!	!PID!.oobe	!win[%PID%.oobe]X!	!win[%PID%.oobe]Y!	!win[%PID%.oobe]W!	!win[%PID%.oobe]H!	1
) >> "!sst.dir!\temp\kernelPipe"
echo=¤MW	!PID!.oobe	l2=  !l2:~0,24!	l5=  !l5!	l8=  !l8!
for /l %%a in (1 1 9) do echo=¤MW	!PID!.oobe^
	l6=%\e%[%%aC%\e%[7m%\e%[4%%aX%\e%[27m	l9=%\e%[%%aC%\e%[7m%\e%[4%%aX%\e%[27m

if not defined selectedBGTheme set "selectedBGTheme=1"
if not defined selectedFGTheme set "selectedFGTheme=1"

set /a "themeCount=1, themeSNW=win[!PID!.oobe]W-15, btn[FGthemeNext]Y=(btn[userthemeNext]Y=btn[BGthemeNext]Y=btn[themePrev]Y=6)+3"
for %%a in (FG BG user) do (
	set "btn[%%athemePrev]=:setTheme %%a -"
	set "btn[%%athemeNext]=:setTheme %%a +"
	set /a "btn[%%athemePrev]Y=btn[%%athemeNext]Y, btn[%%athemeNext]BX=(btn[%%athemeNext]X=(btn[%%athemePrev]BX=(btn[%%athemePrev]X=3)+2)+2)+2"
)
set theme[1]=lo-fi
for /f "delims=" %%R in ('dir /b /a:D "!sst.dir!\resourcepacks"') do for /f "delims=" %%T in ('dir /b /a:-D "!sst.dir!\resourcepacks\%%~nxR\themes" ^| find /v "CBUI"') do if "%%~nxT" neq "lo-fi" (
	set /a themeCount+=1
	set "theme[!themeCount!]=%%~nxT"
)
if defined theme[!selectedBGTheme!] echo=¤CTRL	APPLYTHEME	!theme[%selectedBGTheme%]!

echo=¤MW	!PID!.oobe	l2=  !l2:~0,26!	l5=  !l5!	l8=  !l8!^
	o6=%\e%[3C ◄ %\e%[C ► 	l6=%\e%[10C%\e%[7m %\e%[!themeSNW!X!theme[%selectedBGTheme%]!%\e%[27m^
	o9=%\e%[3C ◄ %\e%[C ► 	l9=%\e%[10C%\e%[7m %\e%[!themeSNW!X!theme[%selectedFGTheme%]!%\e%[27m

call :pagewait
for /l %%a in (!themeSNW! -4 4) do (
	set /a "y=(z=(x=themeSNW-%%a+3)+1)+7"
	echo=¤MW	!PID!.oobe	l2=%\e%[!x!C!l2:~0,%%a!!l2:~%%a,4!	l5=%\e%[!x!C!l5:~0,%%a!!l4:~%%a,4!	l8=%\e%[!x!C!l8:~0,%%a!!l4:~%%a,4!^
	o6=%\e%[!z!C ◄ %\e%[C ► 	l6=%\e%[!y!C%\e%[7m %\e%[%%aX!theme[%selectedBGTheme%]:~0,%%a!%\e%[27m^
	o9=%\e%[!z!C ◄ %\e%[C ► 	l9=%\e%[!y!C%\e%[7m %\e%[%%aX!theme[%selectedFGTheme%]:~0,%%a!%\e%[27m
)
echo=¤MW	!PID!.oobe	l2=	l5=	l6=	l8=	l9=	o6=	o9=
echo=¤FOCUS	!PID!.oobe
for /l %%a in (36 -4 0) do (
	set /a "win[%PID%.oobe]X=originalX-%%a/2, lspX=olspX+%%a/2"
	echo=¤MW	!PID!.oobe	x=!win[%PID%.oobe]X!
	echo=¤MW	!PID!.lsp	x=!lspX!
	echo=¤OV	%\e%[999;!win[%PID%.oobe]X!H%\e%[48;2;;;;38;5;231m%\e%[0K%\e%[1KShivtanium !sys.tag! !sys.ver! !sys.subvinfo! ^| !date! !time!%\e%[0K
)
echo=¤CTRL	APPLYTHEME	lo-fi
(
	echo=unRegisterWindow	!PID!.oobe
	echo=registerWindow	!PID!	!PID!.oobe	!win[%PID%.oobe]X!	!win[%PID%.oobe]Y!	!win[%PID%.oobe]W!	!win[%PID%.oobe]H!	1
) >> "!sst.dir!\temp\kernelPipe"
echo=¤DW	!PID!.lsp
if errorlevel 1 goto fontsetup
:userthemesetup
set buttons=userThemePrev	userThemeNext

set "l2=Customization  [ 2 / 2 ]      "
set "l4=Select a global theme for your"
set "l5=user profile:                 "
set /a "olspX=lspX=originalX, lspW=32, lspY=win[!PID!.oobe]Y+(win[!PID!.oobe]H-(lspH=8))/2"
echo=¤CW	!PID!.lsp	!lspX!	!lspY!	!lspW!	!lspH!	Window Preview	!theme[%selectedUserTheme%]!
echo=¤FOCUS	!PID!.oobe
for /l %%a in (4 4 40) do (
	set /a "win[%PID%.oobe]X=originalX+%%a/2, lspX=olspX-%%a/2"
	echo=¤MW	!PID!.oobe	l2=  !l2:~-%%a,26!	l4=  !l4:~-%%a!	l5=  !l5:~-%%a,13!	l6=%\e%[7m%\e%[%%aX%\e%[27m	x=!win[%PID%.oobe]X!
	echo=¤MW	!PID!.lsp	x=!lspX!
	echo=¤OV	%\e%[999;!win[%PID%.oobe]X!H%\e%[48;2;;;;38;5;231m%\e%[0K%\e%[1KShivtanium !sys.tag! !sys.ver! !sys.subvinfo! ^| !date! !time!%\e%[0K
)
(
	echo=unRegisterWindow	!PID!.oobe
	echo=registerWindow	!PID!	!PID!.oobe	!win[%PID%.oobe]X!	!win[%PID%.oobe]Y!	!win[%PID%.oobe]W!	!win[%PID%.oobe]H!	1
) >> "!sst.dir!\temp\kernelPipe"
echo=¤MW	!PID!.oobe	l2=  !l2:~0,26!	l4=  !l4!	l5=  !l5:~0,13!
for /l %%a in (1 1 9) do echo=¤MW	!PID!.oobe	l6=%\e%[%%aC%\e%[7m%\e%[4%%aX%\e%[27m

if not defined selectedUserTheme set selectedUserTheme=1
echo=¤MW	!PID!.oobe	l2=  !l2:~0,26!	l4=  !l4!	l5=  !l5:~0,13!^
	o6=%\e%[3C ◄ %\e%[C ► 	l6=%\e%[10C%\e%[7m %\e%[!themeSNW!X!theme[%selectedUserTheme%]!%\e%[27m

set theme[1]=lo-fi
for /f "delims=" %%R in ('dir /b /a:D "!sst.dir!\resourcepacks"') do for /f "delims=" %%T in ('dir /b /a:-D "!sst.dir!\resourcepacks\%%~nxR\themes" ^| find /v "CBUI"') do if "%%~nxT" neq "lo-fi" (
	set /a themeCount+=1
	set "theme[!themeCount!]=%%~nxT"
)
if defined theme[!selectedUserTheme!] echo=¤CTRL	APPLYTHEME	!theme[%selectedUserTheme%]!

call :pagewait
for /l %%a in (!themeSNW! -4 4) do (
	set /a "y=(z=(x=themeSNW-%%a+3)+1)+7"
	echo=¤MW	!PID!.oobe	l2=%\e%[!x!C!l2:~0,%%a!!l2:~%%a,4!	l4=%\e%[!x!C!l4:~0,%%a!!l4:~%%a,4!	l5=%\e%[!x!C!l5:~0,%%a!!l4:~%%a,4!^
	o6=%\e%[!z!C ◄ %\e%[C ► 	l6=%\e%[!y!C%\e%[7m %\e%[%%aX!theme[%selectedUserTheme%]:~0,%%a!%\e%[27m
)
echo=¤MW	!PID!.oobe	l2=	l4=	l5=	l6=	o6=
echo=¤FOCUS	!PID!.oobe
for /l %%a in (36 -4 0) do (
	set /a "win[%PID%.oobe]X=originalX+%%a/2, lspX=olspX-%%a/2"
	echo=¤MW	!PID!.oobe	x=!win[%PID%.oobe]X!
	echo=¤MW	!PID!.lsp	x=!lspX!
	echo=¤OV	%\e%[999;!win[%PID%.oobe]X!H%\e%[48;2;;;;38;5;231m%\e%[0K%\e%[1KShivtanium !sys.tag! !sys.ver! !sys.subvinfo! ^| !date! !time!%\e%[0K
)
(
	echo=unRegisterWindow	!PID!.oobe
	echo=registerWindow	!PID!	!PID!.oobe	!win[%PID%.oobe]X!	!win[%PID%.oobe]Y!	!win[%PID%.oobe]W!	!win[%PID%.oobe]H!	1
) >> "!sst.dir!\temp\kernelPipe"
echo=¤DW	!PID!.lsp
if errorlevel 1 goto loginTheme

:finish
set buttons=
set  "l4=Thank you for installing Shivtanium‼"
set  "l6=  == Credits =="
set  "l7=  Head Programmer          Shivter"
set  "l8=  DOS font        viler@int10h.org"
set  "l9=  getInput64.dll         MousieDev"
set "l10=  playSound.vbs           Sintrode"
set "l11=  Audio Duration Script   RazorArt"
set "l12=  Ideas      Icarus, Yeshi, Grub4K"
for /l %%a in (2 1 36) do (
	echo=¤MW	!PID!.oobe	l4=%\e%[13C!l4:~0,%%a!
)
for /l %%y in (6 1 12) do (
	for /l %%x in (4 4 34) do (
		set /a "x=%%x/2-1"
		echo=¤MW	!PID!.oobe	l%%y=%\e%[!x!C!l%%y:~2,%%x!
	)
)

call :pagewait
echo=¤MW	!PID!.oobe	l4=	l6=	l7=	l8=	l9=	l10=	l11=	l12=
if errorlevel 1 goto userthemesetup
for /l %%a in (3 4 51) do (
	set /a "off=27-%%a/2"
	echo=¤MW	!PID!.oobe^
	l2=%\e%[!off!C%\e%[7m!s2:~0,%%a!!s2:~-7!%\e%[27m^
	l3=%\e%[!off!C%\e%[7m!s3:~0,%%a!!s3:~-7!%\e%[27m^
	l4=%\e%[!off!C%\e%[7m!s4:~0,%%a!!s4:~-7!%\e%[27m^
	l5=%\e%[!off!C%\e%[7m!s5:~0,%%a!!s5:~-7!%\e%[27m^
	l6=%\e%[!off!C%\e%[7m!s6:~0,%%a!!s6:~-7!%\e%[27m^
	l7=%\e%[!off!C%\e%[7m!s7:~0,%%a!!s7:~-7!%\e%[27m^
	l8=%\e%[!off!C%\e%[7m!s8:~0,%%a!!s8:~-7!%\e%[27m
)
ping -n 2 127.0.0.1 > nul 2>&1
taskkill /f /im cscript.exe > nul 2>&1

set "usernameCheck=!txt.username!"
for %%a in (
	- _ a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9
) do set "usernameCheck=!usernameCheck:%%a=!"
if "!usernameCheck!" neq " " (
	call :getfonts.fail "Shivtanium Setup" "Invalid user name:" "  Invalid characters: %\e%[7m !usernameCheck:~1,32! %\e%[27m"
	echo=¤MW	!PID!.oobe	l2=	l3=	l4=	l5=	l6=	l7=	l8=
	goto accountsetup
)
cd "!sst.root!" || (
	call :getfonts.fail "Shivtanium Setup" "Something went wrong:" "  Failed to changedir into sst.root."
	echo=¤MW	!PID!.oobe	l2=	l3=	l4=	l5=	l6=	l7=	l8=
	goto finish
)
md "Users" || (
	call :getfonts.fail "Shivtanium Setup" "Something went wrong:" "  Failed to create '~:\Users': !errorlevel!" "  Non-fatal error. Continuing. . ."
)
md "Users\!txt.username:~1!" 2>"!sst.dir!\temp\proc\PID-!PID!-err" || (	
	set error=
	set /p "error=" < "!sst.dir!\temp\proc\PID-!PID!-err"
	call :getfonts.fail "Shivtanium Setup" "Something went wrong:" "  Failed to create the user profile: !errorlevel!" "%\e%[7m !error! %\e%[27m"
	set error=
	echo=¤MW	!PID!.oobe	l2=	l3=	l4=	l5=	l6=	l7=	l8=
	goto finish
)
(
	echo=globalTheme=!theme[%selectedUserTheme%]!
) > "!sst.root!\Users\!txt.username:~1!\userprofile.dat"
(
	echo=createProcess	0	systemb-userinit --username "!txt.username:~1!"
	echo=exitProcessTree	!PID!
) >> "!sst.dir!\temp\kernelPipe"
exit 0
:pagewait
for /l %%# in (1 1 1000) do if not defined continue (
	echo=¤OV	%\e%[999;!win[%PID%.oobe]X!H%\e%[48;2;;;;38;5;231m%\e%[0K%\e%[1KShivtanium !sys.tag! !sys.ver! !sys.subvinfo! ^| !date! !time!%\e%[0K
	for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "_ct=ct, ct=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100", "playBar=(playTime=(ct - musicStart) / 100) * playBarW / musicDuration, playTimePM=playTime / 60, playTimePS=playTime %% 60"
	if not defined musicPaused if "!_ct!" neq "!ct!" (
		set "playTimePS=0!playTimePS!"
		set "playTimePS=!playTimePS:~-2!"
		echo=¤MW	!PID!.player	l2= !playTimePM!:!playTimePS!%\e%8%\e%[!musicDurationX!C!musicDurationPM!:!musicDurationPS!	o3=%\e%[2C%\e%[!playBar!X
		if !playTime! geq !musicDuration! (
			start /b "Shivtanium sound handeler (ignore this)" cscript.exe //b core\playsound.vbs "!asset[\sounds\windows-xp-welcome-music-remix.mp3]!"
			for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "musicStart=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100"
		)
	)
	for /l %%# in (1 1 900) do if not defined continue (
		set kernelOut=
		set /p "kernelOut="
		if defined kernelOut if "!kernelOut!"=="click=1" (
			if "!focusedWindow!"=="!PID!.oobe" (
				set /a "relativeMouseX=mouseXpos - win[!PID!.oobe]X, relativeMouseY=mouseYpos - win[!PID!.oobe]Y"
				if "!relativeMouseY!"=="!contentH!" (
					if !relativeMouseX! geq !nextButtonX! if !relativeMouseX! leq !nextButtonBX! (
						echo=¤MW	!PID!.oobe	o!contentH!=%\e%[2C Back %\e%8%\e%[!nextButtonX!C%\e%[7m Next %\e%[27m
					)
					if !relativeMouseX! geq 2 if !relativeMouseX! leq 7 (
						echo=¤MW	!PID!.oobe	o!contentH!=%\e%[2C%\e%[7m Back %\e%[27m%\e%8%\e%[!nextButtonX!C Next 
					)
				)
				for %%a in (!buttons!) do if "!relativeMouseY!"=="!btn[%%~a]Y!" if !relativeMouseX! geq !btn[%%~a]X! if !relativeMouseX! leq !btn[%%~a]BX! (
					set continue=0
					call !btn[%%~a]!
				)
			) else if "!focusedWindow!"=="!PID!.player" (
				set /a "relativeMouseX=mouseXpos - win[!PID!.player]X, relativeMouseY=mouseYpos - win[!PID!.player]Y"
				if "!relativeMouseY!"=="1" if !relativeMouseX! geq !pauseButtonX! (
					echo=¤MW	!PID!.player	o1=%\e%[!win[%PID%.player]W!X %\e%[7m Stray Objects %\e%[27m - Windows XP OOBE Music remix%\e%8%\e%[!pauseButtonX!C%\e%[7m !soundChar! %\e%[27m
				)
			)
		) else if "!kernelOut!"=="click=0" (
			if "!focusedWindow!"=="!PID!.oobe" (
				echo=¤MW	!PID!.oobe	o!contentH!=%\e%[2C Back %\e%8%\e%[!nextButtonX!C Next 
				set /a "relativeMouseX=mouseXpos - win[!PID!.oobe]X, relativeMouseY=mouseYpos - win[!PID!.oobe]Y"
				if "!relativeMouseY!"=="!contentH!" (
					if !relativeMouseX! geq !nextButtonX! if !relativeMouseX! leq !nextButtonBX! (
						set continue=0
					)
					if !relativeMouseX! geq 2 if !relativeMouseX! leq 7 (
						set continue=1
					)
				)
			) else if "!focusedWindow!"=="!PID!.player" (
				set /a "relativeMouseX=mouseXpos - win[!PID!.player]X, relativeMouseY=mouseYpos - win[!PID!.player]Y"
				if "!relativeMouseY!"=="1" if !relativeMouseX! geq !pauseButtonX! (
					if defined musicPaused (
						if exist "!asset[\sounds\windows-xp-welcome-music-remix.mp3]!" (
							start /b "Shivtanium sound handeler (ignore this)" cscript.exe //b core\playsound.vbs "!asset[\sounds\windows-xp-welcome-music-remix.mp3]!" !musicPaused!0
							for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "musicStart=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100 - musicPaused"
							set musicPaused=
							set soundChar=■
						)
					) else (
						set soundChar=►
						set /a "musicPaused=ct - musicStart"
						taskkill /f /im cscript.exe > nul 2>&1
					)
				)
				echo=¤MW	!PID!.player	o1=%\e%[!win[%PID%.player]W!X %\e%[7m Stray Objects %\e%[27m - Windows XP OOBE Music remix%\e%8%\e%[!pauseButtonX!C !soundChar! 
			)
		) else if "!kernelOut!"=="exitProcess=!PID!" (
			exit 0
		) else if "!kernelOut!"=="exit" (
			exit 0
		) else set "!kernelOut!">nul 2>&1
	)
)
if not defined continue goto pagewait
for /f "delims=" %%a in ("!continue!") do (
	set continue=
	exit /b %%a
)
:textinput
echo=¤MW	!PID!.oobe	o!btn[%1]Y!=%\e%[3C%\e%[7m%\e%[!inputW!X!txt.%1:~-%inputC%!_%\e%[27m
set continue=
set continue.exit=
:textinput.loop
for /l %%# in (1 1 1000) do if not defined continue (
	echo=¤OV	%\e%[999;!win[%PID%.oobe]X!H%\e%[48;2;;;;38;5;231m%\e%[0K%\e%[1KShivtanium !sys.tag! !sys.ver! !sys.subvinfo! ^| !date! !time!%\e%[0K
	for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "_ct=ct, ct=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100", "playBar=(playTime=(ct - musicStart) / 100) * playBarW / musicDuration, playTimePM=playTime / 60, playTimePS=playTime %% 60"
	if not defined musicPaused if "!_ct!" neq "!ct!" (
		set "playTimePS=0!playTimePS!"
		set "playTimePS=!playTimePS:~-2!"
		echo=¤MW	!PID!.player	l2= !playTimePM!:!playTimePS!%\e%8%\e%[!musicDurationX!C!musicDurationPM!:!musicDurationPS!	o3=%\e%[2C%\e%[!playBar!X
		if !playTime! geq !musicDuration! (
			start /b "Shivtanium sound handeler (ignore this)" cscript.exe //b core\playsound.vbs "!asset[\sounds\windows-xp-welcome-music-remix.mp3]!"
			for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "musicStart=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100"
		)
	)
	for /l %%# in (1 1 1000) do if not defined continue (
		set kernelOut=
		set /p "kernelOut="
		if defined kernelOut if "!kernelOut:~0,12!"=="keysPressed=" (
			set "sys.keys=!kernelOut:~12!"
		) else if "!kernelOut:~0,14!"=="keysPressedRN=" (
			if "!focusedWindow!"=="!PID!.oobe" (
				set "!kernelOut!">nul 2>&1
				for %%k in (!keysPressedRN!) do (
					set "char=!charset_L:~%%k,1!"
					if "!sys.keys!" neq "!sys.keys:-16-=!" set "char=!charset_U:~%%k,1!"
					if "!sys.keys!" neq "!sys.keys:-17-=!" set "char=!charset_A:~%%k,1!"
					if "!char!"==" " (
						if "%%~k" neq "32" set char=
						if "%%~k"=="8" (
							if "!txt.%1!" neq " " set "txt.%~1=!txt.%~1:~0,-1!"
							echo=¤MW	!PID!.oobe	o!btn[%1]Y!=%\e%[3C%\e%[7m%\e%[!inputW!X!txt.%1:~-%inputC%!_%\e%[27m
						)
					)
					if defined char (
						set "txt.%~1=!txt.%~1!!char!"
						echo=¤MW	!PID!.oobe	o!btn[%1]Y!=%\e%[3C%\e%[7m%\e%[!inputW!X!txt.%1:~-%inputC%!_%\e%[27m
					) else if "%%~k"=="13" (
						set continue.exit=0
						set continue=13
						echo=¤MW	!PID!.oobe	o!btn[%1]Y!=%\e%[3C%\e%[!inputW!X!txt.%1:~-%inputC%!
					)
				)
			)
		) else if "!kernelOut!"=="click=1" (
			if "!focusedWindow!"=="!PID!.oobe" (
				set /a "relativeMouseX=mouseXpos - win[!PID!.oobe]X, relativeMouseY=mouseYpos - win[!PID!.oobe]Y"
				if "!relativeMouseY!"=="!contentH!" (
					if !relativeMouseX! geq !nextButtonX! if !relativeMouseX! leq !nextButtonBX! (
						echo=¤MW	!PID!.oobe	o!contentH!=%\e%[2C Back %\e%8%\e%[!nextButtonX!C%\e%[7m Next %\e%[27m
					)
					if !relativeMouseX! geq 2 if !relativeMouseX! leq 7 (
						echo=¤MW	!PID!.oobe	o!contentH!=%\e%[2C%\e%[7m Back %\e%[27m%\e%8%\e%[!nextButtonX!C Next 
					)
				)
			)
		) else if "!kernelOut!"=="click=0" (
			if "!focusedWindow!"=="!PID!.oobe" (
				echo=¤MW	!PID!.oobe	o!contentH!=%\e%[2C Back %\e%8%\e%[!nextButtonX!C Next 
				set /a "relativeMouseX=mouseXpos - win[!PID!.oobe]X, relativeMouseY=mouseYpos - win[!PID!.oobe]Y"
				if "!relativeMouseY!" neq "!btn[%~1]Y!" (
					set continue=True
					echo=¤MW	!PID!.oobe	o!btn[%1]Y!=%\e%[3C%\e%[!inputW!X!txt.%1:~-%inputC%!
					if "!relativeMouseY!"=="!contentH!" (
						if !relativeMouseX! geq !nextButtonX! if !relativeMouseX! leq !nextButtonBX! set continue.exit=True
						if !relativeMouseX! geq 2 if !relativeMouseX! leq 7 set continue.exit=1
					)
				)
			)
		) else if "!kernelOut!"=="exitProcess=!PID!" (
			exit 0
		) else if "!kernelOut!"=="exit" (
			exit 0
		) else set "!kernelOut!">nul 2>&1
	)
)
if not defined continue goto textinput.loop
if "!continue!"=="13" (
	if defined btn[%1]N (
		call !btn[%1]N!
		set continue=0
	)
) else set continue=!continue.exit!
exit /b 0
:getfonts
echo=¤MW	!PID!.oobe	o10=%\e%[3C%\e%[7m!btn[install]title!%\e%[27m
set continue=
for /l %%# in (1 1 1000) do if not defined continue for /l %%# in (1 1 1000) do if not defined continue (
	set kernelOut=
	set /p "kernelOut="
	if defined kernelOut (
		if "!kernelOut!"=="click=0" (
			set continue=True
			if "!focusedWindow!"=="!PID!.oobe" set /a "relativeMouseX=mouseXpos - win[!PID!.oobe]X, relativeMouseY=mouseYpos - win[!PID!.oobe]Y, click=0"
		) else if "!kernelOut!"=="exitProcess=!PID!" (
			exit 0
		) else if "!kernelOut!"=="exit" (
			exit 0
		) else set "!kernelOut!">nul 2>&1
	)
)
if not defined continue goto getfonts
set continue=
echo=¤MW	!PID!.oobe	o10=%\e%[3C!btn[install]title!
if "!click!" neq "0" exit /b 0
if "!relativeMouseY!" neq "!btn[install]Y!" exit /b 0
if !relativeMouseX! lss !btn[install]X! exit /b 0
if !relativeMouseX! gtr !btn[Install]BX! exit /b 0

md "!sst.dir!\temp\proc\PID-!PID!-dir" >nul 2>&1
pushd "!sst.dir!\temp\proc\PID-!PID!-dir" || exit /b 1
if exist "oldschool_pc_font_pack_v2.2_win.zip" goto getfonts.skipdownload

echo=¤CW	!PID!.getfonts	5	3	84	8	Downloading assets	classic noCBUI
>>"!sst.dir!\temp\kernelPipe" echo=registerWindow	!PID!	!PID!.getfonts	5	3	84	8
set contentW=80
echo=¤MW	!PID!.getfonts	l2=  Downloading %\e%[7m oldschool_pc_font_pack_v2.2_win.zip %\e%[27m . . .	l4=  %% Total    %% Received %% Xferd  Average Speed   Time    Time     Time  Current	l5=                                 Dload  Upload   Total   Spent    Left  Speed

curl -fkLO https://int10h.org/oldschool-pc-fonts/download/oldschool_pc_font_pack_v2.2_win.zip 2>&1 | call "!sst.dir!\core\streamIntoWindow" !PID!.getfonts	l6=  
if errorlevel 1 (
	call :getfonts.fail "Failed to download assets" "The following file failed to download:" "%\e%[7m oldschool_pc_font_pack_v2.2_win.zip %\e%[27m" "Reason: %\e%[7m curl error !errorlevel! %\e%[27m"
	goto getfonts.exit
) else if not exist "oldschool_pc_font_pack_v2.2_win.zip" (
	call :getfonts.fail "Failed to download assets" "The following file failed to download:" "%\e%[7m oldschool_pc_font_pack_v2.2_win.zip %\e%[27m" "Reason: Generic error !errorlevel!"
	goto getfonts.exit
)
echo=¤MW	!PID!.getfonts	l2=  Extracting %\e%[7m oldschool_pc_font_pack_v2.2_win.zip %\e%[27m . . .	l4=	l5=	l6=
:getfonts.skipdownload
if exist "ttf - Mx (mixed outline+bitmap)\MxPlus_IBM_VGA_8x16.ttf" goto getfonts.skipextraction
tar -xf "oldschool_pc_font_pack_v2.2_win.zip" || (
	call :getfonts.fail "Failed to extract assets" "The following archive failed to extract:" "%\e%[7m oldschool_pc_font_pack_v2.2_win.zip %\e%[27m" "Reason: %\e%[7m tar error !errorlevel! %\e%[27m"
	goto getfonts.exit
)
echo=¤MW	!PID!.getfonts	l2=  Waiting for license agreement . . . (Close the notepad window to continue)
start /wait notepad.exe README.txt
start /wait notepad.exe LICENSE.txt
:getfonts.skipextraction
start /wait "" "ttf - Mx (mixed outline+bitmap)\MxPlus_IBM_VGA_8x16.ttf"
>>"!sst.dir!\temp\kernelPipe" echo=createProcess	!PID!	systemb-dialog 5 3 58 13 "Finish font installation	classic noCBUI" "l2=  To finish installing this font;	l3=  - Restart your host system	l4=  - Start Shivtanium	l5=  - Right-click on the console's title bar	l6=  - Go to properties	l7=  - Click on the %\e%[7m Fonts %\e%[27m tab	l8=  - Find the new font & set the font size to %\e%[7m 16 %\e%[27m	l9=  - Finally, click on %\e%[7m Done %\e%[27m and the font should apply." w-buttonW-2 h-2 7 " Close "
popd
:getfonts.exit
echo=¤DW	!PID!.getfonts
>>"!sst.dir!\temp\kernelPipe" echo=unRegisterWindow	!PID!.getfonts
exit /b 0
:getfonts.fail
set halt.title=
set halt.winparams=
set halt.winW=16
set lines=1
for %%a in (%*) do (
	set "msg=#%%~a"
	set "msglen=0"
	for /l %%b in (9,-1,0) do (
		set /a "msglen|=1<<%%b"
		for %%c in (!msglen!) do if "!msg:~%%c,1!" equ "" set /a "msglen&=~1<<%%b"
	)
	
	if not defined halt.title (
		set /a msglen+=13
		set "halt.title=%%~a"
	) else (
		set /a "msglen+=6, lines+=1"
		set "halt.winparams=!halt.winparams!	l!lines!=  %%~a"
	)
	if !msglen! gtr !halt.winW! set "halt.winW=!msglen!"
)
set /a "halt.winH=lines + 4"

>>"!sst.dir!\temp\kernelPipe" echo=createProcess	!PID!	systemb-dialog 5 3 !halt.winW! !halt.winH! "!halt.title!	classic noCBUI" "!halt.winparams!" w-buttonW-2 h-2 7 " Close "
exit /b 0
:setTheme
set /a "selected%~1Theme%~2=1"
if !selected%1Theme! gtr !themeCount! set "selected%~1Theme=1"
if !selected%1Theme! lss 1 set "selected%~1Theme=!themeCount!"
if "%~1"=="BG" (
	echo=¤CTRL	APPLYTHEME	!theme[%selectedBGTheme%]!
	echo=¤MW	!PID!.oobe	o6=%\e%[3C ◄ %\e%[C ► 	l6=%\e%[10C%\e%[7m %\e%[!themeSNW!X!theme[%selectedBGTheme%]!%\e%[27m
) else (
	if "%~1"=="user" (
		echo=¤CTRL	APPLYTHEME	!theme[%selectedUserTheme%]!
		echo=¤MW	!PID!.oobe	o6=%\e%[3C ◄ %\e%[C ► 	l6=%\e%[10C%\e%[7m %\e%[!themeSNW!X!theme[%selectedUserTheme%]!%\e%[27m
		echo=¤DW	!PID!.lsp
		echo=¤CW	!PID!.lsp	!lspX!	!lspY!	!lspW!	!lspH!	Window Preview	!theme[%selectedUserTheme%]!
	) else (
		echo=¤MW	!PID!.oobe	o9=%\e%[3C ◄ %\e%[C ► 	l9=%\e%[10C%\e%[7m %\e%[!themeSNW!X!theme[%selectedFGTheme%]!%\e%[27m
		echo=¤DW	!PID!.lsp
		echo=¤CW	!PID!.lsp	!lspX!	!lspY!	!lspW!	!lspH!	Window Preview	!theme[%selectedFGtheme%]!
	)
)
set continue=
exit /b 0
