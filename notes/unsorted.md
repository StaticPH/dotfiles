# As a general rule, there is no functional benefit to deduplicating PATH entries
The shell will ignore the second and subsequent occurrences of a duplicate path.

# locale-purge files

## /etc/locale.gen
* The only uncommented, non-blank line needed is the line with `en_US.UTF-8 UTF-8`

## /etc/locale.nopurge
Settings to uncomment:
* `USE_DPKG`    (obviously, shouldn't be relevant to systems without dpkg)
* `MANDELETE`
* `DONTBOTHERNEWLOCALE`
* `SHOWFREEDSPACE`
Leave commented out:
* `QUICKNDIRTYCALC`
* `VERBOSE`

File should end with (including the newline): ```
#####################################################
# Following locales won't be deleted from this system
# after package installations done with apt-get(8):

en
en_US
en_US.ISO-8859-15
en_US.UTF-8
```
# /etc/environment.d/90qt-a11y.conf
`QT_ACCESSIBILITY=1`
* This variable is also commonly set by one of the startup scripts in `/etc/X11/Xsession.d/`,
e.g. `/etc/X11/Xsession.d/90qt-a11y`: ```sh
# -*- sh -*-
# Xsession.d script to set the env variables to enable accessibility for Qt
#
# This file is sourced by Xsession(5), not executed.

QT_ACCESSIBILITY=1

export QT_ACCESSIBILITY

if [ -x "/usr/bin/dbus-update-activation-environment" ]; then
        dbus-update-activation-environment --verbose --systemd QT_ACCESSIBILITY
fi
```
# Homebrew analytics
Disable analytics for the `brew` package manager by exporting `HOMEBREW_NO_ANALYTICS=1`
