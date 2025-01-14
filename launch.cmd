@echo off
cls
pushd %~dp0
powershell -nop -nol -ep remotesigned -f "./main.ps1"
pause
