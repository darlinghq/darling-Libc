project(libc-compat)

cmake_minimum_required(VERSION 3.13)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99 -include ${CMAKE_CURRENT_SOURCE_DIR}/../fbsdcompat/_fbsd_compat_.h")

set(compat_sources setregid.c setreuid.c sigaltstk.c sigcompat.c)

set(compat_sources ${compat_sources}
	FreeBSD/creat.c
	FreeBSD/gethostid.c
	FreeBSD/getwd.c
	FreeBSD/killpg.c
	FreeBSD/sethostid.c
	FreeBSD/setpgrp.c
	FreeBSD/setrgid.c
	FreeBSD/setruid.c)

SET_SOURCE_FILES_PROPERTIES(FreeBSD/creat.c PROPERTIES COMPILE_FLAGS "${CMAKE_C_FLAGS} -DLIBC_ALIAS_CREAT")
SET_SOURCE_FILES_PROPERTIES(FreeBSD/killpg.c PROPERTIES COMPILE_FLAGS "${CMAKE_C_FLAGS} -DLIBC_ALIAS_KILLPG")
SET_SOURCE_FILES_PROPERTIES(FreeBSD/setpgrp.c PROPERTIES COMPILE_FLAGS "${CMAKE_C_FLAGS} -DLIBC_ALIAS_SETPGRP")
SET_SOURCE_FILES_PROPERTIES(sigcompat.c PROPERTIES COMPILE_FLAGS "${CMAKE_C_FLAGS} -DLIBC_ALIAS_SIGPAUSE")

add_darling_object_library(libc-compat ${compat_sources})
#SET_TARGET_PROPERTIES(libc-compat PROPERTIES COMPILE_DEFINITIONS "__DARWIN_NON_CANCELABLE")

# ***
# Cancelable variants
# ***

#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -U__DARWIN_NON_CANCELABLE")

set(compat-cancelable_sources sigcompat.c FreeBSD/creat.c)

add_library(libc-compat_cancelable OBJECT ${compat-cancelable_sources})
SET_TARGET_PROPERTIES(libc-compat_cancelable PROPERTIES
	COMPILE_DEFINITIONS "BUILDING_VARIANT;VARIANT_CANCELABLE"
	COMPILE_FLAGS "-U__DARWIN_NON_CANCELABLE -D__DARWIN_UNIX03=1")

# ***
# Legacy variants
# ***

if (TARGET_i386)
	set(compat-legacy_sources FreeBSD/creat.c FreeBSD/killpg.c)
	add_library(libc-compat_legacy OBJECT ${compat-legacy_sources})
	SET_TARGET_PROPERTIES(libc-compat_legacy PROPERTIES
		COMPILE_DEFINITIONS "BUILDING_VARIANT;VARIANT_LEGACY;_NONSTD_SOURCE"
		COMPILE_FLAGS "-U__DARWIN_NON_CANCELABLE -U__DARWIN_UNIX03 -U_DARWIN_C_SOURCE -U_POSIX_C_SOURCE")
endif (TARGET_i386)
