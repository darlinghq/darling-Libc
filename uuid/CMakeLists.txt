project(libc-uuid)

cmake_minimum_required(VERSION 3.13)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99 -include ${CMAKE_CURRENT_SOURCE_DIR}/uuid-config.h")
include_directories("${CMAKE_CURRENT_SOURCE_DIR}")

set(uuid_sources
	uuidsrc/clear.c
	uuidsrc/compare.c
	uuidsrc/copy.c
	uuidsrc/gen_uuid.c
	uuidsrc/pack.c
	uuidsrc/parse.c
	uuidsrc/isnull.c
	uuidsrc/unpack.c
	uuidsrc/unparse.c)

add_darling_object_library(libc-uuid ${uuid_sources})
