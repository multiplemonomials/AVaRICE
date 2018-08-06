# Main source buildfile

set(AVARICE_SOURCES 
	avarice.h	
	crc16.h		
	crc16.c		
	devdescr.cc	
	ioreg.cc	
	ioreg.h		
	jtag.h		
	jtag1.h		
	jtag2.h		
	jtag3.h		
	jtag2bp.cc	
	jtag2io.cc	
	jtag2misc.cc	
	jtag2prog.cc	
	jtag2run.cc	
	jtag2rw.cc	
	jtag2_defs.h	
	jtag2usb.cc	
	jtag3bp.cc	
	jtag3io.cc	
	jtag3misc.cc	
	jtag3prog.cc	
	jtag3run.cc	
	jtag3rw.cc	
	jtagbp.cc	
	jtaggeneric.cc	
	jtagio.cc	
	jtagmisc.cc	
	jtagprog.cc	
	jtagrun.cc	
	jtagrw.cc	
	main.cc		
	pragma.h	
	remote.cc	
	remote.h	
	utils.cc        
	gnu_getopt.c    
	gnu_getopt.h    
	gnu_getopt1.c)

# add executable
add_executable(avarice ${AVARICE_SOURCES})
target_link_libraries(avarice Threads::Threads)
target_include_directories(avarice PRIVATE ${CMAKE_CURRENT_BINARY_DIR})

# link optional libraries
if(USB_FOUND)
	target_link_libraries(avarice usb)
endif()

if(HIDAPI_FOUND)
	target_link_libraries(avarice hidapi)
endif()

if(BFD_FOUND)
	target_link_libraries(avarice bfd)
endif()

install(TARGETS avarice DESTINATION bin)