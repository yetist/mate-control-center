AC_INIT([mate-control-center], [1.30.0], [http://www.mate-desktop.org/])

AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_SRCDIR([shell])
AC_CONFIG_HEADERS([config.h])

AM_INIT_AUTOMAKE([1.9 no-dist-gzip dist-xz tar-ustar])
AM_MAINTAINER_MODE
m4_ifdef([AM_SILENT_RULES],[AM_SILENT_RULES([yes])])

MATE_COMMON_INIT
MATE_DEBUG_CHECK
MATE_COMPILE_WARNINGS
MATE_MAINTAINER_MODE_DEFINES

AC_PROG_CC
AM_PROG_CC_C_O
AC_STDC_HEADERS
AM_PROG_LIBTOOL
AC_PATH_PROG([GLA11Y], [gla11y], [true])

# Use the Yelp documentation framework
YELP_HELP_INIT

# Internationalization support
AM_GNU_GETTEXT([external])
AM_GNU_GETTEXT_VERSION([0.19.8])
AM_CONDITIONAL([USE_NLS], [test "x${USE_NLS}" = "xyes"])

GETTEXT_PACKAGE=mate-control-center
AC_SUBST(GETTEXT_PACKAGE)
AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE, "$GETTEXT_PACKAGE", [Gettext package])

# GLIB_COMPILE_RESOURCES

AC_ARG_VAR([GLIB_COMPILE_RESOURCES],[glib-compile-resources bin])
AC_PATH_PROG([GLIB_COMPILE_RESOURCES],[glib-compile-resources],[])
if test -z "$GLIB_COMPILE_RESOURCES"; then
  AC_MSG_ERROR([glib-compile-resources not found])
fi

# XMLLINT

AC_ARG_VAR([XMLLINT],[xmllint bin])
AC_PATH_PROG([XMLLINT],[xmllint],[])
if test -z "$XMLLINT"; then
  AC_MSG_ERROR([xmllint not found])
fi

AC_PATH_XTRA
x_libs="$X_PRE_LIBS $X_LIBS -lX11 $X_EXTRA_LIBS"

AC_CHECK_FUNC(XScreenSaverQueryInfo, [
  TYPING_BREAK="typing-break"], [
  save_LIBS=$LIBS
  LIBS="$LIBS $X_PRE_LIBS $X_LIBS -lXss -lXext -lX11"
  AC_CHECK_LIB(Xss, XScreenSaverQueryInfo, [
    TYPING_BREAK="typing-break"
    SCREENSAVER_LIBS="$X_PRE_LIBS $X_LIBS -lXss -lXext -lX11"], [
    LIBS=$save_LIBS
    LIBS="$LIBS $X_PRE_LIBS $X_LIBS -lXext -lX11"
    AC_CHECK_LIB(Xext, XScreenSaverQueryInfo, [
      TYPING_BREAK="typing-break"
      SCREENSAVER_LIBS="$X_PRE_LIBS $X_LIBS -lXext -lX11"],[])])
  LIBS=$save_LIBS])
AC_SUBST(TYPING_BREAK)
AC_SUBST(SCREENSAVER_LIBS)

GLIB_REQUIRED=2.64.0
SYSTEMD_REQUIRED=248
GTK_REQUIRED=3.22.0
MARCO_REQUIRED=1.17.0
MATEKBD_REQUIRED=1.17.0
MATE_DESKTOP_REQUIRED=1.27.1
APPINDICATOR_REQUIRED=0.0.13

ENGINES_FOLDER="theming-engines"

PKG_CHECK_MODULES(LIBCANBERRA_GTK, libcanberra-gtk3, [
    CANBERRA_GTK=1
    AC_SUBST(LIBCANBERRA_GTK_CFLAGS)
    AC_SUBST(LIBCANBERRA_GTK_LIBS)
    ], [:])
AM_CONDITIONAL(HAVE_LIBCANBERRA_GTK, test "x$CANBERRA_GTK" = "x1")

AM_CONDITIONAL(HAVE_TYPING_BREAK, test "x$TYPING_BREAK" = xtyping-break)

dnl keyboard-properties-capplet
savecppflags=$CPPFLAGS
CPPFLAGS="$CPPFLAGS $X_CFLAGS"
AC_CHECK_HEADERS([X11/Xlib.h])
AC_CHECK_HEADERS(X11/extensions/XKB.h)
CPPFLAGS=$savecppflags

AC_CHECK_LIB(m, floor)

dnl ==============================================
dnl Check that we meet the  dependencies
dnl ==============================================

PKG_CHECK_MODULES(GMODULE,gmodule-2.0,[GMODULE_ADD="gmodule-2.0"],[GMODULE_ADD=""])
COMMON_MODULES="gtk+-3.0 >= $GTK_REQUIRED dnl
 $GMODULE_ADD dnl
 glib-2.0 >= $GLIB_REQUIRED dnl
 gthread-2.0 dnl
 gio-2.0 dnl
 gio-unix-2.0 dnl
 libxml-2.0 dnl
 udisks2 dnl
 libgtop-2.0 dnl
 mate-desktop-2.0 >= $MATE_DESKTOP_REQUIRED"
PKG_CHECK_MODULES(CAPPLET, $COMMON_MODULES)
PKG_CHECK_MODULES(MATECC, $COMMON_MODULES libmate-menu >= 1.21.0)
PKG_CHECK_MODULES(MATECC_SHELL, $COMMON_MODULES libmate-menu librsvg-2.0 pango)

PKG_CHECK_MODULES(POLKIT, polkit-gobject-1)
PKG_CHECK_MODULES(MATE_DESKTOP, mate-desktop-2.0 >= $MATE_DESKTOP_REQUIRED)
PKG_CHECK_MODULES(DEFAULT_APPLICATIONS_CAPPLET, libxml-2.0)
PKG_CHECK_MODULES(MARCO, libmarco-private >= $MARCO_REQUIRED)
PKG_CHECK_MODULES(TYPING, $GMODULE_ADD glib-2.0 >= $GLIB_REQUIRED gio-2.0 gtk+-3.0 >= $GTK_REQUIRED)
PKG_CHECK_MODULES(GIO, gio-2.0)
PKG_CHECK_MODULES(GLIBTOP, libgtop-2.0)
PKG_CHECK_MODULES(UDISKS, udisks2)

PKG_CHECK_MODULES([DCONF], [dconf >= 0.13.4])
AC_SUBST(DCONF_CFLAGS)
AC_SUBST(DCONF_LIBS)
AC_SUBST(GLIBTOP_CFLAGS)
AC_SUBST(GLIBTOP_LIBS)

gtk_lib_dir=`$PKG_CONFIG --variable libdir gtk+-3.0`
gtk_binary_version=`$PKG_CONFIG --variable gtk_binary_version gtk+-3.0`
GTK_ENGINE_DIR="$gtk_lib_dir/gtk-3.0/$gtk_binary_version/$ENGINES_FOLDER"
AC_SUBST(GTK_ENGINE_DIR)

PKG_CHECK_MODULES(GLIB, glib-2.0 >= $GLIB_REQUIRED $GMODULE_ADD)


AC_SUBST(LIBMATECC_SHELL_CFLAGS)

dnl
dnl Check dependencies of accountsservice
dnl

ACCOUNTSSERVICE_REQUIRED=0.6.21

AC_ARG_WITH([accountsservice], AS_HELP_STRING([--without-accountsservice], [disable accountsservice support]))
have_accountsservice=no
if test x$with_accountsservice != xno; then
    PKG_CHECK_MODULES(ACCOUNTSSERVICE, accountsservice >= $ACCOUNTSSERVICE_REQUIRED, have_accountsservice=yes, have_accountsservice=no)
fi
if test "x$have_accountsservice" = "xyes"; then
  AC_DEFINE(HAVE_ACCOUNTSSERVICE, 1, [ACCOUNTSSERVICE Support.])
fi

AM_CONDITIONAL([HAVE_ACCOUNTSSERVICE], [test "x$have_accountsservice" = xyes])

AYATANA_APPINDICATOR_PKG=ayatana-appindicator3-0.1
UBUNTU_APPINDICATOR_PKG=appindicator3-0.1

AC_ARG_ENABLE([libappindicator],
              [AS_HELP_STRING([--enable-libappindicator[=@<:@no/auto/yes@:>@]],[Use libappindicator instead of ayatana-indicator @<:@default=auto@:>@])],
              [enable_appindicator=$enableval],
              [PKG_CHECK_EXISTS([$AYATANA_APPINDICATOR_PKG >= $APPINDICATOR_REQUIRED],
                                [enable_appindicator=no],
                                [PKG_CHECK_EXISTS([$UBUNTU_APPINDICATOR_PKG >= $APPINDICATOR_REQUIRED],
                                                  [enable_appindicator=yes],
                                                  [enable_appindicator=no])])])

AS_IF([test "x$enable_appindicator" = xyes],
      [AC_MSG_NOTICE([Buidling against Ubuntu AppIndicator.])
       PKG_CHECK_MODULES([APPINDICATOR],
                         [$UBUNTU_APPINDICATOR_PKG >= $APPINDICATOR_REQUIRED],
                         [AC_DEFINE(HAVE_UBUNTU_APPINDICATOR, 1, [Have Ubuntu AppIndicator])])],
      [AC_MSG_NOTICE([Buidling against Ayatana AppIndicator.])
       PKG_CHECK_MODULES([APPINDICATOR],
                         [$AYATANA_APPINDICATOR_PKG >= $APPINDICATOR_REQUIRED],
                         [AC_DEFINE(HAVE_AYATANA_APPINDICATOR, 1, [Have Ayatana AppIndicator])])])

have_systemd=no
AC_ARG_ENABLE(systemd, AS_HELP_STRING([--disable-systemd], [disable systemd support]),enable_systemd="$enableval",enable_systemd=auto)
if test "x$enable_systemd" != "xno"; then
	PKG_CHECK_MODULES(SYSTEMD, [libsystemd], [have_systemd=yes],
	                  [PKG_CHECK_MODULES(SYSTEMD, [libsystemd >= $SYSTEMD_REQUIRED],
	                  [have_systemd=yes])])
	if test "x$have_systemd" = xno && test "x$enable_systemd" = xyes; then
		AC_MSG_ERROR([*** systemd support requested but libraries not found])
	elif test "x$have_systemd" = xyes; then
		AC_DEFINE(HAVE_SYSTEMD, 1, [Define if systemd is available])
	fi
fi

AM_CONDITIONAL(HAVE_SYSTEMD, [test "$have_systemd" = "yes"])

PKG_CHECK_MODULES(FONT_CAPPLET, $COMMON_MODULES pango)
PKG_CHECK_MODULES(FONT_VIEWER, $COMMON_MODULES fontconfig freetype2 mate-desktop-2.0)

PKG_CHECK_MODULES(AT_CAPPLET, $COMMON_MODULES)

PKG_CHECK_MODULES(DISPLAY_CAPPLET, $COMMON_MODULES)
DISPLAY_CAPPLET_LIBS="$DISPLAY_CAPPLET_LIBS"

CAPPLET_LIBS="$CAPPLET_LIBS $x_libs"
MATECC_LIBS="$MATECC_LIBS $x_libs"

PKG_CHECK_MODULES(XCURSOR, xcursor)
XCURSOR_ICONDIR=$($PKG_CONFIG --variable=icondir xcursor)
AC_DEFINE_UNQUOTED(XCURSOR_ICONDIR, "${XCURSOR_ICONDIR}", [Define to the xcursor icon path])

CAPPLET_LIBS="$CAPPLET_LIBS $XCURSOR_LIBS"

dnl ======================
dnl X Input library >= 1.5
dnl ======================

PKG_CHECK_MODULES(XINPUT, xi >= 1.5)

CAPPLET_LIBS="$CAPPLET_LIBS $XINPUT_LIBS"

PKG_CHECK_MODULES(LIBMATEKBD, [libmatekbd >= $MATEKBD_REQUIRED libxklavier >= 5.2])
AC_SUBST(LIBMATEKBD_CFLAGS)
AC_SUBST(LIBMATEKBD_LIBS)

PKG_CHECK_MODULES(LIBMATEKBDUI, [libmatekbdui >= $MATEKBD_REQUIRED])
AC_SUBST(LIBMATEKBDUI_CFLAGS)
AC_SUBST(LIBMATEKBDUI_LIBS)

dnl ==============================================
dnl End: Check that we meet the  dependencies
dnl ==============================================

AC_PATH_PROG(GLIB_GENMARSHAL, glib-genmarshal, no)

if test x"$GLIB_GENMARSHAL" = xno; then
  AC_MSG_ERROR([glib-genmarshal executable not found in your path - should be installed with glib])
fi

AC_SUBST(GLIB_GENMARSHAL)

dnl ==============================================
dnl Special GSettings section
dnl ==============================================

GLIB_GSETTINGS

dnl ==============================================
dnl Define the main variables
dnl ==============================================
COMMON_CFLAGS="-I\$(top_srcdir)/capplets/common"
COMMON_LIBS="\$(top_builddir)/capplets/common/libcommon.la"

EXTRA_CFLAGS="-I\$(top_srcdir)/ -DG_LOG_DOMAIN=\"\\\"\$(cappletname)-properties\\\"\""

MATECC_CAPPLETS_CFLAGS="${COMMON_CFLAGS} ${CAPPLET_CFLAGS} ${EXTRA_CFLAGS} ${POLKIT_CFLAGS}"
MATECC_CAPPLETS_LIBS="${COMMON_LIBS} ${CAPPLET_LIBS} ${POLKIT_LIBS}"

MATECC_CAPPLETS_CLEANFILES="\$(desktop) \$(desktop).in"
MATECC_CAPPLETS_EXTRA_DIST="ChangeLog \$(desktop).in.in \$(cappletname)-capplet.png \$(pixmaps_DATA)"

AC_SUBST(MATECC_CAPPLETS_EXTRA_DIST)
AC_SUBST(MATECC_CAPPLETS_CLEANFILES)
AC_SUBST(MATECC_CAPPLETS_CFLAGS)
AC_SUBST(MATECC_CAPPLETS_LIBS)

dnl =======================================
dnl Update Mime Database
dnl =======================================

AC_PATH_PROG(UPDATE_MIME_DATABASE, update-mime-database, no)

AC_ARG_ENABLE(update-mimedb,
   AS_HELP_STRING([--disable-update-mimedb],
                   [do not update mime database after installation]),,
                   enable_update_mimedb=yes)
AM_CONDITIONAL(ENABLE_UPDATE_MIMEDB, test x$enable_update_mimedb = xyes)

AC_CONFIG_FILES([
Makefile
org.mate.control-center.gschema.xml
org.mate.control-center.keybinding.gschema.xml
capplets/Makefile
capplets/about-me/Makefile
capplets/accessibility/Makefile
capplets/accessibility/at-properties/Makefile
capplets/appearance/Makefile
capplets/appearance/data/Makefile
capplets/common/Makefile
capplets/default-applications/Makefile
capplets/default-applications/mate-default-applications.pc
capplets/default-applications/icons/Makefile
capplets/display/Makefile
capplets/keybindings/Makefile
capplets/keybindings/mate-keybindings.pc
capplets/keyboard/Makefile
capplets/mouse/Makefile
capplets/system-info/Makefile
capplets/network/Makefile
capplets/time-admin/Makefile
capplets/time-admin/src/Makefile
capplets/time-admin/data/Makefile
capplets/windows/Makefile
font-viewer/Makefile
help/Makefile
man/Makefile
po/Makefile.in
shell/Makefile
typing-break/Makefile
])

dnl due to a bug in intltool we need to expand something from the root last control-center.spec
AC_OUTPUT

dnl ---------------------------------------------------------------------------
dnl - Show summary
dnl ---------------------------------------------------------------------------

echo "
Configure summary:

        ${PACKAGE_STRING}
        `echo $PACKAGE_STRING | sed "s/./=/g"`

        Compiler:                  ${CC}
        Compiler flags:            ${CFLAGS}
        Warning flags:             ${WARN_CFLAGS}
        Linker flags:              ${LDFLAGS}

        Ayatana AppIndicator (preferred)   $(test "x$enable_appindicator" = xyes && echo no || echo yes)
        Ubuntu AppIndicator (legacy)       $(test "x$enable_appindicator" = xyes && echo yes || echo no)
	Systemd:                           ${have_systemd}

        Accountsservice:           ${have_accountsservice}
        Native Language support:   ${USE_NLS}
"
