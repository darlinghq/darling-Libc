project(libc-nls)

cmake_minimum_required(VERSION 3.13)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../include/FreeBSD)

set(nls_sources
	FreeBSD/msgcat.c
)

add_darling_object_library(libc-nls ${nls_sources})
