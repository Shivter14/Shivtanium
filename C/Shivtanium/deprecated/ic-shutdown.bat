set /a "x=(sys.modeW-48)/2, y=(sys.modeH-5)/2"
for %%a in (!windows!) do echo=¤DW	%%a
echo=¤OV
echo=¤CW	sys.shutdown	!x!	!y!	48	5	System Shutdown
echo=¤MW	sys.shutdown	l2=  Shivtanium is shutting down. . .
echo=¤CTRL	ORDER	sys.shutdown
echo=¤EXIT
rem if exist "!asset[\sounds\shutdown.mp3]!" start /b cscript.exe //b core\playsound.vbs "!asset[\sounds\shutdown.mp3]!"
title Shivtanium !sys.tag! !sys.ver! !sys.subvinfo! ^| Shutting down. . .
exit 0
