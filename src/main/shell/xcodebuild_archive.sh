#!/bin/bash

#
# File: xcodebuild_archive.sh
#
# This script must be run on a Mac OS X system with Xcode installed.
# It builds the UnivMobile iOS archive, and export it under the form of an
# UNivMobile.ipa file.
# Note that, by design, this script only runs with Xcode 5.1.1. This is to
# ensure it only runs on the "macos" slave of our Continuous Integration
# architecture, not on the "macos_ios6" one.
#

# ======== 0. ENVIRONMENT ========

PLIST=UnivMobile/UnivMobile-Info.plist

KEYCHAIN=/Users/dandriana/Library/Keychains/MyKeichain.keychain
KEYCHAIN_PASS=`cat /Users/dandriana/.config/security-unlock-keychain-MyKeichain`
PROVISIONING_PROFILE=UnivMobileAlphaProfile

PLATFORM_VERSION=7.1

XCODE_VERSION=`xcodebuild -version | head -1`

# ======== 1. VALIDATION ========

if [ "${XCODE_VERSION}" != "Xcode 5.1.1" ]; then 
	echo "** Xcode is not 5.1.1: ${XCODE_VERSION}"
	echo "Exiting."
	exit 1 
fi

if [ "${HOSTNAME}" != "unm-temp2.local" ]; then
	echo "** Hostname is not unm-temp2.local: ${HOSTNAME}"
	echo "Exiting."
	exit 1 
fi

# ======== 2. CLEAN UP OLD BUILD ========

mkdir -p build/

rm -f build/UnivMobile.ipa

git checkout "${PLIST}" # Clean up any old Build Info in UnivMobile-Info.plist

if grep -q GIT_COMMIT "${PLIST}"; then
	echo "** Error: GIT_COMMIT already present in UnivMobile-Info.plist"
	echo "Exiting."
	exit 1
fi

# ======== 3. SET BUILD INFO ========

/usr/libexec/Plistbuddy -c "Add BUILD_DISPLAY_NAME string '${BUILD_DISPLAY_NAME}'" "${PLIST}"
/usr/libexec/Plistbuddy -c "Add BUILD_ID string '${BUILD_ID}'" "${PLIST}" 
/usr/libexec/Plistbuddy -c "Add BUILD_NUMBER string '${BUILD_NUMBER}'" "${PLIST}" 
/usr/libexec/Plistbuddy -c "Add GIT_COMMIT string '${GIT_COMMIT}'" "${PLIST}" 

# ======== 4. UNLOCK KEYCHAIN ========

security unlock-keychain -p "${KEYCHAIN_PASS}" "${KEYCHAIN}"

# ======== 5. XCODEBUILD ARCHIVE ========

xcodebuild -workspace UnivMobile.xcworkspace -scheme UnivMobile clean archive

# ======== 6. RETRIEVE ARCHIVE INFO ========

. build/archive_paths.sh

# ======== 7. XCODEBUILD EXPORT ========

xcodebuild -exportArchive -exportFormat IPA -archivePath "${ARCHIVE_PATH}" \
  -exportPath build/UnivMobile.ipa \
  -exportProvisioningProfile "${PROVISIONING_PROFILE}"
  

