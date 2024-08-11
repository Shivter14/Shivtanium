@echo off & setlocal enableDelayedExpansion
if not defined subRoutine (
	echo=BXF - Batch Expanded Functions ^| version 1.0.0
	echo=Compiling started at !time!
)
if not exist "%~f1" (
	echo=File not found: %1
	exit /b 9009
)
if exist "%~dpn1.bat" (
	echo=File already exists: "%~dpn1.bat"
	exit /b 32
)
pushd "%~dp1"
call :main "%~f1" < "%~f1" > "%~dpn1.bat"
popd
if "!subRoutineN!;!errorlevel!"=="1;0" (
	echo=Compiling finished at !time!
)
exit /b
:main
set /a subRoutineN+=1
set "routine[!subRoutineN!]=%~f1"
set cl=0
:main.loop
for /l %%# in (1 1 100) do for /l %%# in (1 1 100) do (
	set /a cl+=1
	set line=
	set /p line= || (
		set /a eof+=1
		if !eof! gtr 100 exit /b 0
	)
	if "!line:~0,1!"=="#" (
		if "!line:~1,9!"=="function " (
			if defined currentFunction (
				call :error Syntax error: Can't put a function into a function. Possibly missing a '#end'?
				exit /b 2
			)
			
			for /f "delims=*^!=" %%a in ("!line:~10!") do (
				if defined f@%%a (
					call :error Syntax error: Can't re-define a function.
					exit /b 3
				)
				set "f@!prefix!%%a=!cl!"
				set "f\!prefix!%%a=%~f1"
				set "currentFunction=!prefix!%%a"
			)
		) else if "!line:~1,7!"=="import " (
			set "import=!line:~8!"
			set import=!import:, =" "!
			for %%i in ("!import!") do for /f "tokens=1,2* delims=*^!	 " %%A in ("%%~i") do (
				set "importAs=%%~nA"
				set "importFrom=%%~fA"
				if "%%B"=="as" set "importAs=%%C"
				if not defined importAs (
					call :error Import error at line !cl!: "#import %%A as" Expected name.
					exit /b 6
				)
				if not exist "!importFrom!" (
					call :error Import error at line !cl!: File not found: %%A
					exit /b 7
				)
				set "i@!importFrom!=!importAs!"
				if defined prefix set "prefix=!prefix:"=!"
				for /f "tokens=1* delims=." %%O in ("#.!prefix!") do (
					set "prefix=!importAs!."
					call :main "!importFrom!" < "!importFrom!" || exit /b
					set "routine[!subRoutineN!]="
					set /a subRoutineN-=1
					set "prefix=%%P"
				)
			)
		) else if "!line!"=="#end" (
			if not defined currentFunction (
				call :error Syntax error: Unexpected #end at line !cl!.
				exit /b 1
			)
			
			set "f#!currentFunction!=!cl!"
			set currentFunction=
		)
	) else if defined line (
		set eof=0
		if "!line!" neq "!line:@=!" (
			for /f "tokens=1* delims=*^!	 " %%a in ("!line!") do if defined f%%a (
				set "expandFunction=%%a"
				set "args=%%b"
				call :expandFunction || exit /b
			) else if not defined currentFunction echo(!line!
		) else if not defined currentFunction echo(!line!
	)
)
goto main.loop
:expandFunction
if not defined f@!expandFunction:~1! (
	call :error "Undefined function: !expandFunction!"
	exit /b 4
)
for /f "delims=" %%f in ("!expandFunction:~1!") do (
	for /l %%# in (1 1 !f@%%f!) do set /p "="
	set /a "fcl=!f@%%f!+2"
	for /l %%# in (!fcl! 1 !f#%%f!) do (
		set /p "fcl="
		echo(!fcl!
	)
) < "!f\%%f!"
exit /b 0
:error
echo=[38;5;1mStack trace (!subRoutineN!):
for /l %%a in (1 1 !subRoutineN!) do echo=At !routine[%%a]!
echo=  %*[0m
exit /b
