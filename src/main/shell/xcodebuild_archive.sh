#!/bin/bash

#
# File: xcodebuild_archive.sh
#
# This script must be run on a Mac OS X system with Xcode installed.
# It builds the UnivMobile iOS archive, and export it under the form of an
# UNivMobile.ipa file.
#

# 0. ENVIRONMENT

PLIST=UnivMobile/UnivMobile-Info.plist

KEYCHAIN=/Users/dandriana/Library/Keychains/MyKeichain.keychain
KEYCHAIN_PASS=`cat /Users/dandriana/.config/security-unlock-keychain-MyKeichain`
PROVISIONING_PROFILE_UnivMobileAlphaProfile

# 1. CLEAN UP OLD BUILD

mkdir -p build/

rm -f build/UnivMobile.ipa

git checkout "${PLIST}" # Clean up any old Build Info in UnivMobile-Info.plist

# 2. SET BUILD INFO

/usr/libexec/Plistbuddy -c "Add BUILD_DISPLAY_NAME string '${BUILD_DISPLAY_NAME}'" "${PLIST}"
/usr/libexec/Plistbuddy -c "Add BUILD_ID string '${BUILD_ID}'" "${PLIST}" 
/usr/libexec/Plistbuddy -c "Add BUILD_NUMBER string '${BUILD_NUMBER}'" "${PLIST}" 
/usr/libexec/Plistbuddy -c "Add GIT_COMMIT string '${GIT_COMMIT}'" "${PLIST}" 

# 3. UNLOCK KEYCHAIN

security unlock-keychain -p "${KEYCHAIN_PASS}" "${KEYCHAIN}"

# 4. XCODEBUILD ARCHIVE

xcodebuild -workspace UnivMobile.xcworkspace -scheme UnivMobile clean archive

# 5. RETRIEVE ARCHIVE INFO

. build/archive_paths.sh

# 6. XCODE EXPORT

xcodebuild -exportArchive -exportFormat IPA -archivePath "${ARCHIVE_PATH}" \
  -exportPath build/UnivMobile.ipa \
  -exportProvisioningProfile "${PROVISIONING_PROFILE}"
  

