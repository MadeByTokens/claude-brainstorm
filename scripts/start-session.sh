#!/bin/bash
# Start a brainstorm session - creates state file and session markdown file

# Get topic from argument or use default
TOPIC="${1:-untitled}"
TOPIC_SLUG=$(echo "$TOPIC" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//')
TIMESTAMP=$(date +"%Y%m%d-%H%M")
SESSION_FILE="./brainstorm-${TOPIC_SLUG}-${TIMESTAMP}.md"

# Create state file in current directory
STATE_FILE="./.brainstorm-state"

# Write state
cat > "$STATE_FILE" << EOF
BRAINSTORM_ACTIVE=1
SESSION_FILE=$SESSION_FILE
TOPIC=$TOPIC
STARTED=$TIMESTAMP
CURRENT_THREAD=MAIN
THREAD_STACK=MAIN
FORK_COUNT=0
IDEA_COUNT=0
EOF

# Create session markdown file
cat > "$SESSION_FILE" << EOF
# Brainstorm: $TOPIC
Date: $(date +"%Y-%m-%d %H:%M")
Technique(s) used: TBD

## [MAIN] $TOPIC

EOF

echo "SESSION_FILE=$SESSION_FILE"
echo "STATE_FILE=$STATE_FILE"
