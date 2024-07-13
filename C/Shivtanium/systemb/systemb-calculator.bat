@echo off & setlocal enableDelayedExpansion
set math="win[!PID!.calc]W=26, win[!PID!.calc]H=10, win[!PID!.calc]X=(sys.modeW-win[!PID!.calc]W)/2, win[!PID!.calc]Y=(sys.modeH-win[!PID!.calc]H)/2, inputW=win[!PID!.calc]W-4"
for %%b in (
	"times	3	12	4	:input times	 × "
	"divide	3	15	4	:input divide	 / "
	"clear	3	18	4	:clear	 C "
	"back	3	21	4	:back	 ← "
	"num1	3	12	5	:input 1	 1 "
	"num2	3	15	5	:input 2	 2 "
	"num3	3	18	5	:input 3	 3 "
	"add	3	21	5	:input add	 + "
	"num4	3	12	6	:input 4	 4 "
	"num5	3	15	6	:input 5	 5 "
	"num6	3	18	6	:input 6	 6 "
	"sub	3	21	6	:input sub	 - "
	"num7	3	12	7	:input 7	 7 "
	"num8	3	15	7	:input 8	 8 "
	"num9	3	18	7	:input 9	 9 "
	"perc	3	21	7	:input perc	 %% "
	"groupO	3	12	8	:input gro	 ( "
	"num0	3	15	8	:input 0	 0 "
	"groupC	3	18	8	:input grc	 ) "
	"equals	3	21	8	:calculate	 = "
	
	"turn	3	2	4	:input turn	 ± "
	"shiftl	3	5	4	:input shiftl	 « "
	"shiftr	3	8	4	:input shiftr	 » "
	"bitAnd	3	2	5	:input bitAnd	 & "
	"bitOr	3	5	5	:input bitOr	 | "
	"bitXor	3	8	5	:input bitXor	 ^^ "
	"close	3	win[!PID!.calc]W-3	0	:exit"
) do for /f "tokens=1-5* delims=	" %%0 in (%%b) do (
	set "buttons=!buttons!"%%~0" "
	set "button[%%~0]=%%4"
	set "button[%%~0]title=%%~5"
	set math=!math!, "button[%%~0]Y=%%~3, button[%%~0]X=%%~2, button[%%~0]W=%%~1, button[%%~0]BX=button[%%~0]X+button[%%~0]W-1"
)
set "input= "
set /a !math!
set math=
echo=¤CW	!PID!.calc	!win[%PID%.calc]X!	!win[%PID%.calc]Y!	!win[%PID%.calc]W!	!win[%PID%.calc]H!	Calculator
>>"!sst.dir!\temp\kernelPipe" echo=registerWindow	!PID!	!PID!.calc	!win[%PID%.calc]X!	!win[%PID%.calc]Y!	!win[%PID%.calc]W!	!win[%PID%.calc]H!


