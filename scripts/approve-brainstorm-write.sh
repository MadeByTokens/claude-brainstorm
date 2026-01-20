#!/bin/bash
# Auto-approve Write operations for brainstorm session files

# Read the hook input from stdin
input=$(cat)

# Extract the file_path from the input
file_path=$(echo "$input" | jq -r '.tool_input.file_path // ""')

# Approve writes to brainstorm-*.md files
if [[ "$file_path" == *"brainstorm-"*".md" ]]; then
  cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow",
    "permissionDecisionReason": "Brainstorm session file"
  }
}
EOF
  exit 0
fi

# Don't interfere with other operations
exit 0
