project(libc-util)

cmake_minimum_required(VERSION 3.13)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99")

set(util_sources
	fparseln.c
	login_tty.c
	login.c
	logout.c
	logwtmp.c
	mkpath_np.c
	opendev.c
	pty.c)

add_darling_object_library(libc-util ${util_sources})
