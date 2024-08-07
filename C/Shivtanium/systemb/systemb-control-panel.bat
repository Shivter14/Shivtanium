@echo off & setlocal enableDelayedExpansion
if not defined PID (
	echo=This program requires to be run in the Shivtanium Kernel with DWM enabled.
	<nul set /p "=Press any key to exit. . ."
	pause>nul
)
cd "!sst.dir!" || exit /b
for %%a in (%*) do (
	if defined next (
		set "!next!=%%~a"
		set next=
	) else (
		set next=
		if "%%a"=="--username" (
			set next=sys.username
		) else if "%%a"=="--UPID" (
			set next=sys.UPID
		)
	)
)
if not defined sys.username call systemb-dialog.bat (sys.modeW-w)/2 (sys.modeH-h)/2 48 6 "Control Panel" "l2=  Something went wrong:	l3=    Missing parameter: --username" w-buttonW-2 h-2 7 " Close "
if not defined sys.UPID     call systemb-dialog.bat (sys.modeW-w)/2 (sys.modeH-h)/2 48 6 "Control Panel" "l2=  Something went wrong:	l3=    Missing parameter: --UPID"     w-buttonW-2 h-2 7 " Close "
set /a PID=PID
set /a "pagesBY=5, currentPage=2, contentW=(win[!PID!.control]W=60)-(sidebarW=16)-4, contentH=(inbH=(win[!PID!.control]H=16)-1)-1, win[!PID!.control]X=(sys.modeW-win[!PID!.control]W)/2, win[!PID!.control]Y=(sys.modeH-win[!PID!.control]H)/2, closeButtonX=win[!PID!.control]W-4"
echo=¤CW	!PID!.control	!win[%PID%.control]X!	!win[%PID%.control]Y!	!win[%PID%.control]W!	!win[%PID%.control]H!	Control Panel
>>"!sst.dir!\temp\kernelPipe" echo=registerWindow	!PID!	!PID!.control	!win[%PID%.control]X!	!win[%PID%.control]Y!	!win[%PID%.control]W!	!win[%PID%.control]H!
set "page[2]= Performance    "
set "page[3]= Appearance     "
set "page[4]= System         "
set "page[5]= Updates        "
if /I "!sys.lowPerformanceMode!"=="True" set "sys.reduceMotion=True"

set tempstr=
if "!sys.reduceMotion!"=="True" (
	set "pipe=¤MW	!PID!.control"
	for /l %%y in (1 1 !inbH!) do (
		set "pipe=!pipe!	o%%y=!o%%y!"
	)
	echo=!pipe!
) else for /l %%w in (2 2 !sidebarW!) do (
	set "sidebarW=%%w"
	set "pipe=¤MW	!PID!.control"
	for /l %%y in (1 1 !inbH!) do (
		if defined page[%%y] set "tempstr=!page[%%y]:~-%%w!"
		set "pipe=!pipe!	o%%y=%\e%[%%wX!tempstr!"
		set tempstr=
	)
	echo=!pipe!
)
call :loadPage

