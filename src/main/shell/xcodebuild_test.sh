#!/bin/bash

#
# File: xcodebuild-test.sh
#
# This script must be run on a Mac OS X system with Xcode installed.
# It aims at running the iOS logic tests of "unm-ios", and export the test
# results to an other git repository, named alike, "unm-integration" GitHub
# repository (subfolder: unm-ios-ut-results).
# ("-ut-" means: "Unit Tests")
#
# The script works like this:
#
#  1. Run "xcodebuild test" to run the XCTest suites from the project,
#       capturing the standard output and error into a file.
#
#  4. Once this is done, add the test results file to another GitHub repository,
#       "unm-integration" (subfolder: unm-iot-ut-results),
#       commit and push to GitHub.
#
# Parameters:
#    "${1}": APP_REPO: Where to put the .app archive.
#               Defaults to /var/xcodebuild_test-apps/ 
#

# ======== 1. ENVIRONMENT ========

UNM_IOS_REPO="$(cd "$(dirname "${0}")/../../../"; pwd)"

APP_REPO="${1}"

if [ -z "${APP_REPO}" ]; then
	APP_REPO=/var/xcodebuild_test-apps
fi

# ======== 1.1. ENVIRONMENT: WORKSPACE ========

WORKSPACE="${UNM_IOS_REPO}"

echo "WORKSPACE: ${WORKSPACE}"

BUILD_LOG="${WORKSPACE}/target/xcodebuild_test.log"
CMD_FILE="${WORKSPACE}/target/xcodebuild_test_cmd.sh"
TEST_REPORT_REPO="${WORKSPACE}/target/unm-integration/"
TEST_REPORT="${TEST_REPORT_REPO}/unm-ios-ut-results/data/xcodebuild_test.log"

if [ ! -d "${WORKSPACE}/target" ]; then mkdir -p "${WORKSPACE}/target"; fi

# ======== 1.2. ENVIRONMENT: TEST_REPORT ========

rm -rf "${TEST_REPORT_REPO}"

# TODO test_report_repo is being pulled before the tests, during which someone
# else would be able to perform commits to the git repo. Then, when this script
# attempts to push after the tests were run, a conflict may occur.
# A better approach would be to: 
# 1. check that test_report_repo is a git repo (OK with that)
# 2. rm test_report_repo
# 3. save test_report_tmp during tests
# 4. git clone test_report_repo
# 5. cp test_report_tmp (elsewhere) into test_report (in test_report_repo)
# 6. commit && push 
 
git clone https://dandriana-jenkins@github.com/univmobile/unm-integration "${TEST_REPORT_REPO}"

if [ -z "${TEST_REPORT}" ]; then
  echo "** Error: TEST_REPORT must be set and must be in a git repo. e.g. ../unm-ios-test-results/data/unm-ios-xcodebuild-test.log"
  echo "Exiting"
  exit 1
fi

if ! cd "$(dirname "${TEST_REPORT}")"; then
  echo "** Error: Cannot find parent dir for: ${TEST_REPORT}" >&2 
  echo "Exiting"
  exit 1
fi

TEST_REPORT="$(pwd)/$(basename "${TEST_REPORT}")"

echo "pwd: $(pwd)" >> "${BUILD_LOG}"

git status  >> "${BUILD_LOG}" 2>&1
if [ $? -ne 0 ]; then
  echo "** Error: TEST_REPORT=${TEST_REPORT} is not in a git repo. e.g. ../unm-ios-test-results/data/unm-ios-xcodebuild-test.log"
  echo "Exiting"
  exit 1
fi

echo "TEST_REPORT: ${TEST_REPORT}"

# ======== 1.3. ENVIRONMENT: TEST_REPORT_REPO AND OTHERS ========

touch "${CMD_FILE}"
    
chmod +x "${CMD_FILE}"

echo "CURRENT_DIR=UNM_IOS_REPO: $(pwd)"

# ======== 2. BUILD COMMAND ========

cd "${UNM_IOS_REPO}"

BUILD_OPTS="-workspace UnivMobile.xcworkspace \
  -scheme UnivMobileTests \
  -configuration Debug \
  -sdk iphonesimulator7.1 \
  -destination OS=7.1,name=\"iPhone Retina (4-inch)\""
BUILD_CMD="/usr/bin/xcodebuild clean build ${BUILD_OPTS}"  
TEST_CMD="/usr/bin/xcodebuild test ${BUILD_OPTS}"

# ======== 3. TEST REPORT INITIALIZATION ========

GIT_COMMIT="$(git rev-parse HEAD)"

SEP="----------------------------------------"

