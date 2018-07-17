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

# Default curl options
CONNECTMAX=60;
MAXTIME=32;
CURLOPTS="--connect-timeout ${CONNECTMAX} --max-time ${MAXTIME}"

HELP=$(cat <<EOF
This script scans a given URL to check for various security details.
  1. Check that an http (non-secure) version of the URL redirects to an https
     URL.
  2. Check that the redirected https URL returns a status code in the range
     200-399 (success)
  3. Check that HSTS Strict-Transport-Security is present in the headers.

For more information please see LINKHERE

Usage: ${0} [OPTIONS] URL

Where URL is a URL you want to check and OPTIONS is one of:

  -d: Include debug information. This includes extra information about response
      data. Does nothing if -c is present.
  -h: This help message and exit.
  -c: CSV output. This is a very compact output of comma separated values
      Data is returned in the following order:
        - URL_PROVIDED: The URL provided to the script
        - URL_REDIRECTED_TO: The URL the site redirected to when requesting via
          http.
        - HTTP_REDIRECT_TO_HTTPS[yes|no]: Whether or not an HTTP request redirects to
          HTTPS.
        - HTTPS_SUCCESS[yes|no]: Whether or not an HTTPS request returned a status code
          in the range200-399.
        - HSTS_ENABLED[yes|no]: Whether or not Strict-Transport-Security headers are set.
      This mode is useful for batch calls.

Note that this script requires curl, and sed.

EOF
)

DEBUG=0
CSV=0
options='dch'
while getopts $options option; do
  case "${option}" in
    d)  DEBUG=1;;
    c)  CSV=1;;
    h)  echo "${HELP}"; exit 0;;
    :)  echo "${HELP}"; echo "Missing option argument for -${option}" >&2; exit 1;;
    *)  echo "${HELP}"; echo -e "${ERROR}Unexpected option ${option}"; exit 1;;
  esac
done
shift $(($OPTIND - 1))

# Check that we got one remaining parameter the path/url.
if [ -z "$1" ]; then
  echo -e "${ERROR}You must supply a valid URL/path to check. eg."
  echo "  ${0} https://example.com"
  echo "  ${0} example.com"
  exit 1;
fi

# Strip leading, trailing quotes and spaces and remove http(s):// if present.
path=$(echo $1 | sed -e 's/^"//' -e 's/"$//' -e 's/^//' -e 's/ $//' -e 's/https\?:\/\///')

# call output with result, message, and debug.
# Result handling:
#   'yes' is considered good (green)
#   'no' is considered bad (red)
#   anything else is flagged (yellow)
output() {
  if [ "$CSV" -eq "1" ]; then
    echo -n ",$1"
    if [ "$DEBUG" -eq "1" ]; then
      echo -n ",$3";
    fi
    return
  fi

  case $1 in
    'yes')
      echo -e "${PASS}$2"
      ;;
    'no')
      echo -e "${FAIL}$2"
      ;;
    :)
      echo -e "${UNKNOWN}$2"
      ;;
  esac
  if [ "$DEBUG" -eq "1" ]; then
    echo -e "$INFO$3\n";
  fi
}

isSuccess() {
  urlStatus=`curl  ${CURLOPTS} -s -o /dev/null -w %{http_code} $1;`
  if [ "$urlStatus" -ge "200" -a "$urlStatus" -lt "400" ]; then
    echo $urlStatus
    return 0
  else
    echo $urlStatus
    return 1
  fi
}


################################################################################
# check if http redirects to https
################################################################################
redirect=`curl ${CURLOPTS} -Ls -o /dev/null -w %{url_effective} http://$path`
# reset path to use the effective redirect URL
oldpath=$path

# If csv mode output old path and new path.
if [ "$CSV" -eq "1" ]; then
  echo -n "$oldpath,$path"
fi
path=`echo $redirect | sed 's/https\?:\/\///'`

if [[ $redirect == https* ]]; then
  output 'yes' 'http redirects to https' "${redirect}"
else
  output 'no' 'http does NOT redirect to https' "${redirect}"
fi

################################################################################
# check if https request is in 200-399 range
################################################################################
httpUrl=`isSuccess http://${path}`
if [ $? -eq 0 ]; then
  output 'yes' 'http returned success code' "${httpUrl}"
else
  output 'no' 'http did NOT return success code' "${httpUrl}"
fi

################################################################################
# check if https request is in 200-399 range
################################################################################
https=`isSuccess https://${path}`
if [ $? -eq 0 ]; then
  output 'yes' 'https returned success code' "${https}"
else
  output 'no' 'https did NOT return success code' "${https}"
fi

################################################################################
# check if http includes strict transport headers
################################################################################
hsts=`curl  ${CURLOPTS} -s -D- https://$path | grep Strict-Transport-Security`
if [[ -z "$hsts" ]]; then
  output 'no' 'HSTS is NOT enabled' "${hsts}"
else
  output 'yes' 'HSTS is enabled' "${hsts}"
fi
