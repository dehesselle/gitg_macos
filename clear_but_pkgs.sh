#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# Create our JHBuild-based toolset with all dependencies to be able to
# compile Inkscape.

### shellcheck #################################################################

# Nothing here.

### dependencies ###############################################################

source "$(dirname "${BASH_SOURCE[0]}")"/jhb/etc/jhb.conf.sh

### variables ###################################################################

# Nothing here.

### functions ##################################################################

# Nothing here.

### main #######################################################################

set -e

mv "$PKG_DIR" "$WRK_DIR/$(basename "$PKG_DIR")"
rm -rf "$VER_DIR"
mkdir -p "$(dirname "$PKG_DIR")"
mv "$WRK_DIR/$(basename "$PKG_DIR")" "$PKG_DIR"
