check.bash
=========

Bash scripts to verify directory structure, file permissions, command output, etc.

### Features ###

* Checker scripts are easy to read and write (see below for an example)
* Feedback is color coded for user convenience
* Commands for standard checks are provided, others can be easily created
* any() and all() functions allow for useful handling of multiple conditions
* Checks use standard error codes (non-zero represents a problem), so command chaining is possible

### Implementation ###

Checking is handled internally by two commands (`laud` and `warn`) and the standard POSIX behavior of returning `0` if a command executed successfully or a non-zero value if there was a problem. These return values interact with shell features such as if-then constructs. The two commands are used to report feedback:

* `laud` prints feedback (in green) and returns 0
* `warn` prints feedback (in red) and returns 1

For example, the `exist` command uses a [Bash if-construct](http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html) with the `-f` option to check for file existence:

```bash
exist() { [ -f "$1" ] && laud "$1 found" || warn "$1 cannot be found"; }
```

If that is too opaque, it is just shorthand for:

```bash
exist() {
  if test -f "$1"; then
    laud "$1 found"
  else
    warn "$1 cannot be found"
  fi
}
```

### Examples ###

This is a basic example (see `examples/ex1.sh`) of how to use check.bash to check if files exist and are executable. This just verifies that `check.bash` and the script itself exist:

```bash
#!/bin/bash

# redefine CDBDIR as necessary
CDBDIR=$( cd $(dirname "$0")/..; pwd -P )
source "$CDBDIR/check.bash"

exist "$CDBDIR/check.bash"
executable "$CDBDIR/examples/ex1.sh"
```

And the output (paths abbreviated; also the terminal output will be colored):
```
.../check.bash found
.../examples/ex1.sh found
.../examples/ex1.sh is executable
```

Note that `examples/ex1.sh` is "found" before it is checked to be executable. The `executable` command first checks for file existence using the `exist` command.

Here is a slightly more advanced example (`examples/ex2.sh`) which checks the structure of a given directory:

```bash
#!/bin/bash

# redefine CDBDIR as necessary
CDBDIR=$( cd $(dirname "$0")/..; pwd -P )
source "$CDBDIR/check.bash"

[ "$#" -eq 1 ] || { echo "usage: $0 dir-to-check"; exit 1; }
dir="$1"

# move to given dir for convenience (`popd` happens at the end)
pushd "$dir"

echo "Checking $dir"
echo "  a/ should look good"
echo "  b/ should be missing entirely"
echo "  c/ should have several problems"

for subdir in "a" "b" "c"; do
  if directory "$subdir"; then
    all exist "$subdir/"{1,2,3}
    any exist "$subdir/"note{,.pdf,.txt,.doc}
    executable "$subdir/script.sh"
  fi
done

popd
```

This checks a directory for a particular structure. Namely, it should have subdirectories `a/`, `b/`, and `c/`, and these in turn should have files `1`, `2`, and `3` (combined with a `all` quantifier command); a `note` file with 4 possible filenames (no extension or a `.pdf`, `.txt`, or `.doc` extension; possibilities are expressed with the `any` quantifier command); and a `script.sh` file that should be executable. An example of such a directory (intentionally created with some problems) is given in `examples/ex2dir`. Also note that the `check.bash` commands may be used as other shell commands would; in this case it's used in a conditional block (the `exist` and `executable` commmands are only executed if the `directory` command succeeded). Here is the output (again, the output would be colored):

```
Checking examples/ex2dir/
  a/ should look good
  b/ should be missing entirely
  c/ should have several problems
a directory exists
a/1 found
a/2 found
a/3 found
a/note.txt found
a/script.sh found
a/script.sh is executable
b directory does not exist
c directory exists
c/1 found
c/2 found
c/3 cannot be found
c/note cannot be found
c/note.pdf cannot be found
c/note.txt cannot be found
c/note.doc cannot be found
c/script.sh found
c/script.sh is not executable
```
