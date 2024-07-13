@echo off & setlocal enableDelayedExpansion
if not defined PID (
	echo This program requires to be run in:
	echo   Shivtanium Kernel Beta 1.2.1 or higher.
	set /p "=Press any key to exit. . ."
	exit /b 1
)
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
set "contentServer=http://newengine.org"
(set \n=^^^

)
set @preparePipe=for /l %%y in (1 1 ^^!avlH^^!) do (%\n%
	if "^!pipe:~700,1^!" neq "" (%\n%
		echo=^^!pipe^^!%\n%
		set "pipe=¤MW	^!PID^!.NEL"%\n%
	)%\n%
	set "pipe=^!pipe^!	l%%y=^!l%%y^!	o%%y=^!o%%y^!"%\n%
)
if /I "!sys.lowPerformanceMode!"=="True" set "sys.reduceMotion=True"
set /a "offsetY=scrollY=-1, scrollpos=0, tileC=(tileW=18)-1, tileH=6, sidebarW=11, descriptionW=(win[!PID!.NEL]W=96)-sidebarW-6, avlH=(contentH=(win[!PID!.NEL]H=29)-2)+1, win[!PID!.NEL]X=(sys.modeW - win[!PID!.NEL]W) / 2, win[!PID!.NEL]Y=(sys.modeH - win[!PID!.NEL]H) / 2, closeButtonX=win[!PID!.NEL]W-4"

