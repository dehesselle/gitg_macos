#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# Create a disk image for distribution.

### shellcheck #################################################################

# Nothing here.

### dependencies ###############################################################

#------------------------------------------------------ source jhb configuration

source "$(dirname "${BASH_SOURCE[0]}")"/jhb/etc/jhb.conf.sh

#------------------------------------------- source common functions from bash_d

# bash_d is already available (it's part of jhb configuration)

bash_d_include error

#--------------------------------------------------- source additional functions

source "$(dirname "${BASH_SOURCE[0]}")"/src/dmgbuild.sh
source "$(dirname "${BASH_SOURCE[0]}")"/src/gitg.sh

### variables ##################################################################

SELF_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1; pwd)

### functions ##################################################################

# Nothing here.

### main #######################################################################

error_trace_enable

#------------------------------------------------------------- create disk image

convert -size 460x400 xc:transparent \
  -font Andale-Mono -pointsize 64 -fill black \
  -draw "text 20,60 'Gitg'" \
  -font Andale-Mono -pointsize 30 -fill black \
  -draw "text 20,120 '$(gitg_get_version_from_git)'" \
  -draw "text 20,160 '($VERSION)'" \
  "$SRC_DIR"/gitg_dmg.png

dmgbuild_run "$ARTIFACT_DIR"/gitg.dmg
