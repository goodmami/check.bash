check.bash
=========

Bash scripts to verify directory structure, file permissions, command output, etc.

### Features ###

* Checker scripts are easy to read and write (see below for an example)
* Feedback is color coded for user convenience
* Commands for standard checks are provided, others can be easily created
* any() and all() functions allow for useful handling of multiple conditions
* Checks use standard error codes (non-zero represents a problem), so command chaining is possible

### Examples ###

This is how you use check.bash (set cbdir to the appropriate path):

```bash
#!/bin/bash
cbdir=.
source "$cbdir/check.bash"
# verify the file we just loaded still exists:
exist "$cbdir/check.bash"
```