echo=¤CW	!PID!.NEL	!win[%PID%.NEL]X!	!win[%PID%.NEL]Y!	!win[%PID%.NEL]W!	!win[%PID%.NEL]H!	NewEngine Launcher	eyeburn
>>"!sst.dir!\temp\kernelPipe" echo=registerWindow	!PID!	!PID!.NEL	!win[%PID%.NEL]X!	!win[%PID%.NEL]Y!	!win[%PID%.NEL]W!	!win[%PID%.NEL]H!
call :downloadGamesList
call :store
for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000)", "t2=t1"
for /l %%# in () do (
	for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000)", "deltaTime=(t1 - t2), scrollTimer+=deltaTime", "t2=t1"
	if "!buttons!;!focusedWindow!"==";!PID!.NEL" (
		if "!keysPressed!" neq "!keysPressed:-16-=!" set /a scrollTimer+=deltaTime*2
		if "!keysPressed!" neq "!keysPressed:-38-=!" (
			if !scrollTimer! geq 10 (
				set /a "scrollTimer%%=100, scrollY-=scrollTimer / 10, scrollpos=scrollY / (tileH + spacingH), offsetY=scrollY %% (tileH + spacingH), scrollTimer%%=10"
				call :!currentmenu!
			)
		) else if "!keysPressed!" neq "!keysPressed:-40-=!" (
			if !scrollTimer! geq 10 (
				set /a "scrollTimer%%=100, scrollY+=scrollTimer / 10, scrollpos=scrollY / (tileH + spacingH), offsetY=scrollY %% (tileH + spacingH), scrollTimer%%=10"
				call :!currentMenu!
			)
		) else set scrollTimer=0
	) else set scrollTimer=0
	
	set kernelOut=
	set /p "kernelOut="
	if defined kernelOut if "!kernelOut!"=="click=1" (
		if "!focusedWindow!"=="!PID!.NEL" (
			set /a "relativeMouseX=mouseXpos - win[!PID!.NEL]X, relativeMouseY=mouseYpos - win[!PID!.NEL]Y"
			if !relativeMouseX! lss !sidebarW! (
				if "!relativeMouseY!"=="2" (
					call :store
				) else if "!relativeMouseY!"=="3" (
					call :library
				)
			) else if "!relativeMouseY!"=="0" (
				if !relativeMouseX! geq !closeButtonX! (
					>>"!sst.dir!\temp\kernelPipe" echo=exitProcess	!PID!
					exit 0
				)
			) else if defined buttons (
				for %%b in (!buttons!) do (
					if "!relativeMouseY!"=="!btn[%%~b]Y!" if !relativeMouseX! geq !btn[%%~b]X! if !relativeMouseX! leq !btn[%%~b]BX! (
						for /f "delims=" %%y in ("!btn[%%~b]Y!") do echo=¤MW	!PID!.NEL	o%%y=!o%%y!%\e%8%\e%[7m%\e%[!btn[%%~b]X!C!btn[%%~b]title!%\e%[27m
					)
				)
			) else for /l %%Y in (0 1 !gfY!) do for /l %%X in (0 1 !gridW!) do if defined tile[%%Xx%%Y] (
				if !relativeMouseY! geq !tile[%%Xx%%Y]Y! if !relativeMouseY! leq !tile[%%Xx%%Y]BY! if !relativeMouseX! geq !tile[%%Xx%%Y]X! if !relativeMouseX! leq !tile[%%Xx%%Y]BX! (
					set /a "transitionSX=tile[%%Xx%%Y]X, transitionEX=sidebarW + 3, transitionSY=tile[%%Xx%%Y]Y, transitionEY=2, transitionDX=transitionSX - transitionEX, transitionDY=transitionSY - transitionEY"
					call :!currentMenu!.gamepage !tile[%%Xx%%Y]!
				)
			)
		)
	) else if "!kernelOut!"=="click=0" (
		if "!focusedWindow!"=="!PID!.NEL" (
			set /a "relativeMouseX=mouseXpos - win[!PID!.NEL]X, relativeMouseY=mouseYpos - win[!PID!.NEL]Y"
			if defined buttons for %%b in (!buttons!) do (
				if "!relativeMouseY!"=="!btn[%%~b]Y!" if !relativeMouseX! geq !btn[%%~b]X! if !relativeMouseX! leq !btn[%%~b]BX! (
					for /f "delims=" %%y in ("!btn[%%~b]Y!") do echo=¤MW	!PID!.NEL	o%%y=!o%%y!%\e%8%\e%[!btn[%%~b]X!C!btn[%%~b]title!
					call !btn[%%~b]!
				)
			)
		)
	) else if "!kernelOut!"=="exitProcess=!PID!" (
		exit 0
	) else if "!kernelOut!"=="exit" (
		exit 0
	) else set "!kernelOut!">nul 2>&1
)

exit /b
:store
set currentMenu=store
set buttons=
for /l %%y in (1 1 !avlH!) do (
	set "o%%y=%\e%[!sidebarW!X"
	set "l%%y="
)
if !scrollY! lss -1 (
	set scrollpos=0
	set scrollY=-1
	set offsetY=-1
)
set /a "scrollbarX=win[!PID!.NEL]W - 3, pos=0, spacingW=2, spacingH=1, ftW=(gridW=(rsW=win[!PID!.NEL]W - sidebarW - 4) / (tileW + spacingW)) + 2, gfY=(rsH=win[!PID!.NEL]H - 3) / (tileH + spacingH) + 1"

set "o2=!o2! %\e%[7m  Store  %\e%[27m"
set "o3=!o3!  Library"
set "l!avlH!=%\e%8%\e%[!sidebarW!C   %\e%[!rsW!X"
for /f %%a in ('set tile[ 2^>nul') do set "%%a="
for %%g in (!games!) do (
	set /a "posX=pos %% gridW, posY=(lines=pos / gridW) - scrollpos, pos+=1"
	if !posY! geq 0 if !posY! leq !gfY! (
		set "tile[!posX!x!posY!]=%%~g"
		set /a "x=tile[!posX!x!posY!]X=rsW / gridW * posX + spacingW + sidebarW, tile[!posX!x!posY!]BX=tile[!posX!x!posY!]X+tileW-1, y=tile[!posX!x!posY!]Y=posY * (tileH + spacingH) + spacingH - offsetY, bottom=tile[!posX!x!posY!]BY=tile[!posX!x!posY!]Y+tileH-1", "temp.1=y+1, temp.2=y+2, temp.3=y+3, temp.4=y+4, temp.5=y+5"

		for /f "tokens=1-6" %%0 in ("!y! !temp.1! !temp.2! !temp.3! !temp.4! !temp.5!") do (
			set /p "game.name="
			set "game.name=!game.name:*:=!"
			set /p "game.description="
			set /p "game.DSCIP[1]="
			set /p "game.DSCIP[2]="
			set /p "game.DSCIP[3]="
			set /p "game.DSCIP[4]="
			set /p "game.DSCIP[5]="
			
			set "o%%0=!o%%0!%\e%[7m%\e%8%\e%[!x!C%\e%[!tileW!X !game.name:~0,%tileC%!%\e%[27m"
			set "o%%1=!o%%1!%\e%8%\e%[!x!C%\e%[!tileW!X !game.DSCIP[1]:*:=!"
			set "o%%2=!o%%2!%\e%8%\e%[!x!C%\e%[!tileW!X !game.DSCIP[2]:*:=!"
			set "o%%3=!o%%3!%\e%8%\e%[!x!C%\e%[!tileW!X !game.DSCIP[3]:*:=!"
			set "o%%4=!o%%4!%\e%8%\e%[!x!C%\e%[!tileW!X !game.DSCIP[4]:*:=!"
			set "o%%5=!o%%5!%\e%8%\e%[!x!C%\e%[!tileW!X !game.DSCIP[5]:*:=!"
			set game.DSCIP[1]=
			set game.DSCIP[2]=
			set game.DSCIP[3]=
			set game.DSCIP[4]=
			set game.DSCIP[5]=
		) < "!sst.dir!\temp\NEL\game_%%~g.dat"
	)
)
set /a "bottom=(pos / gridW) * (tileH + spacingH) + spacingH + tileH - 1"
set "scY=!gfY!"
if !posY! lss !gfY! set gfY=!posY!
for /f "tokens=1 delims==" %%a in ('set game.') do set "%%a="
if !lines! geq !gfY! (
	set /a "scrollbar.S=scrollY * rsH / (bottom - rsH / 2) + 1, scrollbar.E=(scrollY + rsH) * rsH / (bottom - rsH / 2) + 1"
	for /l %%y in (!scrollbar.S! 1 !scrollbar.E!) do (
		set "o%%y=!o%%y!%\e%8%\e%[!scrollbarX!C "
	)
	if !scrollbar.E! gtr !rsH! set /a scrollY-=scrollbar.E - rsH - 1
)


set pipe=¤MW	!PID!.NEL
%@preparePipe%
echo=!pipe!
set pipe=

for /f "tokens=1 delims==" %%a in ('set o') do set "%%a="

set > "!sst.dir!\temp\proc\PID-!PID!-MemoryDump"
exit /b 0
:store.gamepage
set "gameID=%~1"
set /a "gameID=gameID"
for /l %%y in (1 1 !avlH!) do (
	set "o%%y=%\e%[!sidebarW!X"
	set "l%%y="
)
set "o2=%\e%[!sidebarW!X   Store "
set "o3=%\e%[!sidebarW!X  Library"

for /f "usebackq tokens=1* delims=:" %%a in ("!sst.dir!\temp\NEL\game_!gameID!.dat") do set "game.%%a=%%b"

if /I "!sys.reduceMotion!" neq "True" (
	for /l %%x in (10 -1 1) do (
		set /a "x=transitionEX+(transitionDX * %%x / 10-1), y=transitionEY+(transitionDY * %%x / 10)"
		for /l %%y in (1 1 !contentH!) do (
			set "o%%y=%\e%[!sidebarW!X"
			set "l%%y="
		)
		set "o!y!=%\e%[!sidebarW!X%\e%[!x!C !game.name! "
		set "o2=!o2!%\e%8   Store "
		set "o3=!o3!%\e%8  Library"
		
		set pipe=¤MW	!PID!.NEL
		for /l %%y in (1 1 !avlH!) do set "pipe=!pipe!	o%%y=!o%%y!"
		echo=!pipe!	l!avlH!=
		set pipe=
	)
) else (
	for /l %%y in (1 1 !contentH!) do (
		set "o%%y=%\e%[!sidebarW!X"
		set "l%%y="
	)	
	set "o2=%\e%[!sidebarW!X   Store %\e%[!sidebarW!C%\e%[7D !game.name! "
	set "o3=%\e%[!sidebarW!X  Library"
	set pipe=¤MW	!PID!.NEL
	for /l %%y in (1 1 !avlH!) do set "pipe=!pipe!	o%%y=!o%%y!"
	echo=!pipe!	l!avlH!=
	set pipe=
)
set "o!y!=%\e%[!sidebarW!X"
set "o2=%\e%[!sidebarW!X   Store %\e%[!sidebarW!C%\e%[7D !game.name! "
set "o3=%\e%[!sidebarW!X  Library"
echo=¤MW	!PID!.NEL	o1=!o1!	o2=!o2!	o3=!o3!	o4=!o4!	o5=!o5!	o6=!o6!

set /a "ll=0, currentLineN=1, temp.descriptionH=contentH-3"
set currentLine=
for %%w in (!game.description!) do (
	set "word=#%%w"
	set "wordLen=0"
	for /l %%1 in (9,-1,0) do (
		set /a "wordLen|=1<<%%1"
		for %%2 in (!wordLen!) do if "!word:~%%2,1!" equ "" set /a "wordLen&=~1<<%%1"
	)
	set /a "ll+=wordLen+1"
	if !ll! geq !descriptionW! (
		set "gp[!currentLineN!]=!currentLine!"
		set currentLine=
		set /a "ll=wordLen+1, currentLineN+=1"
	)
	set "currentLine=!currentLine!!word:~1! "
)
set "gp[!currentLineN!]=!currentLine!"
set currentLine=
set currentLineN=
set wordLen=
set word=
set ll=

set /a "btn[back]Y=contentH, btn[back]X=win[!PID!.NEL]W-8, btn[back]BX=btn[back]X+5", "btn[add]Y=contentH, btn[add]X=btn[back]X-18, btn[add]BX=btn[add]X+15"
set btn[back]=:store
set btn[add]=:error "Failed to add game to library" "Not implemented."
set "btn[back]title= Back "
set "btn[add]title= Add to library "
set "o!btn[back]Y!=!o%btn[back]Y%!%\e%8%\e%[!btn[add]X!C!btn[add]title!%\e%[2C!btn[back]title!"

if /I "!sys.reduceMotion!"=="True" (
	set "pipe=¤MW	!PID!.NEL	o!btn[back]Y!=!o%btn[back]Y%!"
	for /l %%t in (1 1 !temp.descriptionH!) do if defined gp[%%t] (
		if "!pipe:~720,1!" neq "" (
			echo=!pipe!
			set "pipe=¤MW	!PID!.NEL"
		)
		set /a "y=%%t+3"
		set "pipe=!pipe!	!PID!.NEL	l!y!=%\e%[!sidebarW!C !gp[%%t]!"
	)
	echo=!pipe!
	set pipe=
) else (
	for /l %%t in (1 1 !temp.descriptionH!) do if defined gp[%%t] (
		set /a "y=%%t+3"
		echo=¤MW	!PID!.NEL	l!y!=%\e%[!sidebarW!C     !gp[%%t]!
		echo=¤MW	!PID!.NEL	l!y!=%\e%[!sidebarW!C   !gp[%%t]!
		echo=¤MW	!PID!.NEL	l!y!=%\e%[!sidebarW!C !gp[%%t]!
	)
	echo=¤MW	!PID!.NEL	o!btn[back]Y!=!o%btn[back]Y%!
)

set temp.descriptionH=
set gameID=

set "buttons= back add "

for /l %%# in (1 1 3) do (
	set kernelOut=
	set /p kernelOut=
	if "!kernelOut!"=="exitProcess=!PID!" (
		exit 0
	) else if "!kernelOut!"=="exit" (
		exit 0
	) else set "!kernelOut!">nul 2>&1
)

exit /b
:library
set currentMenu=library
for /f %%a in ('set tile[ 2^>nul ^&^& set game. 2^>nul') do set "%%a="

set /a "btn[back]Y=4, btn[back]X=sidebarW + 2, btn[back]BX=btn[back]X + 19"
set btn[back]=:store
set "btn[back]title= Back to store page "
set "buttons= back "

for /l %%y in (1 1 !avlH!) do (
	set "o%%y=%\e%[!sidebarW!X"
	set "l%%y="
)
set "o2=%\e%[!sidebarW!X   Store "
set "o3=%\e%[!sidebarW!X %\e%[7m Library %\e%[27m"
set "l2=%\e%[!sidebarW!C Currently unavaliable."
set "o4=!o4!%\e%8%\e%[!btn[back]X!C!btn[back]title!"

set pipe=¤MW	!PID!.NEL
%@preparePipe%
echo=!pipe!
set pipe=
exit /b
:downloadGamesList
set pipe=¤MW	!PID!.NEL
for /l %%y in (1 1 !avlH!) do set "pipe=!pipe!	o%%y=%\e%[!sidebarW!X"
echo=!pipe!
set pipe=
if exist "!sst.dir!\temp\NEL" rd /s /q "!sst.dir!\temp\NEL" > nul 2>&1 || call :error "Failed to free up memory space." "This might have been caused by running" "multiple launchers running at once."
md "!sst.dir!\temp\NEL"
set serviceStatus=unknown
set response=
for /f "delims=" %%a in ('curl "!contentServer!:3000/v1/getServerStatus" 2^>^&1') do (
	set "temp=%%a"
	if /I "!temp:~0,7!"=="status:" (
		set "serviceStatus=!temp:~7!"
	)
	set response=!response! "%%~a"
)
if /I "!serviceStatus!" neq "online" (
	call :error "Failed to connect to the server" !response!
	exit /b 1
)


set storeGamesCount=0
set halt=
set games=
for /f "tokens=1* delims=:" %%a in ('curl.exe -s "!contentServer!:3000/v1/getAllAppInfo" 2^>^&1') do (
	set kernelOut=
	set /p kernelOut=
	if defined kernelOut if "!kernelOut!"=="click=1" (
		if "!focusedWindow!"=="!PID!.NEL" (
			set /a "relativeMouseX=mouseXpos - win[!PID!.NEL]X, relativeMouseY=mouseYpos - win[!PID!.NEL]Y"
			if "!relativeMouseY!"=="0" (
				if !relativeMouseX! geq !closeButtonX! (
					>>"!sst.dir!\temp\kernelPipe" echo=exitProcess	!PID!
					exit 0
				)
			)
		)
	) else if "!kernelOut!"=="exitProcess=!PID!" (
		exit 0
	) else if "!kernelOut!"=="exit" (
		exit 0
	) else set "!kernelOut!">nul 2>&1
	
	if /I "%%a"=="appId" (
		set /a storeGamesCount+=1
		set "APPID=%%~b"
		set "games=!games! !APPID!"
		echo=¤MW	!PID!.NEL	l2=%\e%[!sidebarW!C Parsing game ID: !APPID!
		if "!APPID!;!APPID!" neq "!APPID:\=!;!APPID:/=!" call :error "Invalid Game ID" "Game ID parsing has been stopped" "due to a possible RCE exploit attempt." "Game ID: !APPID!"
		copy nul "!sst.dir!\temp\NEL\game_!APPID!.dat"
	) else (
		set err=App ID: !APPID!
		if not defined APPID set err=[No APP ID]
		if "%%a"=="name" (
			set err=
			>>"!sst.dir!\temp\NEL\game_!APPID!.dat" echo=name:%%b
		) else if "%%a"=="description" ((
			set err=
			echo=description:%%b
			set /a "ll=0, currentLineN=1"
			set currentLine=
			for %%w in (%%~b) do (
				set "word=#%%w"
				set "wordLen=0"
				for /l %%1 in (9,-1,0) do (
					set /a "wordLen|=1<<%%1"
					for %%2 in (!wordLen!) do if "!word:~%%2,1!" equ "" set /a "wordLen&=~1<<%%1"
				)
				set /a "ll+=wordLen+1"
				if !ll! geq !tileC! (
					echo=DSCIP[!currentLineN!]:!currentLine!
					set currentLine=
					set /a "ll=wordLen+1, currentLineN+=1"
				)
				set "currentLine=!currentLine!!word:~1! "
			)
			echo=DSCIP[!currentLineN!]:!currentLine!
			set /a currentLineN+=1
			for /l %%i in (!currentLineN! 1 5) do echo=DSCIP[%%i]:
			set currentLine=
			set currentLineN=
			set wordLen=
			set word=
			set ll=
			
		)>>"!sst.dir!\temp\NEL\game_!APPID!.dat") else if "%%a"=="versions" (
			set err=
			>>"!sst.dir!\temp\NEL\game_!APPID!.dat" echo=versions:%%b
		)
	)
	if defined err (
		set err=
		set halt=!halt! "%%~a"
		echo=¤MW	!PID!.NEL	l4=%\e%[!sidebarW!C Found an error. Information will be displayed shortly. !err!
	)
)
if defined halt (
	call :error "Error log" !halt!
	exit /b 1
)
exit /b 0
:error
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

>>"!sst.dir!\temp\kernelPipe" echo=createProcess	!sys.UPID!	systemb-dialog !win[%PID%.NEL]X!+!sidebarW!+2 !win[%PID%.NEL]Y!+2 !halt.winW! !halt.winH! "!halt.title!	eyeburn" "!halt.winparams!" w-buttonW-2 h-2 7 " Close "
exit /b 0

< This will never execute. >

#	http://newengine.org:3000/v1/search?query=QUERY
#	if no query is given, all game IDs are returned
#
#	http://newengine.org:3000/v1/getAppInfo?appId=APPID
#	returns app info
#
#	http://newengine.org:3000/v1/getApp?appId=APPID
#	returns app (nea) file
