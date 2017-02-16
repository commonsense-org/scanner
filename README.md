# check.sh
This script scans a given URL to check for various security details.
  1. Check that an http (non-secure) version of the URL redirects to an https
     URL.
  2. Check that the redirected https URL returns a status code in the range
     200-399 (success)
  3. Check that HSTS Strict-Transport-Security is present in the headers.

For more information please see [these examples](examples/check.md).

Usage: ./check.sh [OPTIONS] URL

Where URL is a URL you want to check and OPTIONS is one of:
```
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
```
Note that this script requires curl, and sed.


# batch.sh

This script is used to batch call the check script in this package. It is
intended to be passed a csv file of URLs/paths to check.

For more information please see [these examples](examples/batch.md).

Usage: ./batch.sh [OPTIONS] CSVFILE

Where CSVFILE is a CSV file containing a column of URLs to check.
```
  -f: Indicate which column in the csv contains the URLs to check. Default 1
  -c: Indicates how many concurrent connections. Default 8
  -k: Keep same order. Default no
  -h: This help message and exit.
```
Note that this script requires parallel, and awk.

# shim.sh

This is a trivial helper script used by batch.sh to parse csv data and call check.sh.

# License
MIT License

Copyright (c) 2017 Common Sense
