SUFFIXES = .c .h .y .l

AM_YFLAGS = -d

noinst_LIBRARIES = libsclcscanner.a

BUILT_SOURCES = scl_parser.h scl_parser.c scl_scanner.c

libsclcscanner_a_SOURCES = scanner.c scanner.h scl_parser.y scl_scanner.l
libsclcscanner_a_CPPFLAGS = -I$(top_srcdir)/src

mostlyclean-local:
	-rm scl.h scl.c
