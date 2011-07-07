#!/bin/bash
TMP=$1
NV=$2

export NV TMP
git archive --format=tar --prefix="${NV}/" --output="${TMP}/${NV}.tar" HEAD
cd `git rev-parse --show-cdup`
git submodule foreach 'FNAME=`mktemp -p /tmp rpmtarXXXXXX`;git archive --format=tar --output=$FNAME --prefix=${NV}/`basename ${path}`/ $sha1;tar -Af "${TMP}/${NV}.tar" $FNAME;rm $FNAME'