for /l %%# in () do (
	set kernelOut=
	set /p "kernelOut="
	if defined kernelOut if "!kernelOut!"=="click=1" (
		if "!focusedWindow!"=="!PID!.control" (
			set /a "relativeMouseX=mouseXpos-win[!PID!.control]X, relativeMouseY=mouseYpos-win[!PID!.control]Y, closeButtonX=win[!PID!.control]W-4"
			if "!relativeMouseY!"=="0" (
				if !relativeMouseX! geq !closeButtonX! (
					>>"!sst.dir!\temp\kernelPipe" echo=exitProcessTree	!PID!
					exit 0
				)
			) else if !relativeMouseX! lss !sidebarW! (
				if defined page[!relativeMouseY!] (
					set currentPage=!relativeMouseY!
					call :loadPage
				)
			) else for %%b in (!buttons!) do if "!relativeMouseY!"=="!btn[%%~b]Y!" if !relativeMouseX! geq !btn[%%~b]X! if !relativeMouseX! leq !btn[%%~b]BX! for %%y in (!btn[%%~b]Y!) do echo=¤MW	!PID!.control	o%%y=!o%%y!%\e%8%\e%[!btn[%%~b]X!C%\e%[7m!btn[%%~b]title!%\e%[27m
		)
	) else if "!kernelOut!"=="click=0" (
		if "!focusedWindow!"=="!PID!.control" (
			set /a "relativeMouseX=mouseXpos-win[!PID!.control]X, relativeMouseY=mouseYpos-win[!PID!.control]Y"
			for %%b in (!buttons!) do if "!relativeMouseY!"=="!btn[%%~b]Y!" if !relativeMouseX! geq !btn[%%~b]X! if !relativeMouseX! leq !btn[%%~b]BX! call !btn[%%~b]!
		)
	) else if "!kernelOut!"=="exitProcess=!PID!" (
		exit 0
	) else if "!kernelOut!"=="exit" (
		exit 0
	) else set "!kernelOut!">nul 2>&1
)
:loadPage
for /l %%y in (1 1 !inbH!) do (
	set "o%%y=%\e%[!sidebarW!X"
	set "l%%y="
)
for /l %%y in (2 1 !pagesBY!) do set "o%%y=!o%%y!!page[%%y]!"
set "pipe=¤MW	!PID!.control"
for /l %%y in (1 1 !inbH!) do set "pipe=!pipe!	o%%y=!o%%y!	l%%y="
echo=!pipe!
set pipe=
if /I "!sys.reduceMotion!" neq "True" for /l %%w in (1 2 !sidebarW!) do echo=¤MW	!PID!.control	o!currentPage!=!o%currentPage%!%\e%8%\e%[7m!page[%currentPage%]:~0,%%w!%\e%[27m
set "o!currentPage!=%\e%[!sidebarW!X%\e%[7m!page[%currentPage%]!%\e%[27m"
echo=¤MW	!PID!.control	o!currentPage!=!o%currentPage%!
call :page[!currentPage!]
exit /b 0
:spg

set "buttons=Cancel Apply !buttons:Cancel Apply=!"
set "btn[Cancel]title= Cancel "
set "btn[Cancel]=:page[!currentPage!].cancel"
set "btn[Apply]title= Apply "
set "btn[Apply]=:page[!currentPage!].apply"
set /a "btn[Apply]X=win[!PID!.control]W-9, btn[Apply]Y=contentH, btn[Apply]BX=btn[Apply]X+7, btn[Cancel]X=btn[Apply]X-10, btn[Cancel]Y=contentH, btn[Cancel]BX=btn[Cancel]X+8"
set "o!contentH!=!o%contentH%!%\e%8%\e%[!btn[Cancel]X!C!btn[Cancel]title!%\e%[2C!btn[Apply]title!"

if /I "!%~2!"=="True" (
	set "%~2=False"
	set "btn[%~1]title= × "
) else (
	set "%~2=True"
	set "btn[%~1]title= ✓ "
)
for %%y in (!btn[%~1]Y!) do (
	set "o%%y=%\e%[!sidebarW!X!page[%%y]!"
	if "!currentPage!"=="%%y" set "o%%y=%\e%[!sidebarW!X%\e%[7m!page[%%y]!%\e%[27m"
	set "o%%y=!o%%y!%\e%8%\e%[!btn[%~1]X!C!btn[%~1]title!"
)
set "pipe=¤MW	!PID!.control"
for /l %%y in (1 1 !inbH!) do set "pipe=!pipe!	o%%y=!o%%y!"
echo=!pipe!
set pipe=
exit /b 0
:page[3].prev
set /a selectedTheme-=1
if !selectedTheme! lss 1 set selectedTheme=!themeCount!
echo=¤CTRL	APPLYTHEME	!theme[%selectedTheme%]!
echo=¤DW	!PID!.control
echo=¤CW	!PID!.control	!win[%PID%.control]X!	!win[%PID%.control]Y!	!win[%PID%.control]W!	!win[%PID%.control]H!	Control Panel
goto page[3].quickreload
:page[3].next
set /a "selectedTheme=selectedTheme %% themeCount + 1"
echo=¤CTRL	APPLYTHEME	!theme[%selectedTheme%]!
echo=¤DW	!PID!.control
echo=¤CW	!PID!.control	!win[%PID%.control]X!	!win[%PID%.control]Y!	!win[%PID%.control]W!	!win[%PID%.control]H!	Control Panel
goto page[3].quickreload
:page[3] Appearance
for /f "tokens=1 delims==" %%a in ('set btn[ 2^>nul') do set "%%a="

set user.globalTheme=aero
for /f "usebackq tokens=1* delims==" %%a in ("!sst.root!\Users\!sys.username!\userprofile.dat") do (
	set "user.%%a=%%b" > nul 2>&1
)
set buttons=prev next
set /a "btn[prev]Y=btn[next]Y=5, btn[prev]X=(btn[prev]BX=(btn[next]X=(btn[next]BX=win[!PID!.control]W-4)-2)-1)-2, themeCount=0, selectedTheme=1"
set btn[prev]=:page[3].prev
set btn[next]=:page[3].next
set "btn[prev]title= ◄ "
set "btn[next]title= ► "

for /f "delims=" %%R in ('dir /b /a:D "!sst.dir!\resourcepacks"') do for /f "delims=" %%T in ('dir /b /a:-D "!sst.dir!\resourcepacks\%%~nxR\themes" ^| find /v "CBUI"') do (
	set /a themeCount+=1
	set "theme[!themeCount!]=%%~nxT"
	if "!user.globalTheme!"=="%%~nxT" set selectedTheme=!themeCount!
)
:page[3].quickreload
for /l %%y in (1 1 !inbH!) do (
	set "o%%y=%\e%[!sidebarW!X"
	set "l%%y="
)
for /l %%y in (2 1 !pagesBY!) do set "o%%y=!o%%y!!page[%%y]!"
set "o!currentPage!=%\e%[!sidebarW!X%\e%[7m!page[%currentPage%]!%\e%[27m"

set "l2=%\e%[!sidebarW!C Appearance"
set "l4=%\e%[!sidebarW!C Current theme:"
set "l5=%\e%[!sidebarW!C%\e%[7m%\e%[!contentW!X%\e%[27m %\e%[7m !theme[%selectedTheme%]:~0,%contentW%!%\e%[27m
set "o5=!o5!%\e%8%\e%[!btn[prev]X!C ◄  ► "

set "pipe=¤MW	!PID!.control"
for /l %%y in (1 1 !inbH!) do set "pipe=!pipe!	l%%y=!l%%y!	o%%y=!o%%y!"
echo=!pipe!
set pipe=
exit /b 0
:page[2] Performance
for /l %%y in (1 1 !inbH!) do (
	set "o%%y=%\e%[!sidebarW!X"
	set "l%%y="
)
for /l %%y in (2 1 !pagesBY!) do set "o%%y=!o%%y!!page[%%y]!"
set "o!currentPage!=%\e%[!sidebarW!X%\e%[7m!page[%currentPage%]!%\e%[27m"
for /f "tokens=1 delims==" %%a in ('set btn[ 2^>nul') do set "%%a="

set "l2=%\e%[!sidebarW!C Performance settings"

set buttons=
for %%b in (
	"lowPerformanceMode	sys.lowPerformanceMode	4	Low Performance Mode"
	"reduceMotion	sys.reduceMotion	5	Reduce Motion"
) do for /f "tokens=1-4 delims=	" %%0 in (%%b) do (
	set buttons=!buttons! %%0
	set btn[%%0]=:spg %%0 %%1
	set /a "btn[%%0]Y=%%2, btn[%%0]BX=(btn[%%0]X=sidebarW+24)+2"
	if "!%%1!"=="True" (
		set "btn[%%0]title= ✓ "
	) else set "btn[%%0]title= × "
	set "l%%2=%\e%[!sidebarW!C %%3"
	set "o%%2=!o%%2!%\e%8%\e%[!btn[%%0]X!C!btn[%%0]title!"
)

set "pipe=¤MW	!PID!.control"
for /l %%y in (1 1 !inbH!) do set "pipe=!pipe!	l%%y=!l%%y!	o%%y=!o%%y!"
echo=!pipe!
set pipe=
exit /b 0
:page[2].cancel
for /l %%y in (1 1 !inbH!) do (
	set "o%%y=%\e%[!sidebarW!X"
	set "l%%y="
)
for /l %%y in (2 1 !pagesBY!) do set "o%%y=!o%%y!!page[%%y]!"
set "o!currentPage!=%\e%[!sidebarW!X%\e%[7m!page[%currentPage%]!%\e%[27m"
for /f "delims=" %%a in ('call "!sys.dir!\core\config.bat" --get lowPerformanceMode --get reduceMotion') do set "sys.%%a">nul 2>&1
goto page[2]
:page[2].apply
for /l %%y in (1 1 !inbH!) do (
	set "o%%y=%\e%[!sidebarW!X"
	set "l%%y="
)
for /l %%y in (2 1 !pagesBY!) do set "o%%y=!o%%y!!page[%%y]!"
set "o!currentPage!=%\e%[!sidebarW!X%\e%[7m!page[%currentPage%]!%\e%[27m"
call "!sys.dir!\core\config.bat" --set lowPerformanceMode !sys.lowPerformanceMode! --set reduceMotion !sys.reduceMotion!
if "!sys.lowPerformanceMode!"=="True" echo=¤CTRL	APPLYTHEME	classic
(
	echo=config	lowPerformanceMode=!sys.lowPerformanceMode!
	echo=config	reduceMotion=!sys.reduceMotion!
) >> "!sst.dir!\temp\kernelPipe"
>>"!sst.dir!\temp\kernelPipe" echo=createProcess	!PID!	systemb-dialog (sys.modeW-w)/2 (sys.modeH-h)/2 50 8 "Reboot recommended" "l2=  In order to apply your changes to the system	l3=  settings, It's recommended to log out from	l4=  for them to fully apply."	w-buttonW-2 h-2 12 " Understood "
goto page[2]
:page[4]
for /l %%y in (1 1 !inbH!) do (
	set "o%%y=%\e%[!sidebarW!X"
	set "l%%y="
)
for /l %%y in (2 1 !pagesBY!) do set "o%%y=!o%%y!!page[%%y]!"
set "o!currentPage!=%\e%[!sidebarW!X%\e%[7m!page[%currentPage%]!%\e%[27m"
for /f "tokens=1 delims==" %%a in ('set btn[ 2^>nul') do set "%%a="

set "l2=%\e%[!sidebarW!C System information"
set "l4=%\e%[!sidebarW!C Shivtanium !sys.tag! !sys.ver!"
set "l5=%\e%[!sidebarW!C !sys.subvinfo!"
set "l6=%\e%[!sidebarW!C Desktop environment: %\e%[7m systemb %\e%[27m"
set "l8=%\e%[!sidebarW!C Processor information"
set "l10=%\e%[!sidebarW!C Processor count: %\e%[7m !sys.CPU.count! %\e%[27m"
set "l11=%\e%[!sidebarW!C Processor architecture: %\e%[7m !sys.CPU.architecture:AMD64=64-bit! %\e%[27m"
set "l12=%\e%[!sidebarW!C Processor identifier:"
set "tempstr=!sys.CPU.identifier! "
set "l13=%\e%[!sidebarW!C %\e%[7m !tempstr:~0,%contentW%!%\e%[27m"
set tempstr=

set "pipe=¤MW	!PID!.control"
for /l %%y in (1 1 !inbH!) do set "pipe=!pipe!	l%%y=!l%%y!	o%%y=!o%%y!"
echo=!pipe!
set pipe=
exit /b 0
:page[5]
for /l %%y in (1 1 !inbH!) do (
	set "o%%y=%\e%[!sidebarW!X"
	set "l%%y="
)
for /l %%y in (2 1 !pagesBY!) do set "o%%y=!o%%y!!page[%%y]!"
set "o!currentPage!=%\e%[!sidebarW!X%\e%[7m!page[%currentPage%]!%\e%[27m"
for /f "tokens=1 delims==" %%a in ('set btn[ 2^>nul') do set "%%a="

set "l2=%\e%[!sidebarW!C System updates"


set /a "ll=0, currentLineN=4"
set currentLine=
for %%w in (
	Lorem ipsum dolor sit amet, consectetuer adipiscing elit.
	Etiam bibendum elit eget erat. Aliquam in lorem sit amet leo accumsan lacinia.
	Quisque tincidunt scelerisque libero. Suspendisse sagittis ultrices augue.
	Vivamus luctus egestas leo. Itaque earum rerum hic tenetur a sapiente delectus,
	ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis
	doloribus asperiores repellat. Phasellus et lorem id felis nonummy placerat.
	Mauris metus. Proin in tellus sit amet nibh dignissim sagittis.
	Pellentesque arcu. Etiam bibendum elit eget erat. 
) do (
	set "word=#%%w"
	set "wordLen=0"
	for /l %%1 in (9,-1,0) do (
		set /a "wordLen|=1<<%%1"
		for %%2 in (!wordLen!) do if "!word:~%%2,1!" equ "" set /a "wordLen&=~1<<%%1"
	)
	set /a "ll+=wordLen+1"
	if !ll! geq !contentW! (
		set "l!currentLineN!=%\e%[!sidebarW!C !currentLine!"
		set currentLine=
		set /a "ll=wordLen+1, currentLineN+=1"
	)
	set "currentLine=!currentLine!!word:~1! "
)
if defined currentLine set "l!currentLineN!=%\e%[!sidebarW!C !currentLine!"
set currentLine=
set currentLineN=
set wordLen=
set word=
set ll=

set "pipe=¤MW	!PID!.control"
for /l %%y in (1 1 !inbH!) do set "pipe=!pipe!	l%%y=!l%%y!	o%%y=!o%%y!"
echo=!pipe!
set pipe=
exit /b 0
