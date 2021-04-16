#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# Create the application bundle. This also includes patching library link
# paths and all other components that we need to make relocatable.

### includes ###################################################################

# shellcheck disable=SC1090 # can't point to a single source here
for script in "$(dirname "${BASH_SOURCE[0]}")"/0??-*.sh; do
  source "$script";
done

### settings ###################################################################

# shellcheck disable=SC2034 # this is from ansi_.sh
ANSI_TERM_ONLY=false   # use ANSI control characters even if not in terminal

error_trace_enable

### main #######################################################################

#----------------------------------------------------- create application bundle

( # run gtk-mac-bundler

  cp "$SELF_DIR"/gitg.bundle "$WRK_DIR"
  cp "$SELF_DIR"/gitg.plist "$WRK_DIR"

  cd "$WRK_DIR" || exit 1
  export ARTIFACT_DIR=$ARTIFACT_DIR   # referenced in gitg.bundle
  jhbuild run gtk-mac-bundler gitg.bundle
)

lib_change_siblings "$GITG_APP_LIB_DIR"

exit 0

# patch library link paths for lib2geom
lib_change_path \
  @executable_path/../Resources/lib/libgit2-glib-1.0.0.dylib \
  "$GITG_APP_EXE_DIR"/gitg

exit 0
