@echo off
for /f "tokens=1 delims==" %%a in ('set pid[ 2^>nul ^& set win[ 2^>nul') do set "%%a="
for /l %%a in (1 1 %ioTotal%) do set /p "="
call %*
set /a PID=PID
>>"%~dp0temp\kernelPipe" (
	echo=exitProcessTree	%PID%
	echo=exitProcess	%PID%
)
