#!/bin/bash

#
# File: doxygen.sh
#
# Generate Doxygen documentation from the UnivMobile Objective-C code.
#
# First param "${1}" is the location of the Doxygen config, e.g.
#     src/doxygen/doxygen.config, or target/doxygen/doxigen.config is filtered.
#
# Doxygen and dot must be installed. For instance, with Homebrew:
#     $ brew install doxygen
#     $ brew install libtool
#     $ brew install graphviz
#

DOXYGEN_CONFIG="${1}"

if [ -z "${DOXYGEN_CONFIG}" ]; then
	echo "** ERROR: DOXYGEN_CONFIG must be set as first parameter."
	echo "Exiting." 
	exit 1
fi

# ======== 1. ENVIRONMENT ========

# Update PATH so we can find doxygen and dot

export PATH="/usr/local/bin:${PATH}"

# ======== 2. BUILD ========

doxygen "${DOXYGEN_CONFIG}"

# ======== 9. END ========

echo "Done."