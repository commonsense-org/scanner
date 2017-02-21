#!/bin/bash

# Output constants
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
NC='\033[0m'
FAIL="${RED}FAIL: ${NC}"
ERROR="${RED}ERROR: ${NC}"
PASS="${GREEN}PASS: ${NC}"
INFO="${BLUE}INFO: ${NC}"
UNKNOWN="${YELLOW}UNKNOWN: ${NC}"

pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

# Default settings
COLUMN=1
CONCURRENCY=8
ORDER=""

HELP=$(cat <<EOF
This script is used to batch call the check script in this package. It is
intended to be passed a csv file of URLs/paths to check.

Usage: ${0} [OPTIONS] CSVFILE

Where CSVFILE is a CSV file containing a column of URLs to check.

  -f: Indicate which column in the csv contains the URLs to check. Default ${COLUMN}
  -c: Indicates how many concurrent connections. Default ${CONCURRENCY}
  -k: Keep same order. Default no
  -h: This help message and exit.

Note that this script requires parallel, and awk.

EOF
)


options='c:f:hk'
while getopts $options option; do
  case "${option}" in
    c)  CONCURRENCY=${OPTARG};;
    f)  COLUMN=${OPTARG};;
    h)  echo "${HELP}"; exit 0;;
    k)  ORDER="-k";;
    :)  echo "${HELP}"; echo "Missing option argument for -${option}" >&2; exit 1;;
    *)  echo "${HELP}"; echo -e "${ERROR}Unexpected option ${option}"; exit 1;;
  esac
done
shift $(($OPTIND - 1))

# Check that we got one remaining parameter the path/url.
if [[ -d $1 ]]; then
  echo -e "${ERROR}You must supply a valid csv file to check. eg. ${0} urls.csv"
  exit 1;
fi
# Strip leading, trailing quotes and spaces and remove http(s):// if present.
csvfile=$1

parallel -j+${CONCURRENCY} ${ORDER} -a ${csvfile} "${SCRIPTPATH}/shim.sh ${COLUMN}"
