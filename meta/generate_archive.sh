#! /bin/bash

# This file is used to generate the public archive from the git repository

export SCRIPTDIRECTORY="$(dirname $(readlink -f $0))"
export BASEDIRECTORY="$(dirname $SCRIPTDIRECTORY)"

git -C "$BASEDIRECTORY" archive HEAD | bzip2 > "$SCRIPTDIRECTORY/Linux_ZedBoard.tar.bz2"

