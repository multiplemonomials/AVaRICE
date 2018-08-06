# from https://github.com/planetbeing/xpwn/blob/master/FindUSB.cmake
# - Try to find USB
# Once done this will define
#
#  USB_FOUND - system has USB
#  USB_INCLUDE_DIRS - the USB include directory
#  USB_LIBRARIES - Link these to use USB
#  LIBUSB_IS_BSD_USB20 - True if libusb is BSD's libusb20
#
#  Copyright (c) 2006 Andreas Schneider <mail@cynapses.org>
#
#  Redistribution and use is allowed according to the terms of the New
#  BSD license.
#  For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#


if (USB_LIBRARIES AND USB_INCLUDE_DIRS)
	# in cache already
	set(USB_FOUND TRUE)
else (USB_LIBRARIES AND USB_INCLUDE_DIRS)
	find_path(USB_INCLUDE_DIR
		NAMES
			usb.h
		PATHS
			/usr/include
			/usr/local/include
			/opt/local/include
			/sw/include
	)

	find_library(USB_LIBRARY
		NAMES
			usb
		PATHS
			/usr/lib
			/usr/local/lib
			/opt/local/lib
			/sw/lib
	)

	set(USB_INCLUDE_DIRS
		${USB_INCLUDE_DIR})
	set(USB_LIBRARIES
		${USB_LIBRARY})
	
	# show the USB_INCLUDE_DIRS and USB_LIBRARIES variables only in the advanced view
	mark_as_advanced(USB_INCLUDE_DIR USB_LIBRARY)
		
	find_package_handle_standard_args(USB REQUIRED_VARS USB_LIBRARY USB_INCLUDE_DIR)

	# check if libusb is libusb20 from BSD
	if(USB_FOUND)
		cmake_push_check_state()
		set(CMAKE_REQUIRED_LIBRARIES ${USB_LIBRARY})
		check_function_exists(libusb20_dev_open LIBUSB_IS_BSD_USB20)
		cmake_pop_check_state()
	else()
		set(LIBUSB_IS_BSD_USB20 FALSE)
	endif()

endif (USB_LIBRARIES AND USB_INCLUDE_DIRS)

