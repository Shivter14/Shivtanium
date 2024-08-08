@echo off & setlocal enabledelayedexpansion
REM Some math right here
set "_SIN=a-a*a/1920*a/312500+a*a/1920*a/15625*a/15625*a/2560000-a*a/1875*a/15360*a/15625*a/15625*a/16000*a/44800000"
set "sinr=(a=(x)%%62832, c=(a>>31|1)*a, a-=(((c-47125)>>31)+1)*((a>>31|1)*62832)  +  (-((c-47125)>>31))*( (((c-15709)>>31)+1)*(-(a>>31|1)*31416+2*a)  ), !_SIN!) / 10000"
set "sinr=!sinr: =!"
set "cosr=(a=(15708 - x)%%62832, c=(a>>31|1)*a, a-=(((c-47125)>>31)+1)*((a>>31|1)*62832)  +  (-((c-47125)>>31))*( (((c-15709)>>31)+1)*(-(a>>31|1)*31416+2*a)  ), !_SIN!) / 10000"
set "cosr=!cosr: =!"
set "sin=(a=((x*31416/180)%%62832)+(((x*31416/180)%%62832)>>31&62832), b=(a-15708^a-47124)>>31,a=(-a&b)+(a&~b)+(31416&b)+(-62832&(47123-a>>31)),a-a*a/1875*a/320000+a*a/1875*a/15625*a/16000*a/2560000-a*a/1875*a/15360*a/15625*a/15625*a/16000*a/44800000) / 10000"
set "cos=(a=((15708-x*31416/180)%%62832)+(((15708-x*31416/180)%%62832)>>31&62832), b=(a-15708^a-47124)>>31,a=(-a&b)+(a&~b)+(31416&b)+(-62832&(47123-a>>31)),a-a*a/1875*a/320000+a*a/1875*a/15625*a/16000*a/2560000-a*a/1875*a/15360*a/15625*a/15625*a/16000*a/44800000) / 10000"
set /a "PI=(35500000/113+5)/10, HALF_PI=(35500000/113/2+5)/10, TAU=TWO_PI=2*PI, PI32=PI+HALF_PI"
set "sst.boot.msg= "

set /a "sst.boot.logoX=(sys.modeW-58)/2+1", "sst.boot.logoY=(sys.modeH-9)/2+1, l=1, j=2"

set "s2=▓▓▓▒▒░░                                             ░░▒▒▓▓"
set "s3=▓▓▒▒░░   ▄▄▄ ▄    ▄      ▄            ▄            ░░▒▒▓▓▓"
set "s4=▓▓▓▒▒░░ █    █          ▄█▄                         ░░▒▒▓▓"
set "s5=▓▓▒▒░░   ▀▀▄ █▀▀▄ █ █ █  █  ▄▀▀▄ █▀▀▄ █ █  █ █▀▄▀▄ ░░▒▒▓▓▓"
set "s6=▓▓▓▒▒░░ ▄▄▄▀ █  █ █ ▀█▀  █  ▀▄▄█ █  █ █ ▀▄▄█ █ █ █  ░░▒▒▓▓"
set "s7=▓▓▒▒░░          ▀         ▀         ▀        ▀     ░░▒▒▓▓▓"
set "s8=▓▓▓▒▒░░                                             ░░▒▒▓▓"

set "buildstring=MA+=deltaTime"
set "echostring=%\e%[!sst.boot.logoY!;!sst.boot.logoX!H%\e%7%\e%[38;2;;;m"
for /l %%a in (0 2 57) do (
	set "echostring=!echostring!%\e%[48;2;^!c%%a^!;^!c%%a^!;^!c%%a^!m%\e%8%\e%[B!s2:~%%a,2!%\e%8%\e%[2B!s3:~%%a,2!%\e%8%\e%[3B!s4:~%%a,2!%\e%8%\e%[4B!s5:~%%a,2!%\e%8%\e%[5B!s6:~%%a,2!%\e%8%\e%[6B!s7:~%%a,2!%\e%8%\e%[7B!s8:~%%a,2!%\e%8%\e%[2C%\e%7"
	set "buildstring=!buildstring!,c%%a=l*^!sinr:x=((MA+%%a)*420)^!+j"
)


