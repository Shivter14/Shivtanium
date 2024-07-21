@echo off & setlocal enableDelayedExpansion
for /l %%# in () do (
	set "oldinput=!input!"
	set input=
	set /p "input="
	if defined input (
		echo=¤MW	%*!input:~0,%contentW%!
	) else if not defined oldinput exit 0
)
