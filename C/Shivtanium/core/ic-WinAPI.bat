set "parameters=%~2"
for /f "tokens=1-2* delims=	" %%0 in ("!parameters!") do (
	if /I "%%~0"=="setTextInput" (
		if "!win[%~1.%%~1]!"=="" (
			call Shivtanium.bat :haltIC "%~n0" %1 "Attempt to modify non-existent window" "Window ID: %%~1\nAction: setTextInput"
			exit /b 1
		)
		if "!win[%~1.%%~1]txt[%%~2]!" neq "" (
			call Shivtanium.bat :haltIC "%~n0" %1 "Attempt to overwrite text input" "Window ID: %%~1\nAction: setTextInput\nText input variable: %%~2"
			exit /b 1
		)
		if "!win.focused!"=="%~1.%%~1" set "txtIn.focused=%1.%%~2"
	) else set "pid[%~1]vreturn=Unknown command"
)
set parameters=
