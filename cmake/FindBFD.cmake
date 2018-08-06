# CMake find module for libbfd
# Written by Jamie Smith, with information from AVaRICE's autoconf script.

# variables:
# BFD_FOUND - whether or not libbfd was found
# BFD_LIBRARIES - list of libraries required to use bfd
# BFD_INCLUDE_DIRS - directories containing include files for libbfd

# imported targets:
# bfd - bfd library

# first, find bfd itself
#------------------------------------------------------------------------
find_library(BFD_LIBRARY
	NAMES bfd
	DOC "Path to libbfd, the binary file descriptor library")
	
find_path(BFD_INCLUDE_DIR
	NAMES bfd.h)
	
if(EXISTS "${BFD_LIBRARY}" AND EXISTS "${BFD_INCLUDE_DIR}")
	set(HAVE_BFD_LIB TRUE)
else()
	set(HAVE_BFD_LIB FALSE)
endif()

# now, find dependencies
#------------------------------------------------------------------------
set(BFD_LIBRARIES ${BFD_LIBRARY})
set(BFD_INCLUDE_DIRS ${BFD_INCLUDE_DIR})
set(BFD_REQUIRED_VARS BFD_LIBRARY BFD_INCLUDE_DIR)

if(HAVE_BFD_LIB)
	cmake_push_check_state()
	set(CMAKE_REQUIRED_LIBRARIES ${BFD_LIBRARY})
	set(CMAKE_REQUIRED_INCLUDES ${BFD_INCLUDE_DIR})
	
	# BFD can require libiberty
	find_library(IBERTY_LIBRARY NAMES iberty_pic iberty DOC "Path to iberty, the GNU utils library")
		
	list(APPEND BFD_REQUIRED_VARS IBERTY_LIBRARY)

	if(EXISTS IBERTY_LIBRARY)
		list(APPEND BFD_LIBRARIES ${IBERTY_LIBRARY})
		list(APPEND CMAKE_REQUIRED_LIBRARIES ${IBERTY_LIBRARY})
	endif()
	
	# BFD can require iconv and intl
	find_dependency(Iconv)
	list(APPEND BFD_REQUIRED_VARS Iconv_FOUND)
		
	if(Iconv_FOUND)
		list(APPEND BFD_LIBRARIES ${Iconv_LIBRARIES})
		list(APPEND BFD_INCLUDE_DIRS ${Iconv_INCLUDE_DIRS})
		list(APPEND CMAKE_REQUIRED_LIBRARIES ${Iconv_LIBRARIES})
		list(APPEND CMAKE_REQUIRED_INCLUDES ${Iconv_INCLUDE_DIRS})
	endif()
	
	find_dependency(Intl)
	list(APPEND BFD_REQUIRED_VARS Intl_FOUND)
	
	if(Intl_FOUND)
		list(APPEND BFD_LIBRARIES ${Intl_LIBRARIES})
		list(APPEND BFD_INCLUDE_DIRS ${Intl_INCLUDE_DIRS})
		list(APPEND CMAKE_REQUIRED_LIBRARIES ${Intl_LIBRARIES})
		list(APPEND CMAKE_REQUIRED_INCLUDES ${Intl_INCLUDE_DIRS})
	endif()
	
	# check if BFD requires zlib
	check_c_source_compiles("
#include <bfd.h>
int main(void) 
{
    bfd_init();
    bfd_openr(\"foo\", 0);
    return 42;
}"
		BFD_NO_ZLIB_DEPENDENCY)
		
	if(NOT BFD_NO_ZLIB_DEPENDENCY)
		find_dependency(ZLIB)
		list(APPEND BFD_REQUIRED_VARS ZLIB_FOUND)
		
		if(ZLIB_FOUND)
			list(APPEND BFD_LIBRARIES ${ZLIB_LIBRARIES})
			list(APPEND BFD_INCLUDE_DIRS ${ZLIB_INCLUDE_DIRS})
			list(APPEND CMAKE_REQUIRED_LIBRARIES ${ZLIB_LIBRARIES})
			list(APPEND CMAKE_REQUIRED_INCLUDES ${ZLIB_INCLUDE_DIRS})
		endif()
	endif()
	
	# check if BFD requires libdl
	check_c_source_compiles("
#include <bfd.h>
bfd *file;
int main(void) 
{
    bfd_init();
	file = bfd_openr(\"foo\", 0);
    bfd_get_section_name(file, file->sections);
    return 42;
}"
		BFD_NO_DL_DEPENDENCY)
		
	if(NOT BFD_NO_DL_DEPENDENCY)
		
		find_library(DL_LIBRARY NAMES dl DOC "Path to libdl, the dynamic loader library")
		
		list(APPEND BFD_REQUIRED_VARS DL_LIBRARY)

		if(EXISTS DL_LIBRARY)
			list(APPEND BFD_LIBRARIES ${DL_LIBRARY})
			list(APPEND CMAKE_REQUIRED_LIBRARIES ${DL_LIBRARY})
		endif()
	endif()
		
	
	# now check that libbfd can actually be linked
check_c_source_compiles("
#include <bfd.h>
bfd *file;
int main(void) 
{
    bfd_init();
	file = bfd_openr(\"foo\", 0);
    bfd_get_section_name(file, file->sections);
    return 42;
}"
		BFD_WORKS)
	list(APPEND BFD_REQUIRED_VARS BFD_WORKS)
	
	cmake_pop_check_state()
endif()

find_package_handle_standard_args(BFD REQUIRED_VARS ${BFD_REQUIRED_VARS})

if(BFD_FOUND)
	import_libraries(bfd LIBRARIES ${BFD_LIBRARIES} INCLUDES ${BFD_INCLUDE_DIRS})
endif()