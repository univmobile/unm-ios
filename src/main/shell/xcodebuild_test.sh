#!/bin/bash

# TODO remove the corresponding code in macos_job-xcodebuild_test.sh

#
# File: xcodebuild-test.sh
#
# This script must be run on a Mac OS X system with Xcode installed.
# It aims at running the iOS logic tests of "unm-ios", and export the test
# results to an other git repositoru, named alike, "unm-ios-ut-results" GitHub
# repository.
# ("-ut-" means: "Unit Tests")
#
# The script works like this:
#
#  1. Run "xcodebuild test" to run the XCTest suites from the project,
#       capturing the standard output and error into a file.
#
#  4. Once this is done, add the test results file to another GitHub repository,
#       "unm-ios-ut-results", commit and push to GitHub.
#

# ======== 1. ENVIRONMENT ========

UNM_IOS_REPO="$(cd "$(dirname "${0}")/../../../"; pwd)"

# ======== 1.1. ENVIRONMENT: WORKSPACE ========

WORKSPACE="${UNM_IOS_REPO}"

echo "WORKSPACE: ${WORKSPACE}"

BUILD_LOG="${WORKSPACE}/target/xcodebuild_test.log"
CMD_FILE="${WORKSPACE}/target/xcodebuild_test_cmd.sh"
TEST_REPORT_REPO="${WORKSPACE}/target/unm-ios-ut-results"
TEST_REPORT="${TEST_REPORT_REPO}/data/xcodebuild_test.log"

if [ ! -d "${WORKSPACE}/target" ]; then mkdir -p "${WORKSPACE}/target"; fi

# ======== 1.2. ENVIRONMENT: TEST_REPORT ========

rm -rf "${TEST_REPORT_REPO}"

git clone https://github.com/univmobile/unm-ios-ut-results "${TEST_REPORT_REPO}"

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
echo "Script: $(basename "${0}") ${1} ${2}" >> "${TEST_REPORT}"
echo "Current Directory: $(pwd)" >> "${TEST_REPORT}"
echo "Test Report: ${TEST_REPORT}" >> "${TEST_REPORT}"
echo "Git Commit: $GIT_COMMIT" >> "${TEST_REPORT}" 
echo "Test Command: ${TEST_CMD}" >> "${TEST_REPORT}"
echo "${SEP}" >> "${TEST_REPORT}"

echo >> "${TEST_REPORT}"

# ======== 4. RUN ========

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

TEST_REPORT_FILENAME="data/$(basename "${TEST_REPORT}")"

git add "${TEST_REPORT_FILENAME}"

git commit -m "xcodebuild test, git commit: ${GIT_COMMIT}" "${TEST_REPORT_FILENAME}"

git push

