#!/bin/bash

# redefine CDBDIR as necessary
CDBDIR=$( cd $(dirname "$0")/..; pwd -P )
source "$CDBDIR/check.bash"

exist "$CDBDIR/check.bash"
executable "$CDBDIR/examples/ex1.sh"
