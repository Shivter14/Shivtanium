set "parameters=%~2"
for /f "tokens=1-6 delims=	" %%0 in ("!parameters!") do (
	if /I "%%~0"=="setTextInput" (
		if "!win[%~1.%%~1]!"=="" (
			call Shivtanium.bat :haltIC "%~n0" %1 "Attempt to modify non-existent window" "Window ID: %%~1\nAction: setTextInput"
			exit /b 1
		)
		if "!win[%~1.%%~1]txt[%%~2]!" neq "" (
			call Shivtanium.bat :haltIC "%~n0" %1 "Attempt to overwrite text input" "Window ID: %%~1\nAction: setTextInput\nText input variable: %%~2"
			exit /b 1
		)
		if "!win.focused!"=="%~1.%%~1" set "txtIn.focused=%~1.%%~1.%%~2"
		set temp.err=
		set "temp.x=%%~3"
		set "temp.y=%%~4"
		set "temp.w=%%~5"
		if not defined temp.x set temp.err=1
		if not defined temp.y set temp.err=1
		if not defined temp.w set temp.err=1
		set /a "temp.x=temp.x, temp.y=temp.y, temp.w=temp.w" 2>nul || set temp.err=1
		
		if defined temp.err (
			set temp.err=
			call Shivtanium.bat :haltIC "%~n0" %1 "Invalid object bounds" "Window ID: %%~1\nAction: setTextInput\nText input variable: %%~2\nX position: %%~3\nY position: %%~4\nWidth: %%~5"
			exit /b 1
		)
		set "win[%~1.%%~1]txt[%%~2]X=!temp.x!"
		set "win[%~1.%%~1]txt[%%~2]Y=!temp.y!"
		set "win[%~1.%%~1]txt[%%~2]W=!temp.w!"
		
		for /l %%y in (1 1 !win[%~1.%%~1]H!) do set "win[%~1.%%~1]o%%y="
		for %%b in (!win[%~1.%%~1]buttons!) do for /f "delims=" %%y in ("!win[%~1.%%~1]btn[%%~b]WY!") do (
			set "win[%~1.%%~1]o%%y=!win[%~1.%%~1]o%%y!%\e%[!win[%~1.%%~0]btn[%%~b]WX!C!win[%~1.%%~1]btn[%%~b]#:~0,%%~4!"
			echo=¤MW	%~1.%%~1	o%%y=!win[%~1.%%~1]o%%y!
		)
		for /f "tokens=1* delims=;" %%y in ("!win[%~1.%%~1]txt[%%~2]Y!;!win[%~1.%%~1]txt[%%~2]W!") do (
			set "temp= !pid[%~1]v%%~2!"
			set "win[%~1.%%~1]o%%y=!win[%~1.%%~1]o%%y!%\e%8%\e%[!win[%~1.%%~1]txt[%%~2]X!C%\e%[%%~zX!temp:~-%%~z!"
			set temp=
			echo=¤MW	%~1.%%~1	o%%y=!win[%~1.%%~1]o%%y!
		)
	) else set "pid[%~1]vreturn=Unknown command"
)
set parameters=