for /f "tokens=1-4 delims=:.," %%a in ( "!time: =0!" ) do set /a "t1=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100", "t2=t1", "MA=0"
echo=%\e%[48;2;;;;38;2;255;255;255m%\e%[2J
:initial_animation
	set /a "%buildstring%"
	echo=%echostring%
	for /f "tokens=1-4 delims=:.," %%a in ( "!time: =0!" ) do set /a "t1=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100", "j=(l+=(deltaTime=(t1 - t2))*2)+1", "t2=t1"
if !l! lss 127 goto initial_animation
set l=127
set j=128

for /l %%. in () do (
	for /f "tokens=1-4 delims=:.," %%a in ( "!time: =0!" ) do set /a "t1=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100", "deltaTime=(t1 - t2)", "t2=t1", "offsetX=t1 %% 3 - 1, offsetY=(t1 - 1) %% 3 - 1"
	
	set input=
	set /p input=
	if "!input:~-9!"=="¤EXITANIM" (
		call :exitAnim
	)
	if defined input (
		set "sst.boot.msg=#!input!"
		set sst.boot.msglen=0
			for /l %%b in (9,-1,0) do (
				set /a "sst.boot.msglen|=1<<%%b"
				for %%c in (!sst.boot.msglen!) do if "!sst.boot.msg:~%%c,1!" equ "" set /a "sst.boot.msglen&=~1<<%%b"
			)
		set /a "sst.boot.msgX=(!sys.modeW!-!sst.boot.msglen!)/2"
	)
	set /a "%buildstring%"
	echo=%echostring%%\e%[48;2;;;;38;2;255;255;255m%\e%[!sst.boot.msgY!;!sst.boot.msgX!H%\e%[2K!sst.boot.msg:~1!
)
:exitAnim
for /f "usebackq tokens=1* delims==" %%a in ("!sst.dir!\settings.dat") do set "sys.%%~a=%%~b"
for /f "usebackq tokens=1* delims==" %%x in ("!sst.dir!\resourcepacks\init\themes\!sys.loginBGtheme!") do set "dwm.%%x=%%y"

for /f "tokens=1-4 delims=:.," %%a in ( "!time: =0!" ) do set /a "t1=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100,t2=t1, sst.boot.fadeout=255"
for /l %%. in () do (
	for /f "tokens=1-4 delims=:.," %%a in ( "!time: =0!" ) do set /a "t1=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100", "DeltaTime=(t1-t2)", "t2=t1", "j=(l=(sst.boot.fadeout-=deltaTime*4)/2)+1"
	if "!deltaTime!" neq "0" (
		set /a "%buildstring%, textFadeout=127 * %sinr:x=(sst.boot.fadeout*PI/255+PI32)% + 128"
		echo=%echostring%%\e%[48;2;;;;38;2;!textFadeout!;!textFadeout!;!textFadeout!m%\e%[!sst.boot.msgY!;!sst.boot.msgX!H%\e%[2K!sst.boot.msg:~1!
	) < nul
	if !sst.boot.fadeout! lss 1 (
		set sst.boot.fadeout=0
		for /l %%# in () do (
			for /f "tokens=1-4 delims=:.," %%a in ( "!time: =0!" ) do set /a "t1=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100", "sst.boot.fadeout+=(DeltaTime=(t1-t2))*4", "t2=t1"
			if "!deltaTime!" neq "0" (
				if !sst.boot.fadeout! gtr 255 (
					copy nul "!sst.dir!\temp\pf-bootanim" > nul
					exit 0
				)
				set "dwm.scene=%\e%[H"
				for /l %%x in (1 1 !modeH!) do (
					set /a "x=%%x", "!dwm.aero:×=*!", "r=r*sst.boot.fadeout/255, g=g*sst.boot.fadeout/255, b=b*sst.boot.fadeout/255"
					set dwm.scene=!dwm.scene!%\e%[48;2;!r!;!g!;!b!m%\e%[2K%\e%[B
				)
				echo=!dwm.scene!
			)
		)
	)
)
:loadSprites
set "spr.[%~2]=%\e%7"
set /a "spr.W=0", "spr.[%~2].H=0"
for /f "delims=" %%a in ('type "%~1"') do (
	set "spr.temp=x%%~a"
	set "spr.[%~2]=!spr.[%~2]!%%~a%\e%8%\e%[B%\e%7"
	set spr.tempW=0
	for /l %%b in (9,-1,0) do (
		set /a "spr.tempW|=1<<%%b"
		for %%c in (!spr.tempW!) do if "!spr.temp:~%%c,1!" equ "" set /a "spr.tempW&=~1<<%%b"
	)
	if !spr.tempW! gtr !spr.W! set spr.W=!spr.tempW!
	set /a "spr.[%~2].H+=1"
)
set "spr.[%~2].W=!spr.W!"
set spr.W=
set spr.temp=
set spr.tempW=
exit /b 0
