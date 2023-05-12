#!/bin/bash
set -x

SCRIPTDIR=$(pwd -P)

export SRCROOT=$(cd "$SCRIPTDIR/../.." && pwd)
export ARCHS="x86_64 i386 arm64 arm ppc"
export DERIVED_FILES_DIR="$SRCROOT/generated/derived"
export VARIANT_PLATFORM_NAME="macosx"

mkdir -p $DERIVED_FILES_DIR
cp ../assets/libc-features.h $DERIVED_FILES_DIR

$SRCROOT/xcodescripts/generate_features.pl
