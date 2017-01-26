#!/bin/bash
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

# This might not work so well on messy csv's
path=`echo $2 | awk -v x=${1} -F ',|"' '{print $x}'`

${SCRIPTPATH}/check.sh -c "${path}" && echo
