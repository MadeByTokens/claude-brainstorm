#!/bin/bash
# Auto-approve WebSearch during active brainstorm sessions

STATE_FILE="./.brainstorm-state"

# Only auto-approve if brainstorm session is active
if [ -f "$STATE_FILE" ]; then
  source "$STATE_FILE"
  if [ "$BRAINSTORM_ACTIVE" = "1" ]; then
    cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow",
    "permissionDecisionReason": "Brainstorm session - web search for inspiration"
  }
}
EOF
    exit 0
  fi
fi

# Don't interfere with other operations
exit 0
