project(libc-os)

cmake_minimum_required(VERSION 3.13)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/..)
set(os_sources assumes.c debug_private.c)

add_darling_object_library(libc-os ${os_sources})
