AC_PREREQ(2.52)

AC_INIT([apertium-eng-kaz], [1.0.0], [unknown@users.sourceforge.net])
AM_INIT_AUTOMAKE([apertium-eng-kaz], [1.0.0], no-define)
AC_PROG_LN_S
AC_PROG_AWK

m4_define([required_apertium_version], [3.3.0])
PKG_CHECK_MODULES(APERTIUM,   apertium >= required_apertium_version, [], [PKG_CHECK_MODULES(APERTIUM,   apertium-3.2 >= required_apertium_version)])
                          

PKG_CHECK_MODULES(HFST, hfst >= 3.16.0)
PKG_CHECK_MODULES(CG3, cg3 >= 1.3.6)
PKG_CHECK_MODULES(APERTIUM_LEX_TOOLS, apertium-lex-tools >= 0.4.0)

AC_PATH_PROG(GZCAT, gzcat, no)
AC_PATH_PROG(ZCAT, zcat, no)

if test x$ac_cv_path_GZCAT = xno
then
  if test x$ac_cv_path_ZCAT = xno
  then
    AC_MSG_ERROR([No working zcat installed.])
  else
    AC_SUBST(ZCAT,[zcat])
  fi
else
  AC_SUBST(ZCAT,[gzcat])
fi


m4_ifdef([AP_CHECK_LING],[],[AC_MSG_ERROR([AP_CHECK_LING not defined, is apertium.m4 in ACLOCAL_PATH? See: https://wiki.apertium.org/wiki/Installation_troubleshooting])])

# eng TODO
AP_CHECK_LING([1], [apertium-eng])
AP_CHECK_LING([2], [apertium-kaz])

PKG_CHECK_MODULES(REGTEST, apertium-regtest >= 0.0.1, [],
                  [AC_MSG_WARN([Running tests requires apertium-regtest])])

PKG_CHECK_MODULES(REGTEST, apertium-regtest >= 0.0.1, [],
                  [AC_MSG_WARN([Running tests requires apertium-regtest])])

AP_MKINCLUDE

AC_OUTPUT([Makefile])

