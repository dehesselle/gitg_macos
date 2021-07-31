#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
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

  cp $SRC_DIR/gitg-$(gitg_get_version)/osx/data/Gitg.icns  $TMP_DIR
  cp $SRC_DIR/gitg-$(gitg_get_version)/osx/data/Info.plist $TMP_DIR
  cp "$SELF_DIR"/gitg.bundle "$TMP_DIR"

  cd "$WRK_DIR" || exit 1
  export ARTIFACT_DIR=$ARTIFACT_DIR   # referenced in gitg.bundle
  jhbuild run gtk-mac-bundler $TMP_DIR/gitg.bundle
)

lib_change_siblings "$GITG_APP_LIB_DIR"

#------------------------------------------------------------- update Info.plist

# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html

/usr/libexec/PlistBuddy -c "Delete CFBundleGetInfoString" "$GITG_PLIST"
/usr/libexec/PlistBuddy -c "Set NSHumanReadableCopyright \
  'Copyright 2012 Jesse van den Kieboom, GNU General Public License.'" \
  "$GITG_PLIST"

/usr/libexec/PlistBuddy -c \
  "Set CFBundleShortVersionString '$(gitg_get_version)'" "$GITG_PLIST"
/usr/libexec/PlistBuddy -c \
  "Set CFBundleVersion '$(gitg_get_version).$GITG_RELEASE'" "$GITG_PLIST"
/usr/libexec/PlistBuddy -c \
  "Set LSMinimumSystemVersion '$SYS_SDK_VER'" "$GITG_PLIST"

/usr/libexec/PlistBuddy -c "Delete CFBundleDisplayName" "$GITG_PLIST"
/usr/libexec/PlistBuddy -c "Set CFBundleName 'Gitg'" "$GITG_PLIST"

/usr/libexec/PlistBuddy -c "Add LSApplicationCategoryType string \
  'public.app-category.developer-tools'" "$GITG_PLIST"

/usr/libexec/PlistBuddy -c "Add NSDesktopFolderUsageDescription string \
  'Gitg needs your permission to access the Desktop folder.'" "$GITG_PLIST"
/usr/libexec/PlistBuddy -c "Add NSDocumentsFolderUsageDescription string \
  'Gitg needs your permission to access the Documents folder.'" "$GITG_PLIST"
/usr/libexec/PlistBuddy -c "Add NSDownloadsFolderUsageDescription string \
  'Gitg needs your permission to access the Downloads folder.'" "$GITG_PLIST"
/usr/libexec/PlistBuddy -c "Add NSRemoveableVolumesUsageDescription string \
  'Gitg needs your permission to access removable volumes.'" "$GITG_PLIST"

#------------------------------------------------------- add GitHub CI variables

if $CI; then
  for var in REPOSITORY REF RUN_NUMBER SHA; do
    # use awk to create camel case strings (e.g. RUN_NUMBER to RunNumber)
    /usr/libexec/PlistBuddy -c "Add CI$(\
      echo $var | awk -F _ '{
        for (i=1; i<=NF; i++)
        printf "%s", toupper(substr($i,1,1)) tolower(substr($i,2))
      }'
    ) string $(eval echo \$GITHUB_$var)" "$GITG_APP_CON_DIR"/Info.plist
  done
fi

exit 0

# patch library link paths for lib2geom
lib_change_path \
  @executable_path/../Resources/lib/libgit2-glib-1.0.0.dylib \
  "$GITG_APP_EXE_DIR"/gitg

exit 0
