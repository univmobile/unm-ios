#!/bin/sh

# Run this script once a day on unm_ios6a, because the iPhone Simulator temp
# dir is filling very fast (10 Go/week).
# Don't forget to run a command like "xcodebuild -showsdks" to check that
# xcrun works fine. Otherwise, remove the corrupted cache.
 
DIR=~/Library/Application\ Support/iPhone\ Simulator/6.1/tmp/

echo "Cleaning up: ${DIR}..."

ls -t1 "${DIR}" | tail -n +10 | while read i; do
	rm "${DIR}/${i}"
done 

echo "Done."