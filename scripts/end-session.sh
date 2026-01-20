#!/bin/bash
# End a brainstorm session - removes state file

STATE_FILE="./.brainstorm-state"

if [ -f "$STATE_FILE" ]; then
    # Read session file path before deleting state
    SESSION_FILE=$(grep "SESSION_FILE=" "$STATE_FILE" | cut -d'=' -f2)

    # Remove state file
    rm "$STATE_FILE"

    echo "ENDED=1"
    echo "SESSION_FILE=$SESSION_FILE"
else
    echo "ENDED=0"
    echo "ERROR=No active brainstorm session"
fi