for %%b in (!buttons!) do for /f "delims=" %%y in ("!button[%%~b]Y!") do (
	set "win[!PID!.calc]o%%y=!win[%PID%.calc]o%%y!%\e%8%\e%[!button[%%~b]X!C!button[%%~b]title!"
)
echo=¤MW	!PID!.calc	o2=%\e%[2C%\e%[!inputW!X	o4=!win[%PID%.calc]o4!	o5=!win[%PID%.calc]o5!	o6=!win[%PID%.calc]o6!	o7=!win[%PID%.calc]o7!	o8=!win[%PID%.calc]o8!

set "char[shiftl]=<<"
set "char[shiftr]=>>"
set "char[add]=+"
set "char[sub]=-"
set "char[divide]=/"
set "char[times]=×"
set "char[perc]=%%"
set "char[gro]=("
set "char[grc]=)"
set "char[turn]=±"
set "char[bitAnd]=&"
set "char[bitOr]=|"
set "char[bitXor]=^"
set "char[exclmark]=‼"
for /f "tokens=2 delims==" %%a in ('set char[') do set "char[%%~a]=%%~a"
set "char[☼]=×"
set "char[<]=<<"
set "char[>]=>>"
set "char[ˆ]=^"
for /l %%c in (0 1 9) do set "char[%%c]=%%c"


set pipe=
for /l %%# in () do (
	set kernelOut=
	set /p "kernelOut="
	if defined kernelOut if "!kernelOut!"=="click=1" (
		if "!focusedWindow!"=="!PID!.calc" (
			set /a "relativeMouseX=mouseXpos-win[!PID!.calc]X, relativeMouseY=mouseYpos-win[!PID!.calc]Y"
			for %%b in (!buttons!) do for /f %%y in ("!button[%%~b]Y!") do (
				if "!relativeMouseY!"=="!button[%%~b]Y!" if !relativeMouseX! geq !button[%%~b]X! if !relativeMouseX! leq !button[%%~b]BX! (
					echo=¤MW	!PID!.calc	o%%y=!win[%PID%.calc]o%%y!%\e%8%\e%[!button[%%~b]X!C%\e%[7m!button[%%~b]title!%\e%[27m
					call !button[%%~b]!
				)
			)
		)
	) else if "!kernelOut!"=="click=0" (
		if "!focusedWindow!"=="!PID!.calc" (
			echo=¤MW	!PID!.calc	o4=!win[%PID%.calc]o4!	o5=!win[%PID%.calc]o5!	o6=!win[%PID%.calc]o6!	o7=!win[%PID%.calc]o7!	o8=!win[%PID%.calc]o8!
		)
	) else if "!kernelOut!"=="exit" (
		exit 0
	) else if "!kernelOut!"=="exitProcess=!PID!" (
		exit 0
	) else if "!kernelOut:~0,14!"=="keysPressedRN=" (
		set "!kernelOut!" > nul 2>&1
		if "!focusedWindow!"=="!PID!.calc" for %%k in (!keysPressedRN!) do (
			set "char=!charset_L:~%%k,1!"
			if "!keysPressed!" neq "!keysPressed:-16-=!" set "char=!charset_U:~%%k,1!"
			if "!keysPressed!" neq "!keysPressed:-17-=!" set "char=!charset_A:~%%k,1!"
			if "!char!"==" " (
				if "%%~k" neq "32" set char=
				if "%%~k"=="8" (
					if "!input!" neq " " set "input=!input:~0,-1!"
					echo=¤MW	!PID!.calc	o2=%\e%[2C%\e%[!inputW!X!input:~-%inputW%!
				) else if "%%~k"=="13" (
					call :calculate
				) else if "%%~k"=="27" (
					set "input= "
					echo=¤MW	!PID!.calc	o2=%\e%[2C%\e%[!inputW!X!input:~-%inputW%!
				)
			)
			if defined char call :input "!char!"
		)
	) else set "!kernelOut!" > nul 2>&1
)
:input
set "input=!input!!char[%~1]!"
echo=¤MW	!PID!.calc	o2=%\e%[2C%\e%[!inputW!X!input:~-%inputW%!
exit /b 0
:clear
set "input= "
echo=¤MW	!PID!.calc	o2=%\e%[2C%\e%[!inputW!X
exit /b 0
:back
if "!input!" neq " " set "input=!input:~0,-1!"
echo=¤MW	!PID!.calc	o2=%\e%[2C%\e%[!inputW!X!input!
exit /b 0
:calculate
set "math=!input!"
set "math=!math:×=*!"
set "math=!math:±=*-1 !"

for /f "delims=." %%a in ('set /a "%math%" 2^>^&1') do (
	set "input=%%~a"
	set /a input=input
	if "!input!"=="0" set input=
	set "input= !input!"
	echo=¤MW	!PID!.calc	o2=%\e%[2C%\e%[!inputW!X %%~a
)
exit /b 0
:exit
>>"!sst.dir!\temp\kernelPipe" echo=exitProcess	!PID!
exit 0
