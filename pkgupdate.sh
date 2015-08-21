#!/usr/bin/env bash

#
# pkgupdate.sh: sample script called by pkgupdates for packages with updates when the u (or -u) flag is passed
#
#   two arguments are expected:
#       1: pkgname
#       2: upstream pkgver
#

# change to the script directory
cd "${0%/*}"

# add the name and upstream version to a text file
printf '%s\n' "$1: $2" >> packages-with-updates.txt
