project(libc-net)

cmake_minimum_required(VERSION 3.13)

#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -include ${CMAKE_CURRENT_SOURCE_DIR}/../../platform-include/net/if_var.h")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -include ${CMAKE_CURRENT_SOURCE_DIR}/../fbsdcompat/_fbsd_compat_.h")

add_definitions(-Dinet_aton=__inet_aton -Dinet_addr=__inet_addr)

set(net_sources
	FreeBSD/addr2ascii.c
	FreeBSD/ascii2addr.c
	FreeBSD/inet_addr.c
	FreeBSD/inet_lnaof.c
	FreeBSD/inet_makeaddr.c
	FreeBSD/inet_neta.c
	FreeBSD/inet_net_ntop.c
	FreeBSD/inet_netof.c
	FreeBSD/inet_net_pton.c
	FreeBSD/inet_network.c
	FreeBSD/inet_ntoa.c
	FreeBSD/linkaddr.c
	FreeBSD/nsap_addr.c
	FreeBSD/recv.c
	FreeBSD/send.c
	FreeBSD/sockatmark.c
	FreeBSD/sourcefilter.c
	inet_ntop.c
	inet_pton.c
)

add_darling_object_library(libc-net ${net_sources})

# ***
# Cancelable variants
# ***
set(net-cancelable_sources FreeBSD/send.c FreeBSD/recv.c)
add_library(libc-net_cancelable OBJECT ${net-cancelable_sources})
SET_TARGET_PROPERTIES(libc-net_cancelable PROPERTIES COMPILE_FLAGS "-U__DARWIN_UNIX03 -DBUILDING_VARIANT -DVARIANT_CANCELABLE -U__DARWIN_NON_CANCELABLE=1")

# ***
# Legacy i386 variants
#
if (TARGET_i386)
	set(net-legacy_sources FreeBSD/recv.c FreeBSD/send.c)
	add_library(libc-net_legacy OBJECT ${net-legacy_sources})
	SET_TARGET_PROPERTIES(libc-net_legacy PROPERTIES COMPILE_FLAGS
		"-DBUILDING_VARIANT -DVARIANT_LEGACY -U__DARWIN_UNIX03 -D__DARWIN_UNIX03=0 -U__DARWIN_64_BIT_INO_T -D_DARWIN_NO_64_BIT_INODE")
endif (TARGET_i386)
