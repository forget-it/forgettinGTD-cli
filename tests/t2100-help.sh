#!/bin/bash
#

test_description='help functionality
This test covers the help output.
'
. ./test-lib.sh

# Note: To avoid having to adapt the test whenever the help documentation
# slightly changes, only check for the section headers.
test_todo_session 'help output' <<EOF
>>> ftd.sh help
Usage: ftd.sh [-todox]
Try 'ftd.sh -h' for more information.
=== 1
EOF

test_done
