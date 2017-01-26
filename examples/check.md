Running a basic check with the defaults.

```
./check.sh http://google.com
```

Returns the following results.

```
FAIL: http does NOT redirect to https
PASS: https returned success code
FAIL: HSTS is NOT enabled
```

If we wanted to output to a csv file we can pass the `-c` flag. Note that this is what `batch.sh` does as well as a few other processing details.

```
./check.sh -c http://google.com
```

Returns the following results.

```
google.com,www.google.com/,no,yes,no
```

If we are unclear of the reuslts we can pass the `-d` flag which will include a little more information about what exactly happened at each step.

`./check.sh -d http://google.com`

Returns the following results. Note that this shows the URL that was redirected to as well as the HTTP response code in this case '200', and any HSTS headers that were set in this case HSTS was not set.
```
FAIL: http does NOT redirect to https
INFO: (www.google.com/) http://www.google.com/

PASS: https returned success code
INFO: (www.google.com/) 200

FAIL: HSTS is NOT enabled
INFO: (www.google.com/)
```
