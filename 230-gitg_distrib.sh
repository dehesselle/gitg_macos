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

# shellcheck disable=SC1090 # can't point to a single source here
for script in "$(dirname "${BASH_SOURCE[0]}")"/0??-*.sh; do
  source "$script";
done

### variables ##################################################################

# Nothing here.

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
