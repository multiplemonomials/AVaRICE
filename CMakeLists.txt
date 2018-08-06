cmake_minimum_required(VERSION 3.1)
project(AVaRICE VERSION 2.14 LANGUAGES C CXX)
cmake_policy(VERSION 3.1)

message(STATUS "**************************************************************************")
message(STATUS "Starting configuration of ${PROJECT_NAME} version ${${PROJECT_NAME}_VERSION}...")
message(STATUS "CMake Version: ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION}")
message(STATUS "**************************************************************************")

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake ${CMAKE_CURRENT_SOURCE_DIR}/cmake/cmake-modules)
include(Utils)
include(Shorthand)
include(LibraryUtils)

include(CheckIncludeFileCXX)
include(CheckFunctionExists)
include(CMakePushCheckState)
include(CheckCXXSourceCompiles)
include(FindPackageHandleStandardArgs)

# setup compiler flags
# ---------------------------------------------------------------

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_EXTENSIONS FALSE)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS FALSE)

option(ENABLE_WARNINGS "Enable compiler warnings" TRUE)

if(ENABLE_WARNINGS)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wno-missing-field-initializers")
endif()

# find dependency libraries
# ---------------------------------------------------------------
message(STATUS "Detecting libraries...")

find_package(USB REQUIRED)
import_library(usb ${USB_LIBRARIES} ${USB_INCLUDE_DIRS})

set(CMAKE_THREAD_PREFER_PTHREAD TRUE)
find_package(Threads REQUIRED)

find_package(Iconv)

# system introspection
# ---------------------------------------------------------------
message(STATUS "Checking system...")

check_all_includes(CXX
	arpa/inet.h 
	fcntl.h 
	netdb.h 
	netinet/in.h 
	stdlib.h 
	string.h 
	strings.h
	sys/socket.h 
	sys/select.h
	sys/time.h
	sys/stat.h
	sys/types.h
	termios.h 
	unistd.h
	stdbool.h
	memory.h
	stdint.h
	stdlib.h
	vfork.h)
	
check_all_functions(
	atexit 
	gethostbyname 
	inet_ntoa 
	memmove 
	memset 
	select 
	socket 
	strcasecmp 
	strerror 
	strtol
	vfork
	vprintf)
	
# config header
# ---------------------------------------------------------------
set(HAVE_LIBUSB TRUE)

set(PACKAGE_BUGREPORT "jsmith@crackofdawn.onmicrosoft.com")
set(PACKAGE_STRING "${PROJECT_NAME} ${PROJECT_VERSION}")
set(PACKAGE_TARNAME avarice)
set(PACKAGE_URL http://avarice.sourceforge.net/)

set(HAVE_LIBUSB_2_0 ${LIBUSB_IS_BSD_USB20})
	

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/src/autoconf.in.cmake ${CMAKE_CURRENT_BINARY_DIR}/src/autoconf.h)
	
# subdirs
# ---------------------------------------------------------------
add_subdirectory(scripts)
add_subdirectory(doc)
add_subdirectory(src)

# build report
# ---------------------------------------------------------------
message(STATUS "**************************************************************************")
message(STATUS "Configuration successful!")
message(STATUS "Build type:                      ${CMAKE_BUILD_TYPE}")
message(STATUS "AVaRICE will be installed to:    ${CMAKE_INSTALL_PREFIX}")