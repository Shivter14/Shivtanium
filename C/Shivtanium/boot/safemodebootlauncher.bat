@echo off
cd "%~dp0.."
set sst.noguiboot=True
set sst.autorun="0 systemb-console"
call main.bat %*
