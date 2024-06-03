@echo off & setlocal enabledelayedexpansion
REM Some math right here
set "_SIN=a-a*a/1920*a/312500+a*a/1920*a/15625*a/15625*a/2560000-a*a/1875*a/15360*a/15625*a/15625*a/16000*a/44800000"
set "sinr=(a=(x)%%62832, c=(a>>31|1)*a, a-=(((c-47125)>>31)+1)*((a>>31|1)*62832)  +  (-((c-47125)>>31))*( (((c-15709)>>31)+1)*(-(a>>31|1)*31416+2*a)  ), !_SIN!) / 10000"
set "cosr=(a=(15708 - x)%%62832, c=(a>>31|1)*a, a-=(((c-47125)>>31)+1)*((a>>31|1)*62832)  +  (-((c-47125)>>31))*( (((c-15709)>>31)+1)*(-(a>>31|1)*31416+2*a)  ), !_SIN!) / 10000"
set "sin=(a=((x*31416/180)%%62832)+(((x*31416/180)%%62832)>>31&62832), b=(a-15708^a-47124)>>31,a=(-a&b)+(a&~b)+(31416&b)+(-62832&(47123-a>>31)),a-a*a/1875*a/320000+a*a/1875*a/15625*a/16000*a/2560000-a*a/1875*a/15360*a/15625*a/15625*a/16000*a/44800000) / 10000"
set "cos=(a=((15708-x*31416/180)%%62832)+(((15708-x*31416/180)%%62832)>>31&62832), b=(a-15708^a-47124)>>31,a=(-a&b)+(a&~b)+(31416&b)+(-62832&(47123-a>>31)),a-a*a/1875*a/320000+a*a/1875*a/15625*a/16000*a/2560000-a*a/1875*a/15360*a/15625*a/15625*a/16000*a/44800000) / 10000"
set /a "PI=(35500000/113+5)/10, HALF_PI=(35500000/113/2+5)/10, TAU=TWO_PI=2*PI, PI32=PI+HALF_PI"

set /a "x=sys.modeW/2, y=sys.modeH-4", "bufferX=x-4"
<nul set /p "=%\e%[?25l"

for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000)", "t2=t1", "ts=t1"
for /l %%. in () do (
	for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000)", "deltaTime=(t1 - t2)", "chunk.start+=deltaTime * 400", "chunk.end+=deltaTime * 600", "t2=t1", "tr=(t1-ts)*2"
	
	set /a switch=chunk.end-chunk.start
	if !switch! gtr !PI! set /a "chunk.start=!chunk.end!, chunk.end=!chunk.start!"
	set c=512
	if !chunk.start! gtr !chunk.end! set c=-512
	for /l %%y in (-5 1 6) do set "bitmap[%%y]=         "
	set lastMatrixEdit=
	for /l %%a in (!chunk.start! !c! !chunk.end!) do (
		set /a "cx=5 * !cosr:x=%%a! + 4", "cy=6 * !sinr:x=%%a!", "cz=cx+1"
		if "!lastMatrixEdit!" neq "!cx!;!cy!" for /f "tokens=1-3" %%x in ("!cx! !cy! !cz!") do set "bitmap[%%y]=!bitmap[%%y]:~0,%%x!█!bitmap[%%y]:~%%z!"
		set "lastMatrixEdit=!cx!;!cy!"
	)
	set input=
	set /p input=
	set framebuffer=
	if !tr! lss 255 set framebuffer=%\e%[38;2;!tr!;!tr!;!tr!m
	for /l %%y in (-5 2 6) do (
		set /a temp=%%y+1
		for %%z in (!temp!) do (
			for /l %%x in (0 1 8) do (
				if "!bitmap[%%y]:~%%x,1!!bitmap[%%z]:~%%x,1!"=="  " (
					set "framebuffer[%%y]=!framebuffer[%%y]! "
				) else if "!bitmap[%%y]:~%%x,1!!bitmap[%%z]:~%%x,1!"=="█ " (
					set "framebuffer[%%y]=!framebuffer[%%y]!▀"
				) else if "!bitmap[%%y]:~%%x,1!!bitmap[%%z]:~%%x,1!"==" █" (
					set "framebuffer[%%y]=!framebuffer[%%y]!▄"
				) else set "framebuffer[%%y]=!framebuffer[%%y]!!bitmap[%%y]:~%%x,1!"
			)
		)
	)
	for /l %%y in (-5 2 6) do (
		set framebuffer[%%y]=!framebuffer[%%y]:~0,5!!framebuffer[%%y]:~4!
		set /a tempY=y+%%y/2
		set framebuffer=!framebuffer!%\e%[!tempY!;!bufferX!H!framebuffer[%%y]!
		set framebuffer[%%y]=
	)
	if !tr! lss 255 set "framebuffer=!framebuffer!%\e%[38;2;255;255;255m"
	if "!input:~-5!"=="¤EXIT" (
		exit
	) else if "!input:~-5!"=="¤FADE" set ts=!t1!
	<nul set /p "=!input!%\e%[48;2;;;m!framebuffer!"
)