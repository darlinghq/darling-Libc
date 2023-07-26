project(libc-posix1e)

cmake_minimum_required(VERSION 3.13)

set(posix1e_sources
	acl.c
	acl_entry.c
	acl_file.c
	acl_flag.c
	acl_perm.c
	acl_translate.c # doesn't build, ducted
)

add_library(libc-posix1e OBJECT ${posix1e_sources})
