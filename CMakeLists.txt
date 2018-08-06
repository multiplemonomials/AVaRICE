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
include(CheckCSourceCompiles)
include(CheckCXXSourceCompiles)
include(FindPackageHandleStandardArgs)
include(CMakeFindDependencyMacro)
include(CheckTypeSize)

#control default build type.
# ---------------------------------------------------------------

set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Allowed build types for ${PROJECT_NAME}." FORCE)
if("${CMAKE_BUILD_TYPE}" STREQUAL "")
	set(CMAKE_BUILD_TYPE Release CACHE STRING "Type of build.  Controls debugging information and optimizations." FORCE)
endif()

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


set(CMAKE_THREAD_PREFER_PTHREAD TRUE)
find_package(Threads REQUIRED)

find_package(USB)
if(USB_FOUND)
	import_library(usb ${USB_LIBRARIES} ${USB_INCLUDE_DIRS})
endif()

find_package(HIDAPI)
if(HIDAPI_FOUND)
	import_library(hidapi ${HIDAPI_LIBRARIES} ${HIDAPI_INCLUDE_DIRS})
endif()

find_package(BFD)
if(BFD_FOUND)
	add_definitions(-DENABLE_TARGET_PROGRAMMING=1)
else()
	add_definitions(-DENABLE_TARGET_PROGRAMMING=0)
endif()

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
	
check_all_types(
	socklen_t)
	
# config header
# ---------------------------------------------------------------

set(PACKAGE_BUGREPORT "jsmith@crackofdawn.onmicrosoft.com")
set(PACKAGE_STRING "${PROJECT_NAME} ${PROJECT_VERSION}")
set(PACKAGE_TARNAME avarice)
set(PACKAGE_URL http://avarice.sourceforge.net/)

set(HAVE_LIBUSB ${LIBUSB_FOUND})
set(HAVE_LIBUSB_2_0 ${LIBUSB_IS_BSD_USB20})
set(HAVE_LIBHIDAPI ${LIBHIDAPI_FOUND})

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

# libusb
if(USB_FOUND)
message(STATUS "libusb 0.1:                      ENABLED      [${USB_LIBRARY}]")
else()
message(STATUS "libusb 0.1:                      NOT FOUND    [JTAGICE mkII and AVRDRAGON USB support can't be built]")
endif()

# libhidapi
if(HIDAPI_FOUND)
message(STATUS "libhidapi:                       ENABLED      [${HIDAPI_LIBRARY}]")
else()
message(STATUS "libhidapi:                       NOT FOUND    [JTAGICE3, Atmel ICE, and EDBG support can't be built]")
endif()

# libbfd
if(BFD_FOUND)
message(STATUS "libbfd:                          ENABLED      [${BFD_LIBRARY}]")
else()
message(STATUS "libbfd:                          NOT FOUND    [Target programming support can't be built]")
endif()