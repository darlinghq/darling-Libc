project(libc-stdlib)

cmake_minimum_required(VERSION 3.13)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99 -fblocks -include ${CMAKE_CURRENT_SOURCE_DIR}/../fbsdcompat/_fbsd_compat_.h")

set(stdlib_sources
	a64l.c
	grantpt.c
	l64a.c
	qsort_b.c
)

set(stdlib_sources ${stdlib_sources}
	FreeBSD/_Exit_.c
	FreeBSD/abort.c
	FreeBSD/abs.c
	FreeBSD/atexit.c
	FreeBSD/atof.c
	FreeBSD/atoi.c
	FreeBSD/atol.c
	FreeBSD/atoll.c
	FreeBSD/bsearch.c
	FreeBSD/div.c
	FreeBSD/exit.c
	FreeBSD/getenv.c
	FreeBSD/getopt_long.c
	FreeBSD/getopt.c
	FreeBSD/getsubopt.c
	FreeBSD/hcreate.c
	FreeBSD/heapsort_b.c
	FreeBSD/heapsort_r.c
	FreeBSD/heapsort.c
	FreeBSD/imaxabs.c
	FreeBSD/imaxdiv.c
	FreeBSD/insque.c
	FreeBSD/labs.c
	FreeBSD/ldiv.c
	FreeBSD/llabs.c
	FreeBSD/lldiv.c
	FreeBSD/lsearch.c
	FreeBSD/merge_b.c
	FreeBSD/merge.c
	FreeBSD/psort_b.c
	FreeBSD/psort_r.c
	FreeBSD/psort.c
	FreeBSD/putenv.c
	FreeBSD/qsort_r.c
	FreeBSD/qsort.c
	FreeBSD/radixsort.c
	FreeBSD/rand.c
	FreeBSD/random.c
	FreeBSD/reallocf.c
	FreeBSD/realpath.c
	FreeBSD/remque.c
	FreeBSD/setenv.c
	FreeBSD/strhash.c
	FreeBSD/strtoimax.c
	FreeBSD/strtol.c
	FreeBSD/strtoll.c
	FreeBSD/strtonum.c
	FreeBSD/strtoq.c
	FreeBSD/strtoul.c
	FreeBSD/strtoull.c
	FreeBSD/strtoumax.c
	FreeBSD/strtouq.c
	FreeBSD/system.c
	FreeBSD/tdelete.c
	FreeBSD/tfind.c
	FreeBSD/tsearch.c
	FreeBSD/twalk.c
)

set(stdlib_sources ${stdlib_sources}
	OpenBSD/ecvt.c
	OpenBSD/gcvt.c
)

set(stdlib_sources ${stdlib_sources}
	NetBSD/strfmon.c
)

SET_SOURCE_FILES_PROPERTIES(FreeBSD/psort_b.c PROPERTIES COMPILE_FLAGS "${CMAKE_C_FLAGS} -DI_AM_PSORT_B")
SET_SOURCE_FILES_PROPERTIES(FreeBSD/psort_r.c PROPERTIES COMPILE_FLAGS "${CMAKE_C_FLAGS} -DI_AM_PSORT_R")
SET_SOURCE_FILES_PROPERTIES(FreeBSD/system.c PROPERTIES COMPILE_FLAGS "${CMAKE_C_FLAGS} -DLIBC_ALIAS_SYSTEM")
SET_SOURCE_FILES_PROPERTIES(FreeBSD/getopt.c PROPERTIES COMPILE_FLAGS "${CMAKE_C_FLAGS} -DLIBC_ALIAS_GETOPT")
SET_SOURCE_FILES_PROPERTIES(FreeBSD/realpath.c PROPERTIES COMPILE_FLAGS "${CMAKE_C_FLAGS} -DLIBC_ALIAS_REALPATH")
SET_SOURCE_FILES_PROPERTIES(FreeBSD/setenv.c PROPERTIES COMPILE_FLAGS "${CMAKE_C_FLAGS} -DLIBC_ALIAS_SETENV -DLIBC_ALIAS_UNSETENV")
SET_SOURCE_FILES_PROPERTIES(FreeBSD/putenv.c PROPERTIES COMPILE_FLAGS "${CMAKE_C_FLAGS} -DLIBC_ALIAS_PUTENV")

add_darling_object_library(libc-stdlib ${stdlib_sources})

# Cancelable variant
set(stdlib-cancelable_sources FreeBSD/system.c)
add_library(libc-stdlib_cancelable OBJECT ${stdlib-cancelable_sources})
SET_TARGET_PROPERTIES(libc-stdlib_cancelable PROPERTIES COMPILE_DEFINITIONS "BUILDING_VARIANT;VARIANT_CANCELABLE")

# Legacy variant
if (TARGET_i386)
	set(stdlib-legacy_sources FreeBSD/getopt.c FreeBSD/realpath.c
		FreeBSD/setenv.c FreeBSD/putenv.c)
	add_library(libc-stdlib_legacy OBJECT ${stdlib-legacy_sources})
	SET_TARGET_PROPERTIES(libc-stdlib_legacy PROPERTIES COMPILE_DEFINITIONS "BUILDING_VARIANT;VARIANT_LEGACY")
endif (TARGET_i386)

# DARWIN_EXTSN variant
set(stdlib-extsn_sources FreeBSD/realpath.c)
add_library(libc-stdlib_extsn OBJECT ${stdlib-extsn_sources})
SET_TARGET_PROPERTIES(libc-stdlib_extsn PROPERTIES COMPILE_DEFINITIONS "BUILDING_VARIANT;VARIANT_DARWINEXTSN")

# DYLD variant
add_library(libc-stdlib_dyld OBJECT FreeBSD/atexit.c FreeBSD/exit.c FreeBSD/heapsort.c FreeBSD/abort.c FreeBSD/merge.c FreeBSD/qsort.c FreeBSD/reallocf.c FreeBSD/realpath.c FreeBSD/strtoul.c FreeBSD/strtol.c FreeBSD/getenv.c FreeBSD/exit.c)
SET_TARGET_PROPERTIES(libc-stdlib_dyld PROPERTIES COMPILE_FLAGS "-UBUILDING_VARIANT -DVARIANT_DYLD -DVARIANT_CANCELABLE -DVARIANT_DARWINEXTSN")

