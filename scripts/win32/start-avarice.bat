@echo off
rem Script to start avarice in the background on port 6423.
rem If passed arguments, it will pass them to avarice, otherwise it will
rem use the default arguments, --erase -f

call kill-avarice

if [%1] == [] (
	set "avarice_args=--erase -f" 
) else (
	set "avarice_args=%*"
)

avarice %avarice_args% --detach :6423