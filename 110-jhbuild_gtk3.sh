#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# Build GTK3 libraries and their dependencies.

### shellcheck #################################################################

# Nothing here.

### dependencies ###############################################################

#------------------------------------------------------ source jhb configuration

source "$(dirname "${BASH_SOURCE[0]}")"/jhb/etc/jhb.conf.sh

### variables ##################################################################

SELF_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1; pwd)

### functions ##################################################################

# Nothing here.

### main #######################################################################

"$SELF_DIR"/jhb/usr/bin/bootstrap

jhb configure "$SELF_DIR"/modulesets/gitg.modules

jhb build \
  libxml2 \
  pygments \
  python3

jhb build \
  meta-gtk-osx-bootstrap \
  meta-gtk-osx-gtk3
