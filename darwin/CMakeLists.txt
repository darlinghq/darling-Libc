project(libc-darwin)

cmake_minimum_required(VERSION 3.13)

set(darwin_sources
	atexit_receipt.c
	compatibility_hacks.c
	forceLibcToBuild.c
	kvm.c
	../darling/src/darling_hacks.c
	subsystem.c
)

add_darling_object_library(libc-darwin ${darwin_sources})
