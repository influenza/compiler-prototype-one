#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([Prototype SCLC Compiler], [0.1.0], [ronald.dahlgren@gmail.com],, [])
AM_INIT_AUTOMAKE
AC_USE_SYSTEM_EXTENSIONS
AC_CONFIG_SRCDIR([src/main.c])
AC_CONFIG_HEADERS([config.h])

# Point to the extra macros we're using
AC_CONFIG_MACRO_DIR([m4/])

# Verify the compile and install script are present
AC_PROG_CC([gcc])
AC_PROG_INSTALL
AC_PROG_RANLIB

# Make sure we can use the gnu99 standard -std=gnu99
AX_CHECK_COMPILE_FLAG([-std=gnu11], [CFLAGS+=" -std=gnu11"], AC_MSG_ERROR([
  **************************************************************************
  **** The gnu99 standard is required for this project. See config.log  ****
  **** for more information.                                            ****
  **************************************************************************]))

AC_CHECK_LIB([m], [cos],[],
    AC_MSG_ERROR([
  **************************************************************************
  **** The standard math library is required for this project. This lib ****
  **** is expected to be found on every modern Linux system. Please     ****
  **** contact the maintainers and provide a copy of config.log!        ****
  **************************************************************************]))

# Checks for header files.
AC_CHECK_HEADERS([stddef.h stdlib.h string.h strings.h unistd.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_TYPE_SIZE_T

# Look for C99 types
AC_CHECK_TYPES([uint8_t, uint16_t, uint32_t])

# Switches!
AC_ARG_ENABLE([cache-coherent-alignment],
              [AS_HELP_STRING([--enable-cache-coherent-alignment], 
                              [Enable cache coherency optimization])],
              [cache_coherent_alignment=no],
              [cache_coherent_alignment=yes])

# Checks for library functions.
AC_FUNC_ERROR_AT_LINE
AC_FUNC_MALLOC
AC_CHECK_FUNCS([bzero memmove strerror])

AC_CONFIG_FILES([Makefile
                 src/Makefile])
AC_OUTPUT

echo \
"-------------------------------------------------

 ${PACKAGE_NAME} Version ${PACKAGE_VERSION}

 Prefix: '${prefix}'.
 Compiler: '${CC} ${CFLAGS} ${CPPFLAGS}'

 Package features: N/A

 Now type 'make @<:@<target>@:>@'
   where the optional <target> is:
     all                - build all binaries (default)
     install            - install everything

--------------------------------------------------"
