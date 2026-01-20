#!/bin/bash
# Auto-approve Bash operations for brainstorm plugin

# Read the hook input from stdin
input=$(cat)

# Extract the command from the input
command=$(echo "$input" | jq -r '.tool_input.command // ""')

# Approve start-session.sh (with any arguments)
if [[ "$command" == *"scripts/start-session.sh"* ]]; then
  cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow",
    "permissionDecisionReason": "Brainstorm session start"
  }
}
EOF
  exit 0
fi

# Approve end-session.sh
if [[ "$command" == *"scripts/end-session.sh"* ]]; then
  cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow",
    "permissionDecisionReason": "Brainstorm session end"
  }
}
EOF
  exit 0
fi

# Approve tree commands
if [[ "$command" == "tree"* ]]; then
  cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow",
    "permissionDecisionReason": "Brainstorm directory visualization"
  }
}
EOF
  exit 0
fi

# Don't interfere with other bash commands
exit 0
