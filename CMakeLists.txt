project(darling-libsystem_c)

cmake_minimum_required(VERSION 3.13)
if(COMMAND cmake_policy)
	cmake_policy(SET CMP0003 NEW)
	cmake_policy(SET CMP0018 NEW)
endif(COMMAND cmake_policy)

add_definitions(-DHAVE_STDINT_H=1)
add_definitions(-D__LIBC__ -D__DARWIN_UNIX03=1 -D__DARWIN_64_BIT_INO_T=1 -D__DARWIN_NON_CANCELABLE=1 -D__DARWIN_VERS_1050=1)
add_definitions("'-D__warn_references(name,warning)='")
add_definitions(-DBUILDING_LIBC -DPRIVATE)

# Hide warnings that get spammed
add_definitions(
	-Wno-gnu-include-next
	-Wno-undef
	-Wno-conversion
	-Wno-unused-parameter
	-Wno-sign-conversion
	-Wno-macro-redefined
)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -nostdinc -fPIC -w ")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -include ${CMAKE_CURRENT_SOURCE_DIR}/darling/include/weak_reference.h")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -ggdb -O0") # development flags
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -nostdlib -Wl,-bind_at_load")

include_directories(
	"${CMAKE_CURRENT_SOURCE_DIR}/fbsdcompat"
	"${CMAKE_CURRENT_SOURCE_DIR}/darwin"
	"${CMAKE_CURRENT_SOURCE_DIR}/generated/derived"
	"${CMAKE_CURRENT_SOURCE_DIR}/../external/libmalloc/src"
	"${CMAKE_CURRENT_SOURCE_DIR}/../external/libmalloc/private"
	"${CMAKE_CURRENT_SOURCE_DIR}/locale"
	"${CMAKE_CURRENT_SOURCE_DIR}/gen"
	"${CMAKE_CURRENT_SOURCE_DIR}/locale/FreeBSD"
	"${CMAKE_CURRENT_SOURCE_DIR}/include/NetBSD"
	"${CMAKE_CURRENT_SOURCE_DIR}/stdtime/FreeBSD"
)

include_directories(BEFORE
	"${CMAKE_CURRENT_SOURCE_DIR}/include"
	"${CMAKE_CURRENT_SOURCE_DIR}/generated/private-include"
)

add_subdirectory(db) # produces libc-db
add_subdirectory(compat-43) # produces libc-compat
add_subdirectory(emulated) # produces libc-emulated
add_subdirectory(gdtoa) # produces libc-gdtoa
add_subdirectory(gen)
add_subdirectory(gmon)
add_subdirectory(os)
add_subdirectory(uuid)
add_subdirectory(util)
add_subdirectory(string)
add_subdirectory(stdtime)
add_subdirectory(sys)
add_subdirectory(stdlib)
add_subdirectory(stdio)
add_subdirectory(secure)
add_subdirectory(regex)
add_subdirectory(posix1e)
add_subdirectory(nls)
add_subdirectory(net)
add_subdirectory(locale)
add_subdirectory(darwin)
add_subdirectory(libdarwin)

if (TARGET_i386)
	add_subdirectory(i386)
	set_property (
		TARGET
			libc-stdio_legacy
			libc-compat_legacy
			libc-stdlib_legacy
			libc-stdtime_legacy
			libc-gen_legacy
			libc-string_legacy
			libc-gdtoa_legacy
			libc-regex_legacy
			libc-locale_legacy
			libc-net_legacy
			libc-i386
		APPEND_STRING PROPERTY COMPILE_FLAGS
			" -arch i386"
	)
else (TARGET_i386)
	add_library(libc-stdio_legacy OBJECT darling/src/empty.c)
	add_library(libc-compat_legacy OBJECT darling/src/empty.c)
	add_library(libc-stdlib_legacy OBJECT darling/src/empty.c)
	add_library(libc-stdtime_legacy OBJECT darling/src/empty.c)
	add_library(libc-gen_legacy OBJECT darling/src/empty.c)
	add_library(libc-string_legacy OBJECT darling/src/empty.c)
	add_library(libc-gdtoa_legacy OBJECT darling/src/empty.c)
	add_library(libc-regex_legacy OBJECT darling/src/empty.c)
	add_library(libc-locale_legacy OBJECT darling/src/empty.c)
	add_library(libc-net_legacy OBJECT darling/src/empty.c)
	add_library(libc-i386 OBJECT darling/src/empty.c)
endif (TARGET_i386)

if (TARGET_x86_64)
	add_subdirectory(x86_64)
	set_property (
		TARGET
			libc-x86_64
		APPEND_STRING PROPERTY COMPILE_FLAGS
			" -arch x86_64"
	)
else (TARGET_x86_64)
	add_library(libc-x86_64 OBJECT darling/src/empty.c)
endif (TARGET_x86_64)

make_fat(
		libc-db
		libc-compat
		libc-compat_cancelable
		libc-emulated
		libc-gdtoa
		libc-gen
		libc-gen_pre1050
		libc-gen_cancelable
		libc-gen_noinode64
		libc-gen_extsn
		libc-gmon
		libc-os
		libc-uuid
		libc-util
		libc-string
		libc-stdtime
		libc-sys
		libc-sys_noinode64
		libc-stdlib
		libc-stdlib_extsn
		libc-stdlib_cancelable
		libc-stdio
		libc-stdio_extsn
		libc-secure
		libc-regex
		libc-posix1e
		libc-nls
		libc-net
		libc-net_cancelable
		libc-locale
		libc-gen_dyld
		libc-stdlib_dyld
		libc-string_dyld
		libc-sys_dyld
		libc-gdtoa_dyld
)

