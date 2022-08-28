#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# Create the application bundle and make everything relocatable.

### shellcheck #################################################################

# Nothing here.

### dependencies ###############################################################

#------------------------------------------------------ source jhb configuration

source "$(dirname "${BASH_SOURCE[0]}")"/jhb/etc/jhb.conf.sh

#------------------------------------------- source common functions from bash_d

# bash_d is already available (it's part of jhb configuration)

bash_d_include error
bash_d_include lib

#--------------------------------------------------- source additional functions

source "$(dirname "${BASH_SOURCE[0]}")"/src/gitg.sh

### variables ##################################################################

SELF_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1; pwd)

### functions ##################################################################

# Nothing here.

### main #######################################################################

error_trace_enable

#----------------------------------------------------- create application bundle

( # run gtk-mac-bundler

  cp "$SRC_DIR"/gitg-"$(gitg_get_version)"/osx/data/Gitg.icns  "$TMP_DIR"
  cp "$SRC_DIR"/gitg-"$(gitg_get_version)"/osx/data/Info.plist "$TMP_DIR"
  cp "$SELF_DIR"/gitg.bundle "$TMP_DIR"

  cd "$WRK_DIR" || exit 1
  export ARTIFACT_DIR=$ARTIFACT_DIR   # referenced in gitg.bundle
  jhbuild run gtk-mac-bundler "$TMP_DIR"/gitg.bundle
)

lib_change_siblings "$GITG_APP_LIB_DIR"

#------------------------------------------------------------- update Info.plist

# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html

/usr/libexec/PlistBuddy -c "Delete CFBundleGetInfoString" "$GITG_PLIST"
/usr/libexec/PlistBuddy -c "Set NSHumanReadableCopyright \
  'Copyright 2012 Jesse van den Kieboom, GNU General Public License.'" \
  "$GITG_PLIST"

/usr/libexec/PlistBuddy -c \
  "Add XXGitDescribe string '$(gitg_get_version_from_git)'" "$GITG_PLIST"
# No alphanumeric characters allowed, so we turn the version number into
# major.minor.patch.number_of_commits_since_tag
/usr/libexec/PlistBuddy -c \
  "Set CFBundleShortVersionString \"$(gitg_get_version)\"" "$GITG_PLIST"
/usr/libexec/PlistBuddy -c \
  "Set CFBundleVersion '$BUILD_NUMBER'" "$GITG_PLIST"  # value from CI
/usr/libexec/PlistBuddy -c \
  "Set LSMinimumSystemVersion '$SYS_SDK_VER'" "$GITG_PLIST"

/usr/libexec/PlistBuddy -c "Set CFBundleDisplayName 'Gitg'" "$GITG_PLIST"
/usr/libexec/PlistBuddy -c "Set CFBundleName 'Gitg'" "$GITG_PLIST"

/usr/libexec/PlistBuddy -c "Add LSApplicationCategoryType string \
  'public.app-category.developer-tools'" "$GITG_PLIST"

# enable dark mode (menubar only, GTK theme is reponsible for the rest)
/usr/libexec/PlistBuddy -c \
  "Add NSRequiresAquaSystemAppearance bool 'false'" "$GITG_PLIST"

/usr/libexec/PlistBuddy -c "Add NSDesktopFolderUsageDescription string \
  'Gitg needs your permission to access the Desktop folder.'" "$GITG_PLIST"
/usr/libexec/PlistBuddy -c "Add NSDocumentsFolderUsageDescription string \
  'Gitg needs your permission to access the Documents folder.'" "$GITG_PLIST"
/usr/libexec/PlistBuddy -c "Add NSDownloadsFolderUsageDescription string \
  'Gitg needs your permission to access the Downloads folder.'" "$GITG_PLIST"
/usr/libexec/PlistBuddy -c "Add NSRemoveableVolumesUsageDescription string \
  'Gitg needs your permission to access removable volumes.'" "$GITG_PLIST"

# add GitHUB CI information
if $CI_GITHUB; then
  for var in REPOSITORY REF RUN_NUMBER SHA; do
    # use awk to create camel case strings (e.g. RUN_NUMBER to RunNumber)
    /usr/libexec/PlistBuddy -c "Add CI$(\
      echo $var | awk -F _ '{
        for (i=1; i<=NF; i++)
        printf "%s", toupper(substr($i,1,1)) tolower(substr($i,2))
      }'
    ) string $(eval echo \$GITHUB_$var)" "$GITG_PLIST"
  done
fi

# add supported languages
/usr/libexec/PlistBuddy -c "Add CFBundleLocalizations array" "$GITG_PLIST"
for locale in "$SRC_DIR"/gitg-*/po/*.po; do
  if [ "$locale" = "en_GB" ]; then
    locale="en"
  fi
  /usr/libexec/PlistBuddy -c \
    "Add CFBundleLocalizations: string '$(basename -s .po $locale)'" \
    "$GITG_PLIST"
done
