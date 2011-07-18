#!/bin/bash
# this script helps to work around the fact that git-archive doesn't support
# submodules. It will create a tar of the current tree and then create a tar
# for each immediate submodule and add that to the main tar.
# For a more generalised solution you will have to adapt the prefixes.

TMP=$1
NV=$2
BASEPATH=`git rev-parse --show-prefix`

# export variables so they'll be available in sub commands
export NV TMP BASEPATH

# first create an archive of the main tree. git-archive creates the archives
# from the current location downward.
git archive --format=tar --prefix="${NV}/" --output="${TMP}/${NV}.tar" HEAD
cd `git rev-parse --show-cdup`
# now create a tar for each submodule and add it to the main tar
git submodule foreach 'FNAME=`mktemp -p /tmp rpmtarXXXXXX`;git archive --format=tar --output=$FNAME --prefix=${NV}/`echo ${path} | sed -e "s#$BASEPATH##"`/ $sha1;tar -Af "${TMP}/${NV}.tar" $FNAME;rm $FNAME'
