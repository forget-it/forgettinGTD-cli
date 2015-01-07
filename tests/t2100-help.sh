#!/bin/bash
#

test_description='help functionality
This test covers the help output.
'
. ./test-lib.sh

# Note: To avoid having to adapt the test whenever the help documentation
# slightly changes, only check for the section headers.
test_todo_session 'help output' <<EOF
>>> todo.sh help | sed '/^  [A-Z]/!d'
  Usage: todo.sh [-fhpantvV] [-d todo_config] action [task_number] [task_description]
  Options:
  Built-in Actions:
EOF

test_done