echo "Begin Date: $(date)" > "${TEST_REPORT}"
echo "Hostname: $(hostname)" >> "${TEST_REPORT}"
echo "User: ${USER}" >> "${TEST_REPORT}"
echo "Script: $(basename "${0}") ${1} ${2}" >> "${TEST_REPORT}"
echo "Current Directory: $(pwd)" >> "${TEST_REPORT}"
echo "Test Report: ${TEST_REPORT}" >> "${TEST_REPORT}"
echo "Git Commit: $GIT_COMMIT" >> "${TEST_REPORT}" 
echo "Test Command: ${TEST_CMD}" >> "${TEST_REPORT}"
echo "${SEP}" >> "${TEST_REPORT}"

echo >> "${TEST_REPORT}"

# ======== 4. EMBED BUILD INFO IN PLIST ========

PLIST="${UNM_IOS_REPO}/UnivMobile/UnivMobile-Info.plist"

BUILD_ID=`date "+%Y-%m-%d %H:%M:%S"`
APP_ID=`date "+%Y%m%d-%H%M%S"`

/usr/libexec/Plistbuddy -c "Add BUILD_DISPLAY_NAME string '#(test)'" "${PLIST}" 
/usr/libexec/Plistbuddy -c "Add BUILD_ID string '${BUILD_ID}'" "${PLIST}" 
/usr/libexec/Plistbuddy -c "Add BUILD_NUMBER string '(test)'" "${PLIST}"
/usr/libexec/Plistbuddy -c "Add GIT_COMMIT string '${GIT_COMMIT}'" "${PLIST}" 

# ======== 5. RUN ========

echo "Building..."

echo "${BUILD_CMD}"
echo "${BUILD_CMD}" > "${CMD_FILE}"    
echo "${BUILD_CMD}" >> "${BUILD_LOG}"

# "${CMD_FILE}" >> "${TEST_REPORT}" 2>&1 // xcodebuild clean build

"${CMD_FILE}" // xcodebuild clean build

RET=$?

if [ "${RET}" -ne 0 ]; then

  echo "** Error: \"xcodebuild clean build\" failed with return code: ${RET}" | tee -a "${TEST_REPORT}"

else

  echo >> "${TEST_REPORT}"

  echo "Build succeeded." >> "${TEST_REPORT}"
  echo "Test Date: $(date)" >> "${TEST_REPORT}"      
  echo "${SEP}" >> "${TEST_REPORT}"
  
  echo "Testing..."

  echo "${TEST_CMD}"
  echo "${TEST_CMD}" > "${CMD_FILE}"    
  echo "${TEST_CMD}" >> "${BUILD_LOG}"

  "${CMD_FILE}" >> "${TEST_REPORT}" 2>&1 // xcodebuild test

fi

# ======== 5. TEST REPORT FINALIZATION ========

echo "${SEP}" >> "${TEST_REPORT}" 
echo "End Date: $(date)" >> "${TEST_REPORT}"

# ======== 6. TEST REPORT GIT COMMIT ========

cd "${TEST_REPORT_REPO}"

TEST_REPORT_FILENAME="unm-ios-ut-results/data/$(basename "${TEST_REPORT}")"

mkdir -p target/

export GIT_ASKPASS="${TEST_REPORT_REPO}/target/git_askpass.sh"

echo "cat ~/.config/github-dandriana-jenkins" > "${GIT_ASKPASS}"

chmod 700 "${GIT_ASKPASS}"

git add "${TEST_REPORT_FILENAME}"

git commit -m "xcodebuild test, git commit (unm-ios): ${GIT_COMMIT}" "${TEST_REPORT_FILENAME}"

git push

# ======== 7. ALLOW ACCESS TO LOCAL DEBUG-IPHONESIMULATOR APP ========

# e.g. /Users/avcompris/Library/Developer/Xcode/DerivedData/UnivMobile-bthazihbxymfelcqywwhsugbfzmd/

DERIVED_DATA=`grep PhaseScriptExecution "${TEST_REPORT_FILENAME}" | head -1 | grep -o [^\ ]*UnivMobile-[^/]*/`

APP_PATH="${DERIVED_DATA}/Build/Products/Debug-iphonesimulator/UnivMobile.app"

APP_DEST="${APP_REPO}/UnivMobile-${APP_ID}.app"

# touch /var/xcodebuild_test-apps/touched_after_lastcp after we copy the
# UnivMobile.app directory, so other users can now our UnivMobile.app, updated
# before the touched_after_lastimport file, is valid.

if cp -r "${APP_PATH}" "${APP_DEST}"; then

	if chmod -R a+r "${APP_DEST}"; then
	
		touch "${APP_REPO}/touched_after_lastimport"
		
		echo "UnivMobile.app copied to public directory: ${APP_DEST}"
	fi
fi

