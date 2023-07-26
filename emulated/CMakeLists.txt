project(libc-emulated)

cmake_minimum_required(VERSION 3.13)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99")

set(emulated_sources brk.c bsd_signal.c lchflags.c lchmod.c lutimes.c statvfs.c tcgetsid.c)

add_darling_object_library(libc-emulated ${emulated_sources})
