# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# This file contains everything related to gitg.

### shellcheck #################################################################

# shellcheck shell=bash # no shebang as this file is intended to be sourced
# shellcheck disable=SC2034 # multipe vars only used outside this script

### dependencies ###############################################################

# Nothing here.

### variables ##################################################################

GITG_APP_DIR=$ARTIFACT_DIR/gitg.app

GITG_APP_CON_DIR=$GITG_APP_DIR/Contents
GITG_APP_RES_DIR=$GITG_APP_CON_DIR/Resources
GITG_APP_BIN_DIR=$GITG_APP_RES_DIR/bin
GITG_APP_ETC_DIR=$GITG_APP_RES_DIR/etc
GITG_APP_EXE_DIR=$GITG_APP_CON_DIR/MacOS
GITG_APP_LIB_DIR=$GITG_APP_RES_DIR/lib

GITG_PLIST=$GITG_APP_CON_DIR/Info.plist

### functions ##################################################################

function gitg_get_version
{
  xmllint --xpath "string(//moduleset/meson[@id='gitg']/branch/@version)" \
    "$SELF_DIR"/modulesets/gitg.modules
}

function gitg_get_version_numeric
{
  local version
  version=$(gitg_get_version)

  if [ "${version:0:1}" = "v" ]; then
    echo "${version:1}"
  else
    echo "$version"
  fi
}

### main #######################################################################

# Nothing here.
