if exist "!asset[\sounds\shutdown.mp3]!" start /b cscript.exe //b core\playsound.vbs "!asset[\sounds\shutdown.mp3]!"
for %%a in (!windows!) do echo(¤DW	%%a
rem echo(¤OV	%\e%[H%\e%[48;2;;;;38;2;255;255;255m%\e%[2JSystem is shutting down. . .
set /a "x=(sys.modeW-48)/2, y=(sys.modeH-5)/2"
echo(¤CW	sys.shutdown	!x!	!y!	48	5	System Shutdown
echo(¤MW	sys.shutdown	l2=  Shivtanium is shutting down. . .
echo(¤EXIT
exit 27