
# For console output, warn() prints in red and laud() prints in green.
# Further, warn has a non-zero return code to help with chaining checks
warn() { echo -e "\e[0;31m$1\e[0m"; return 1; }
laud() { echo -e "\e[0;32m$1\e[0m"; return 0; }

# quantifier functions:
# any:
#   first arg is the function, the rest are parameters
#   returns 0 if one test passes, and echos the parameter that passed
#   returns 1 if all tests fail, and echos all warnings
any() {
  retval=1; msg=""; f="$1"; shift;
  while [ "$#" -gt 0 ]; do
    v=`$f "$1"` && { msg="$v"; retval=0; break; } || msg="$msg\n$v"
    shift
  done
  echo -e "$msg" | sed '/^$/{1d}'
  return $retval
}
# all:
#   first arg is the function, the rest are parameters
#   returns 0 if all tests pass, and echos the success messages
all() {
  retval=0; msg=""; f="$1"; shift
  while [ "$#" -gt 0 ]; do
    v=`$f "$1"` && { [ "$retval" ] && msg="$msg\n$v"; }\
                  || { msg="$msg\n$v"; retval=1; }
    shift
  done
  echo -e "$msg" | sed '/^$/{1d}'
  return $retval
}

# test functions:
#   return 0 if they pass
#   print a warning and return 1 if they fail

exist() { [ -f "$1" ] && laud "$1 found" || warn "$1 cannot be found"; }
executable() { exist "$1" && [ -x "$1" ] && laud "$1 is executable" \
                                         || warn "$1 is not executable"; }
directory() { [ -d "$1" ] && laud "$1 directory exists" \
                          || warn "$1 directory does not exist"; }

run() { cmd="$1"; shift; "$cmd" "$@" \
          && laud "$cmd completed successfuly" \
          || warn "$cmd did not complete successfully"; }

# run2's second argument is a file to pipe stdout to
run2() { cmd="$1"; outfile="$2"; shift 2; "$cmd" "$@" > "$outfile" \
          && laud "$cmd completed successfuly" \
          || warn "$cmd did not complete successfully"; }

sorteddiff() { diffs=`diff -b <(sort "$1") <(sort "$2")`
               [ -z "$diffs" ] && laud "No diffs ($1 == $2)" \
                               || warn "Diffs ($1 != $2)\n$diffs"; }
