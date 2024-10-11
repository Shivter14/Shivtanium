@echo off & setlocal enabledelayedexpansion & chcp 65001 > nul & mode 100,10000
if not defined \e for /f %%a in ('echo prompt $E^| cmd') do set "\e=%%a"
<nul set /p "=%\e%[48;2;;;;38;2;15m%\e%[2J%\e%[H"
cd "%~dp0temp" || exit /b
(for /l %%# in () do (
	set /p io=&&echo(!io!
))<kernelErr 2<kernelPipe
