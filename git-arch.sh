#!/bin/bash
TMP=$1
NV=$2

export NV TMP
echo "NV: $NV / TMP: $TMP"
git archive --format=tar --prefix="${NV}" --output="${TMP}/${NV}.tar" HEAD
cd `git rev-parse --show-cdup`
git submodule --quiet foreach 'FNAME=`mktemp -p /tmp`;git archive --format=tar --output=$FNAME --prefix=${path}/ $sha1;tar -Af "${TMP}/${NV}.tar" $FNAME;rm $FNAME'
