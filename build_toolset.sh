#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# Create our JHBuild-based toolset with all dependencies to be able to
# compile Inkscape.

### includes ###################################################################

# shellcheck disable=SC1090 # can't point to a single source here
for script in "$(dirname "${BASH_SOURCE[0]}")"/0??-*.sh; do
  source "$script";
done

### settings ###################################################################

set -e   # break if one of the called scripts ends in error

### main #######################################################################

for script in "$SELF_DIR"/1??-*.sh; do
  $script
done
