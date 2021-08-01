# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# This file contains everything related to gitg.

### settings ###################################################################

# shellcheck shell=bash # no shebang as this file is intended to be sourced
# shellcheck disable=SC2034 # no exports desired

### variables ##################################################################

GITG_RELEASE=r2
GITG_REPO_URL=https://gitlab.gnome.org/GNOME/gitg.git

#------------------------------------------- application bundle directory layout

GITG_APP_DIR=$ARTIFACT_DIR/gitg.app

GITG_APP_CON_DIR=$GITG_APP_DIR/Contents
GITG_APP_RES_DIR=$GITG_APP_CON_DIR/Resources
GITG_APP_FRA_DIR=$GITG_APP_CON_DIR/Frameworks
GITG_APP_BIN_DIR=$GITG_APP_RES_DIR/bin
GITG_APP_ETC_DIR=$GITG_APP_RES_DIR/etc
GITG_APP_EXE_DIR=$GITG_APP_CON_DIR/MacOS
GITG_APP_LIB_DIR=$GITG_APP_RES_DIR/lib

GITG_PLIST=$GITG_APP_CON_DIR/Info.plist

### functions ##################################################################

function gitg_get_version
{
  xmllint --xpath "string(//moduleset/meson[@id='gitg']/branch/@version)" \
    "$SELF_DIR"/jhbuild/gitg.modules
}

function gitg_get_version_from_git
{
  local repo=$TMP/gitg

  if [ ! -d "$repo" ]; then
    git clone $GITG_REPO_URL "$repo" >/dev/null 2>&1
  fi

  git -C "$repo" checkout "$(gitg_get_version)" >/dev/null 2>&1
  git -C "$repo" describe
}
