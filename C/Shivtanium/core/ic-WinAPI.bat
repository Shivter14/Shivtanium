set "parameters=%~2"
for /f "tokens=1* delims=	" %%0 in ("!parameters!") do (
	if /I "%%~0"=="setTextInput" (
		if "!win[%~1.%%~1]!"=="" call Shivtanium.bat :haltIC "%~n0" %1 "Attempt to modify non-existent window" "Window ID: %%~1\nAction: setTextInput"
	) else set "pid[%~1]vreturn=Unknown command"
)
set parameters=