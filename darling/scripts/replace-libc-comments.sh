#!/bin/bash
set -x

SCRIPTDIR=$(pwd -P)
SRCROOT=$(cd "$SCRIPTDIR/../.." && pwd)
GEN_DIR="$SRCROOT/generated"

pushd "${SRCROOT}/include"
for i in `find . -name \*.h -print0 | xargs -0 grep -l '^//Begin-Libc'`; do
	mkdir -p "$GEN_DIR/private-include/$(dirname $i)"
	cp "$i" "$GEN_DIR/private-include/$i"
	ed - "$i" < "${SRCROOT}/xcodescripts/strip-header.ed"
	#sed -i '' -e 's/\/\/Begin-Libc/\#ifdef BUILDING_LIBC/g; s/\/\/End-Libc/\#endif \/\/ BUILDING_LIBC/g' "$i"
done
popd
