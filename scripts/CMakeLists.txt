set(SCRIPTS_TO_INSTALL ice-gdb)

if(TARGET_WINDOWS)
	# install batch file versions of scripts
	list(APPEND SCRIPTS_TO_INSTALL 
		win32/ice-gdb.bat
		win32/ice-insight.bat
		win32/kill-avarice.bat
		win32/start-avarice.bat)
else()

	# posix system, install shell scripts
	list(APPEND SCRIPTS_TO_INSTALL 
		posix/ice-insight
		posix/kill-avarice
		posix/start-avarice)
endif()

install(PROGRAMS ${SCRIPTS_TO_INSTALL} DESTINATION bin)

# install GDB init script
install(FILES gdb-avarice-script DESTINATION data)