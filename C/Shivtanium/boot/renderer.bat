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
for /f "usebackq tokens=1* delims==" %%a in ("!sst.dir!\settings.dat") do set "sys.%%~a=%%~b"
for /f "usebackq tokens=1* delims==" %%x in ("!sst.dir!\resourcepacks\init\themes\!sys.loginBGtheme!") do set "dwm.%%x=%%y"
if defined dwm.sceneBGcolor (
	if "!dwm.sceneBGcolor:~0,2!"=="2;" (
		for /f "tokens=2-4 delims=;" %%a in ("!dwm.sceneBGcolor!") do set "dwm.aero=r=%%a, g=%%b, b=%%c"
	) else if "!dwm.sceneBGcolor:~0,2!"=="5;" for /f "tokens=2 delims=;" %%a in ("!dwm.sceneBGcolor!") do (
		if %%a lss 16 (
			set "xth.dcp[0]=r=12, g=12, b=12"
			set "xth.dcp[1]=r=0, g=55, b=218"
			set "xth.dcp[2]=r=19, g=161, b=14"
			set "xth.dcp[3]=r=58, g=150, b=221"
			set "xth.dcp[4]=r=197, g=15, b=31"
			set "xth.dcp[5]=r=136, g=23, b=152"
			set "xth.dcp[6]=r=193, g=156, b=0"
			set "xth.dcp[7]=r=204, g=204, b=204"
			set "xth.dcp[8]=r=118, g=118, b=118"
			set "xth.dcp[9]=r=59, g=120, b=255"
			set "xth.dcp[10]=r=22, g=198, b=12"
			set "xth.dcp[11]=r=97, g=214, b=214"
			set "xth.dcp[12]=r=231, g=72, b=86"
			set "xth.dcp[13]=r=180, g=0, b=158"
			set "xth.dcp[14]=r=249, g=241, b=165"
			set "xth.dcp[15]=r=242, g=242, b=242"
			if defined xth.dcp[%%a] set /a "dwm.aero=!xth.dcp[%%a]!"
		) else if %%a lss 232 (
			set /a "r=(%%a - 16) / 36 * 95, g=(%%a - 16) / 6 %% 6 * 36, b=(%%a - 16) %% 6 * 36"
			set "dwm.aero=r=!r!, g=!g!, b=!b!"
			start
		) else set "dwm.aero=r=g=b=(%%a - 232) * 226 / 24 + 12"
	)
) else if defined dwm.aero set "dwm.aero=!dwm.aero:×=*!"

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
		for /f "tokens=1-4 delims=^!;" %%a in ("!input!") do (
			set "sst.boot.msg=#%%a"
			set "sst.boot.submsg=#%%b"
			if "%%c" neq "" (
				set /a "bar.width=sys.modeW*7/8, bar.fill=%%d*bar.width/%%c, bar.X=(sys.modeW-bar.width)/2, bar.Y=sys.modeH*7/8"
				if !sys.modeH! lss 30 (
					set /a "bar.width=sys.modeW, bar.fill=%%d*bar.width/%%c, bar.X=1, bar.Y=sys.modeH"
				)
				if !sys.modeH! lss 80 (
					set /a "bar.width=sys.modeW, bar.fill=%%d*bar.width/%%c, bar.X=1, bar.Y=sys.modeH"
				)
				set "barbuffer=%\e%[!bar.Y!;!bar.X!H%\e%[48;2;127;127;127m%\e%[!bar.width!X%\e%[48;2;255;255;255m%\e%[!bar.fill!X"
			)
		)
		set sst.boot.msglen=0
		for /l %%b in (9,-1,0) do (
			set /a "sst.boot.msglen|=1<<%%b"
			for %%c in (!sst.boot.msglen!) do if "!sst.boot.msg:~%%c,1!" equ "" set /a "sst.boot.msglen&=~1<<%%b"
		)
		set sst.boot.submsglen=0
		for /l %%b in (9,-1,0) do (
			set /a "sst.boot.submsglen|=1<<%%b"
			for %%c in (!sst.boot.submsglen!) do if "!sst.boot.submsg:~%%c,1!" equ "" set /a "sst.boot.submsglen&=~1<<%%b"
		)
		set /a "sst.boot.msgX=(sys.modeW-sst.boot.msglen)/2, sst.boot.submsgX=(sys.modeW-sst.boot.submsglen)/2"
	)
	set /a "%buildstring%"
	echo=%echostring%%\e%[48;2;;;;38;2;255;255;255m%\e%[!sst.boot.msgY!;!sst.boot.msgX!H%\e%[2K!sst.boot.msg:~1!%\e%[2E%\e%[!sst.boot.submsgX!G%\e%[2K!sst.boot.submsg:~1!!barbuffer!%\e%[H
)
:exitAnim
for /f "tokens=1-4 delims=:.," %%a in ( "!time: =0!" ) do set /a "t1=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100,t2=t1, sst.boot.fadeout=255"
for /l %%. in () do (
	for /f "tokens=1-4 delims=:.," %%a in ( "!time: =0!" ) do set /a "t1=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100", "DeltaTime=(t1-t2)", "t2=t1", "j=(l=(sst.boot.fadeout-=deltaTime*4)/2)+1"
	if "!deltaTime!" neq "0" (
		set /a "%buildstring%, textFadeout=127 * %sinr:x=(sst.boot.fadeout*PI/255+PI32)% + 128"
		echo=%echostring%%\e%[48;2;;;;38;2;!textFadeout!;!textFadeout!;!textFadeout!m%\e%[!sst.boot.msgY!;!sst.boot.msgX!H%\e%[2K!sst.boot.msg:~1!
	) < nul
	if !sst.boot.fadeout! lss 1 call :fadein
)
:fadein
set sst.boot.fadeout=0
for /l %%# in () do (
	for /f "tokens=1-4 delims=:.," %%a in ( "!time: =0!" ) do set /a "t1=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100", "sst.boot.fadeout+=(DeltaTime=(t1-t2))*4", "t2=t1"
	if "!deltaTime!" neq "0" (
		if !sst.boot.fadeout! gtr 255 (
			copy nul "!sst.dir!\temp\pf-bootanim" > nul
			exit 0
		)
		set "dwm.scene=%\e%[H"
		for /l %%x in (1 1 !sys.modeH!) do (
			set /a "x=%%x", "!dwm.aero:mode=sys.mode!", "r=r*sst.boot.fadeout/255, g=g*sst.boot.fadeout/255, b=b*sst.boot.fadeout/255"
			set dwm.scene=!dwm.scene!%\e%[48;2;!r!;!g!;!b!m%\e%[2K%\e%[B
		)
		echo=!dwm.scene!%\e%[H
	)
)
exit /b
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
