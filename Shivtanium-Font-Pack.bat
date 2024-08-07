@echo off & setlocal enableDelayedExpansion
rem Shivtanium Font Pack revision 2. Font hand made by Shivter, Rendering system originates from Icarus.
mode 144,28
chcp 65001>nul
for /f %%a in ('echo prompt $E^| cmd') do set "\e=%%a"
echo(%\e%[H%\e%[48;2;0;0;0;38;5;231m%\e%[2J[%time%] Loading font/VGA/Shivtanium-Simple...
call :font/VGA/Shivtanium-Simple

echo([!time!] Creating sprite...
set "string=Font Shivtanium-Simple"

set "str=x!string!"
set length=0
for /l %%b in (8,-1,0) do (
	set /a "length|=1<<%%b"
	for %%c in (!length!) do if "!str:~%%c,1!" equ "" set /a "length&=~1<<%%b"
)
set /a length-=1
for /l %%i in (0,1,!length!) do (
	set "add=!string:~%%~i,1!"
	for %%c in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do if "!add!"=="%%~c" set "add=#%%~c"
	set "return=!return!"!add!" "
)
set icon=
for %%i in (!return!) do set "icon=!icon!![%%~i]! "

echo=[!time!] Finished.[4;8H!icon!
pause >nul
exit /b 0

:font/VGA/Shivtanium-Simple
for %%a in (
	"[#A]= ▄▄%\e%[B%\e%[3D█  █%\e%[B%\e%[4D█▄▄█%\e%[B%\e%[4D█  █%\e%[3A"
	"[#B]=▄▄▄%\e%[B%\e%[3D█  █%\e%[B%\e%[4D█▀▀▄%\e%[B%\e%[4D█▄▄▀%\e%[3A"
	"[#C]= ▄▄%\e%[B%\e%[3D█  ▀%\e%[B%\e%[4D█%\e%[B%\e%[D▀▄▄▀%\e%[3A"
	"[#D]=▄▄▄%\e%[B%\e%[3D█  █%\e%[B%\e%[4D█  █%\e%[B%\e%[4D█▄▄▀%\e%[3A"
	"[#E]=▄▄▄▄%\e%[B%\e%[4D█%\e%[B%\e%[D█▀▀▀%\e%[B%\e%[4D█▄▄▄%\e%[3A"
	"[#F]=▄▄▄▄%\e%[B%\e%[4D█%\e%[B%\e%[D█▀▀▀%\e%[B%\e%[4D█   %\e%[3A"
	"[#G]= ▄▄%\e%[B%\e%[3D█  ▀%\e%[B%\e%[4D█ ▄▄%\e%[B%\e%[4D▀▄▄█%\e%[3A"
	"[#H]=▄  ▄%\e%[B%\e%[4D█  █%\e%[B%\e%[4D█▀▀█%\e%[B%\e%[4D█  █%\e%[3A"
	"[#I]=▄▄▄%\e%[B%\e%[2D█%\e%[D█%\e%[B%\e%[D█%\e%[B%\e%[2D▄█▄%\e%[3A"
	"[#J]=▄▄▄▄%\e%[B%\e%[D█%\e%[D█%\e%[B%\e%[D█%\e%[B%\e%[4D▀▄▄▀%\e%[3A"
	"[#K]=▄  ▄%\e%[B%\e%[4D█ ▄▀%\e%[B%\e%[4D█▀▄%\e%[B%\e%[3D█  █%\e%[3A"
	"[#L]=▄%\e%[B%\e%[D█%\e%[B%\e%[D█%\e%[B%\e%[D█▄▄▄%\e%[3A"
	"[#M]=▄   ▄%\e%[B%\e%[5D██▄██%\e%[B%\e%[5D█ ▀ █%\e%[B%\e%[5D█   █%\e%[3A"
	"[#N]=▄  ▄%\e%[B%\e%[4D██▄█%\e%[B%\e%[4D█ ▀█%\e%[B%\e%[4D█  █%\e%[3A"
	"[#O]= ▄▄%\e%[B%\e%[3D█  █%\e%[B%\e%[4D█  █%\e%[B%\e%[4D▀▄▄▀%\e%[3A"
	"[#P]=▄▄▄%\e%[B%\e%[3D█  █%\e%[B%\e%[4D█▀▀%\e%[B%\e%[3D█   %\e%[3A"
	"[#Q]= ▄▄%\e%[B%\e%[3D█  █%\e%[B%\e%[4D█  █%\e%[B%\e%[4D▀▄██%\e%[3A"
	"[#R]=▄▄▄%\e%[B%\e%[3D█  █%\e%[B%\e%[4D█▀▀▄%\e%[B%\e%[4D█  █%\e%[3A"
	"[#S]= ▄▄▄%\e%[B%\e%[4D█%\e%[B▀▀▄%\e%[B%\e%[4D▄▄▄▀%\e%[3A"
	"[#T]=▄▄▄▄▄%\e%[B%\e%[3D█%\e%[B%\e%[D█%\e%[B%\e%[D█  %\e%[3A"
	"[#U]=▄  ▄%\e%[B%\e%[4D█  █%\e%[B%\e%[4D█  █%\e%[B%\e%[4D▀▄▄▀%\e%[3A"
	"[#V]=▄   ▄%\e%[B%\e%[5D█   █%\e%[B%\e%[5D▀▄ ▄▀%\e%[B%\e%[5D ▀▄▀ %\e%[3A"
	"[#W]=▄   ▄%\e%[B%\e%[5D█ █ █%\e%[B%\e%[5D█ █ █%\e%[B%\e%[5D▀█▀█▀%\e%[3A"
	"[#X]=▄   ▄%\e%[B%\e%[5D▀▄ ▄▀%\e%[B%\e%[4D▄▀▄%\e%[B%\e%[4D█   █%\e%[3A"
	"[#Y]=▄   ▄%\e%[B%\e%[5D█   █%\e%[B%\e%[4D▀▄▀%\e%[B%\e%[2D█  %\e%[3A"
	"[#Z]=▄▄▄▄▄%\e%[B%\e%[2D▄▀%\e%[B%\e%[4D▄▀%\e%[B%\e%[3D█▄▄▄▄%\e%[3A"
	"[a]=%\e%[2B▄▀▀▄%\e%[B%\e%[4D▀▄▄█%\e%[3A"
	"[b]=▄%\e%[B%\e%[D█%\e%[B%\e%[D█▀▀▄%\e%[B%\e%[4D█▄▄▀%\e%[3A"
	"[c]=%\e%[2B▄▀▀%\e%[B%\e%[3D▀▄▄%\e%[3A"
	"[d]=   ▄%\e%[B%\e%[D█%\e%[B%\e%[4D▄▀▀█%\e%[B%\e%[4D▀▄▄█%\e%[3A"
	"[e]=%\e%[2B▄██▄%\e%[B%\e%[4D▀█▄ %\e%[3A"
	"[f]= ▄▄%\e%[B%\e%[3D▄█▄%\e%[B%\e%[2D█%\e%[B%\e%[D█ %\e%[3A"
	"[g]=%\e%[2B▄▀▀▄%\e%[B%\e%[4D▀▄▄█%\e%[B%\e%[3D▄▄▀%\e%[4A"
	"[h]=▄%\e%[B%\e%[D█%\e%[B%\e%[D█▀▀▄%\e%[B%\e%[4D█  █%\e%[3A"
	"[i]=▄%\e%[2B%\e%[D█%\e%[B%\e%[D█%\e%[3A"
	"[j]=  ▄%\e%[2B%\e%[D█%\e%[B%\e%[D█%\e%[B%\e%[3D▀▄▀%\e%[4A"
	"[k]=▄%\e%[B%\e%[D█  ▄%\e%[B%\e%[4D█▄▀%\e%[B%\e%[3D█ ▀▄%\e%[3A"
	"[l]=▄%\e%[B%\e%[D█%\e%[B%\e%[D█%\e%[B%\e%[D▀▄%\e%[3A"
	"[m]=%\e%[2B█▀▄▀▄%\e%[B%\e%[5D█ █ █%\e%[3A"
	"[n]=%\e%[2B█▀▀▄%\e%[B%\e%[4D█  █%\e%[3A"
	"[o]=%\e%[2B▄▀▀▄%\e%[B%\e%[4D▀▄▄▀%\e%[3A"
	"[p]=%\e%[2B█▀▀▄%\e%[B%\e%[4D█▄▄▀%\e%[B%\e%[4D█   %\e%[4A"
	"[q]=%\e%[2B▄▀▀█%\e%[B%\e%[4D▀▄▄█%\e%[B%\e%[4D   █%\e%[4A"
	"[r]=%\e%[2B█▀▀▄%\e%[B%\e%[4D█   %\e%[3A"
	"[s]=%\e%[2B▄█▀%\e%[B%\e%[3D▄█▀%\e%[3A"
	"[t]= ▄%\e%[B%\e%[2D▄█▄%\e%[B%\e%[2D█%\e%[B%\e%[D▀▄%\e%[3A"
	"[u]=%\e%[2B█  █%\e%[B%\e%[4D▀▄▄█%\e%[3A"
	"[v]=%\e%[2B█ █%\e%[B%\e%[3D▀█▀%\e%[3A"
	"[w]=%\e%[2B█ █ █%\e%[B%\e%[5D▀▄▀▄▀%\e%[3A"
	"[x]=%\e%[2B▀▄▀%\e%[B%\e%[3D█ █%\e%[3A"
	"[y]=%\e%[2B█  █%\e%[B%\e%[4D▀▄▄█%\e%[B%\e%[3D▄▄▀%\e%[4A"
	"[z]=%\e%[2B▀▀█▀%\e%[B%\e%[4D▄█▄▄%\e%[3A"
	"[ ]=%\e%[4C"
	"[,]=%\e%[3B▄%\e%[B%\e%[2D▀ %\e%[4A"
	"[.]=%\e%[3B▄%\e%[4A"
	"[-]=%\e%[2B▄▄▄▄%\e%[2A"
	"[^!]= ▄%\e%[B%\e%[2D▐█▌%\e%[B%\e%[2D█%\e%[B%\e%[D▄"
	"[0]= ▄▄%\e%[B%\e%[3D█ ▄█%\e%[B%\e%[4D██▀█%\e%[B%\e%[4D▀▄▄▀%\e%[3A"
	"[1]=  ▄%\e%[B%\e%[2D▀█%\e%[B%\e%[D█%\e%[B%\e%[2D▄█▄%\e%[3A"
	"[2]= ▄▄%\e%[B%\e%[3D▀  █%\e%[B%\e%[3D▄▀%\e%[B%\e%[3D█▄▄█%\e%[3A"
	"[3]= ▄▄%\e%[B%\e%[3D▀  █%\e%[B%\e%[3D▀▀▄%\e%[B%\e%[4D▀▄▄▀%\e%[3A"
	"[4]=   ▄%\e%[B%\e%[3D▄▀█%\e%[B%\e%[4D█▄▄█%\e%[B%\e%[D█%\e%[3A"
	"[5]=▄▄▄▄%\e%[B%\e%[4D█▄▄%\e%[B█%\e%[B%\e%[4D▀▄▄▀%\e%[3A"
	"[6]= ▄▄%\e%[B%\e%[3D█  ▀%\e%[B%\e%[4D█▀▀▄%\e%[B%\e%[4D▀▄▄▀%\e%[3A"
	"[7]=▄▄▄▄%\e%[B%\e%[D█%\e%[B%\e%[3D▄▀%\e%[B%\e%[2D█  %\e%[3A"
	"[8]= ▄▄%\e%[B%\e%[3D█  █%\e%[B%\e%[4D▄▀▀▄%\e%[B%\e%[4D▀▄▄▀%\e%[3A"
	"[9]= ▄▄%\e%[B%\e%[3D█  █%\e%[B%\e%[3D▀▀█%\e%[B%\e%[4D▀▄▄▀%\e%[3A"
) do set "%%~a"
exit /b 0

:font/VGA/Shivtanium-Phenomenal
for %%a in (
	"[#A]= ▄▄%\e%[B%\e%[3D█  █%\e%[B%\e%[4D█▄▄█%\e%[B%\e%[4D█  █%\e%[B%\e%[D▀%\e%[4A"
	"[#B]=▄▄▄%\e%[B%\e%[3D█  █%\e%[B%\e%[4D█▀▀▄%\e%[B%\e%[4D█▄▄▀%\e%[3A"
	"[#C]= ▄▄%\e%[B%\e%[3D█  ▀%\e%[B%\e%[4D█%\e%[B%\e%[D▀▄▄▀%\e%[3A"
	"[#D]=▄▄▄%\e%[B%\e%[3D█  █%\e%[B%\e%[4D█  █%\e%[B%\e%[4D█▄▄▀%\e%[B%\e%[4D▀   %\e%[4A"
	"[#E]=▄▄▄▄%\e%[B%\e%[4D█%\e%[B%\e%[D█▀▀▀%\e%[B%\e%[4D█▄▄▄%\e%[B%\e%[4D   ▀%\e%[4A"
	"[#F]=▄▄▄▄%\e%[B%\e%[4D█%\e%[B%\e%[D█▀▀▀%\e%[B%\e%[4D█%\e%[B%\e%[D▀   %\e%[4A"
	"[#G]= ▄▄%\e%[B%\e%[3D█  ▀%\e%[B%\e%[4D█ ▄▄%\e%[B%\e%[4D▀▄▄█%\e%[B%\e%[D▀%\e%[4A"
	"[#H]=▄  ▄%\e%[B%\e%[4D█  █%\e%[B%\e%[4D█▀▀█%\e%[B%\e%[4D█  █%\e%[B%\e%[D▀%\e%[4A"
	"[#I]=▄▄▄%\e%[B%\e%[2D█%\e%[D█%\e%[B%\e%[D█%\e%[B%\e%[D█%\e%[B%\e%[2D▀▀▀%\e%[4A"
	"[#J]=▄▄▄▄%\e%[B%\e%[D█%\e%[D█%\e%[B%\e%[D█%\e%[B%\e%[4D▄  █%\e%[B%\e%[3D▀▀ %\e%[4A"
	"[#K]=▄  ▄%\e%[B%\e%[4D█ ▄▀%\e%[B%\e%[4D█▀▄%\e%[B%\e%[3D█  █%\e%[B%\e%[4D▀   %\e%[4A"
	"[#L]=▄%\e%[B%\e%[D█%\e%[B%\e%[D█%\e%[B%\e%[D█▄▄▄%\e%[3A"
	"[#M]=▄   ▄%\e%[B%\e%[5D██▄██%\e%[B%\e%[5D█ ▀ █%\e%[B%\e%[5D█   █%\e%[B%\e%[5D▀%\e%[4C%\e%[4A"
	"[#N]=▄  ▄%\e%[B%\e%[4D██▄█%\e%[B%\e%[4D█ ▀█%\e%[B%\e%[4D█  █%\e%[3A"
	"[#O]= ▄▄%\e%[B%\e%[3D█  █%\e%[B%\e%[4D█  █%\e%[B%\e%[4D▀▄▄▀%\e%[3A"
	"[#P]=▄▄▄%\e%[B%\e%[3D█  █%\e%[B%\e%[4D█▀▀%\e%[B%\e%[3D█%\e%[B%\e%[D▀   %\e%[4A"
	"[#Q]= ▄▄%\e%[B%\e%[3D█  █%\e%[B%\e%[4D█  █%\e%[B%\e%[4D▀▄██%\e%[3A"
	"[#R]=▄▄▄%\e%[B%\e%[3D█  █%\e%[B%\e%[4D█▀▀▄%\e%[B%\e%[4D█  █%\e%[B%\e%[4D   ▀%\e%[4A"
	"[#S]= ▄▄▄%\e%[B%\e%[4D█%\e%[B▀▀▄%\e%[B%\e%[4D▄▄▄▀%\e%[3A"
	"[#T]=▄▄▄▄▄%\e%[B%\e%[3D█%\e%[B%\e%[D█%\e%[B%\e%[D█  %\e%[3A"
	"[#U]=▄  ▄%\e%[B%\e%[4D█  █%\e%[B%\e%[4D█  █%\e%[B%\e%[4D▀▄▄▀%\e%[3A"
	"[#V]=▄   ▄%\e%[B%\e%[5D█   █%\e%[B%\e%[5D▀▄ ▄▀%\e%[B%\e%[5D ▀▄▀%\e%[B%\e%[2D▀  %\e%[4A"
	"[#W]=▄   ▄%\e%[B%\e%[5D█ █ █%\e%[B%\e%[5D█ █ █%\e%[B%\e%[5D▀█▀█▀%\e%[3A"
	"[#X]=▄   ▄%\e%[B%\e%[5D▀▄ ▄▀%\e%[B%\e%[4D▄▀▄%\e%[B%\e%[4D█   █%\e%[B%\e%[D▀%\e%[4A"
	"[#Y]=▄   ▄%\e%[B%\e%[5D█   █%\e%[B%\e%[4D▀▄▀%\e%[B%\e%[2D█%\e%[B%\e%[D▀  %\e%[4A"
	"[#Z]=▄▄▄▄▄%\e%[B%\e%[2D▄▀%\e%[B%\e%[4D▄▀%\e%[B%\e%[3D█▄▄▄▄%\e%[3A"
	"[a]=%\e%[2B▄▀▀▄%\e%[B%\e%[4D▀▄▄█%\e%[3A"
	"[b]=▄%\e%[B%\e%[D█%\e%[B%\e%[D█▀▀▄%\e%[B%\e%[4D█▄▄▀%\e%[3A"
	"[c]=%\e%[2B▄▀▀%\e%[B%\e%[3D▀▄▄%\e%[3A"
	"[d]=   ▄%\e%[B%\e%[D█%\e%[B%\e%[4D▄▀▀█%\e%[B%\e%[4D▀▄▄█%\e%[3A"
	"[e]=%\e%[2B▄██▄%\e%[B%\e%[4D▀█▄ %\e%[3A"
	"[f]= ▄▄%\e%[B%\e%[3D▄█▄%\e%[B%\e%[2D█%\e%[B%\e%[D█%\e%[B%\e%[D▀ %\e%[4A"
	"[g]=%\e%[2B▄▀▀▄%\e%[B%\e%[4D▀▄▄█%\e%[B%\e%[3D▄▄▀%\e%[4A"
	"[h]=▄%\e%[B%\e%[D█%\e%[B%\e%[D█▀▀▄%\e%[B%\e%[4D█  █%\e%[B%\e%[D▀%\e%[4A"
	"[i]=▄%\e%[2B%\e%[D█%\e%[B%\e%[D█%\e%[3A"
	"[j]=  ▄%\e%[2B%\e%[D█%\e%[B%\e%[D█%\e%[B%\e%[3D▀▄▀%\e%[4A"
	"[k]=▄%\e%[B%\e%[D█  ▄%\e%[B%\e%[4D█▄▀%\e%[B%\e%[3D█ ▀▄%\e%[B%\e%[D▀%\e%[4A"
	"[l]=▄%\e%[B%\e%[D█%\e%[B%\e%[D█%\e%[B%\e%[D█%\e%[B▀%\e%[4A"
	"[m]=%\e%[2B█▀▄▀▄%\e%[B%\e%[5D█ █ █%\e%[B%\e%[5D▀    %\e%[4A"
	"[n]=%\e%[2B█▀▀▄%\e%[B%\e%[4D█  █%\e%[B%\e%[D▀%\e%[4A"
	"[o]=%\e%[2B▄▀▀▄%\e%[B%\e%[4D▀▄▄▀%\e%[3A"
	"[p]=%\e%[2B█▀▀▄%\e%[B%\e%[4D█▄▄▀%\e%[B%\e%[4D█   %\e%[4A"
	"[q]=%\e%[2B▄▀▀█%\e%[B%\e%[4D▀▄▄█%\e%[B%\e%[4D   █%\e%[4A"
	"[r]=%\e%[2B█▀▀▄%\e%[B%\e%[4D█   %\e%[3A"
	"[s]=%\e%[2B▄▀▀%\e%[B%\e%[3D ▀▄%\e%[B%\e%[3D▀▀ %\e%[4A"
	"[t]= ▄%\e%[B%\e%[2D▄█▄%\e%[B%\e%[2D█%\e%[B%\e%[D█%\e%[B▀%\e%[4A"
	"[u]=%\e%[2B█  █%\e%[B%\e%[4D▀▄▄█%\e%[3A"
	"[v]=%\e%[2B█ █%\e%[B%\e%[3D▀█▀%\e%[3A"
	"[w]=%\e%[2B█ █ █%\e%[B%\e%[5D▀▄▀▄▀%\e%[3A"
	"[x]=%\e%[2B▀▄▀%\e%[B%\e%[3D█ █%\e%[3A"
	"[y]=%\e%[2B█  █%\e%[B%\e%[4D▀▄▄█%\e%[B%\e%[3D▄▄▀%\e%[4A"
	"[z]=%\e%[2B▀▀█▀%\e%[B%\e%[4D▄█▄▄%\e%[B%\e%[D▀"
	"[ ]=%\e%[4C"
	"[,]=%\e%[3B▄%\e%[B%\e%[2D▀ %\e%[4A"
	"[.]=%\e%[3B▄%\e%[4A"
	"[-]=%\e%[2B▄▄▄▄%\e%[2A"
	"[^!]= ▄%\e%[B%\e%[2D▐█▌%\e%[B%\e%[2D█%\e%[B%\e%[D▄"
	"[0]= ▄▄%\e%[B%\e%[3D█ ▄█%\e%[B%\e%[4D██▀█%\e%[B%\e%[4D▀▄▄▀%\e%[3A"
	"[1]=  ▄%\e%[B%\e%[2D▀█%\e%[B%\e%[D█%\e%[B%\e%[2D▄█▄%\e%[3A"
	"[2]= ▄▄%\e%[B%\e%[3D▀  █%\e%[B%\e%[3D▄▀%\e%[B%\e%[3D█▄▄█%\e%[3A"
	"[3]= ▄▄%\e%[B%\e%[3D▀  █%\e%[B%\e%[3D▀▀▄%\e%[B%\e%[4D▀▄▄▀%\e%[3A"
	"[4]=   ▄%\e%[B%\e%[3D▄▀█%\e%[B%\e%[4D█▄▄█%\e%[B%\e%[D█%\e%[3A"
	"[5]=▄▄▄▄%\e%[B%\e%[4D█▄▄%\e%[B█%\e%[B%\e%[4D▀▄▄▀%\e%[3A"
	"[6]= ▄▄%\e%[B%\e%[3D█  ▀%\e%[B%\e%[4D█▀▀▄%\e%[B%\e%[4D▀▄▄▀%\e%[3A"
	"[7]=▄▄▄▄%\e%[B%\e%[D█%\e%[B%\e%[3D▄▀%\e%[B%\e%[2D█  %\e%[3A"
	"[8]= ▄▄%\e%[B%\e%[3D█  █%\e%[B%\e%[4D▄▀▀▄%\e%[B%\e%[4D▀▄▄▀%\e%[3A"
	"[9]= ▄▄%\e%[B%\e%[3D█  █%\e%[B%\e%[3D▀▀█%\e%[B%\e%[4D▀▄▄▀%\e%[3A"
) do set "%%~a"
