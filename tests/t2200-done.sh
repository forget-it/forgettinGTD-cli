#!/bin/bash
#

test_description='help functionality
This test covers the help output.
'
. ./test-lib.sh

# Note: To avoid having to adapt the test whenever the help documentation
# slightly changes, only check for the section headers.
test_ftd_session 'done output' <<EOF
>>> ftd.sh done 
Usage: ftd.sh [-todox]
Try 'ftd.sh -h' for more information.
=== 0
EOF

test_done
