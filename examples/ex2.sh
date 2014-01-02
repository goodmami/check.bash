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
