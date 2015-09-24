SUFFIXES = .c .h .y .l

AM_YFLAGS = -d

noinst_LIBRARIES = libsclcscanner.a

BUILT_SOURCES = scl.h scl.c

libsclcscanner_a_SOURCES = scanner.c scanner.h scl.y scl.l
libsclcscanner_a_CPPFLAGS = -I$(top_srcdir)/src

mostlyclean-local:
	-rm scl.h scl.c