set(DYLIB_INSTALL_NAME "/usr/lib/system/libsystem_c.dylib")
add_circular(system_c FAT OBJECTS
	$<TARGET_OBJECTS:libc-db>
	$<TARGET_OBJECTS:libc-compat>
	$<TARGET_OBJECTS:libc-compat_cancelable>
	$<TARGET_OBJECTS:libc-emulated>
	$<TARGET_OBJECTS:libc-gdtoa>
	$<TARGET_OBJECTS:libc-gen>
	$<TARGET_OBJECTS:libc-gen_pre1050>
	$<TARGET_OBJECTS:libc-gen_cancelable>
	$<TARGET_OBJECTS:libc-gen_noinode64>
	$<TARGET_OBJECTS:libc-gen_extsn>
	$<TARGET_OBJECTS:libc-gmon>
	$<TARGET_OBJECTS:libc-os>
	$<TARGET_OBJECTS:libc-uuid>
	$<TARGET_OBJECTS:libc-util>
	$<TARGET_OBJECTS:libc-string>
	$<TARGET_OBJECTS:libc-stdtime>
	$<TARGET_OBJECTS:libc-sys>
	$<TARGET_OBJECTS:libc-sys_noinode64>
	$<TARGET_OBJECTS:libc-stdlib>
	$<TARGET_OBJECTS:libc-stdlib_extsn>
	$<TARGET_OBJECTS:libc-stdlib_cancelable>
	$<TARGET_OBJECTS:libc-stdio>
	$<TARGET_OBJECTS:libc-stdio_extsn>
	$<TARGET_OBJECTS:libc-secure>
	$<TARGET_OBJECTS:libc-regex>
	$<TARGET_OBJECTS:libc-posix1e>
	$<TARGET_OBJECTS:libc-nls>
	$<TARGET_OBJECTS:libc-net>
	$<TARGET_OBJECTS:libc-net_cancelable>
	$<TARGET_OBJECTS:libc-locale>
	$<TARGET_OBJECTS:libc-i386>
	$<TARGET_OBJECTS:libc-x86_64>
	$<TARGET_OBJECTS:kqueue>
	$<TARGET_OBJECTS:libc-darwin>
	$<TARGET_OBJECTS:libc-stdio_legacy>
	$<TARGET_OBJECTS:libc-compat_legacy>
	$<TARGET_OBJECTS:libc-stdlib_legacy>
	$<TARGET_OBJECTS:libc-stdtime_legacy>
	$<TARGET_OBJECTS:libc-gen_legacy>
	$<TARGET_OBJECTS:libc-string_legacy>
	$<TARGET_OBJECTS:libc-gdtoa_legacy>
	$<TARGET_OBJECTS:libc-regex_legacy>
	$<TARGET_OBJECTS:libc-locale_legacy>
	$<TARGET_OBJECTS:libc-net_legacy>
	STRONG_SIBLINGS
		platform
	SIBLINGS
		system_kernel
		compiler_rt
		system_dyld
		system_malloc
		system_pthread
		system_blocks
		system_m
		platform
		launch
		system_notify
		libdispatch_shared
		system_info
		macho
		system_duct
		system_asl
		xpc
		corecrypto
		system_trace
	LINK_FLAGS
		"-Wl,-alias_list,${CMAKE_CURRENT_SOURCE_DIR}/xcodescripts/alias.list"
)
#target_link_libraries(system_c system_kernel system_m macho system_malloc platform system_blocks system_pthread compiler_rt)
#make_fat(system_c)
#set_property(TARGET system_c APPEND_STRING PROPERTY LINK_FLAGS " -Wl,-alias_list,${CMAKE_CURRENT_SOURCE_DIR}/xcodescripts/alias.list -Wl,-sub_library,libsystem_platform")

install(TARGETS system_c DESTINATION libexec/darling/usr/lib/system)

include(darling_static_lib)
add_darling_static_library(libc_static SOURCES
	$<TARGET_OBJECTS:libc-gen_dyld>
	$<TARGET_OBJECTS:libc-stdlib_dyld>
	$<TARGET_OBJECTS:libc-string_dyld>
	$<TARGET_OBJECTS:libc-sys_dyld>
	$<TARGET_OBJECTS:libc-locale>
	$<TARGET_OBJECTS:libc-stdio>
	$<TARGET_OBJECTS:libc-stdtime>
	$<TARGET_OBJECTS:libc-string>
	$<TARGET_OBJECTS:libc-gdtoa_dyld>
	$<TARGET_OBJECTS:libc-secure>
	$<TARGET_OBJECTS:libc-uuid>
	$<TARGET_OBJECTS:libc-os>
	$<TARGET_OBJECTS:libc-stdio_extsn>
	$<TARGET_OBJECTS:libc-darwin>
	)
add_dependencies(libc_static ranlib ${APPLE_TARGET_TRIPLET_PRIMARY}-ar)
set_target_properties(libc_static PROPERTIES COMPILE_FLAGS "-ffunction-sections")

add_library(libc_static64 STATIC $<TARGET_OBJECTS:libc-x86_64>)
add_dependencies(libc_static64 ranlib ${APPLE_TARGET_TRIPLET_PRIMARY}-ar)
add_library(libc_static32 STATIC $<TARGET_OBJECTS:libc-i386>)
add_dependencies(libc_static32 ranlib ${APPLE_TARGET_TRIPLET_PRIMARY}-ar)

