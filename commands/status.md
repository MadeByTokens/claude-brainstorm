---
description: Show current brainstorming session status including current thread, open forks, and top ideas.
---

# Brainstorming Status

The user wants to see where they are in the brainstorming session. Display a concise status overview.

## Display Format

Show the following information:

```
BRAINSTORM STATUS

Current thread: [MAIN or fork name]
Thread path: [MAIN > Fork 1 > Fork 1.1] (if nested)
Open forks: [list of fork names, or "None"]

Top 5 ideas so far:
1. [idea]
2. [idea]
3. [idea]
4. [idea]
5. [idea]

Ideas generated: [total count]
```

## Guidelines

- Keep it scannable - this is a quick check, not a detailed report
- "Top 5 ideas" = most recent or most discussed, use your judgment
- If fewer than 5 ideas exist, show what's available
- If in a nested fork, show the full path (breadcrumb trail)
- After displaying status, ask if they want to continue or need anything

## After Status

Use the AskUserQuestion tool to prompt the user on how to continue:

```json
{
  "questions": [
    {
      "question": "How would you like to continue?",
      "header": "Continue",
      "multiSelect": false,
      "options": [
        {"label": "Keep going", "description": "Continue generating ideas on current thread"},
        {"label": "Explore further", "description": "Dig deeper into one of the top ideas"},
        {"label": "Fork", "description": "Branch into a new tangent"},
        {"label": "Wrap up", "description": "End session with /brainstorm:done"}
      ]
    }
  ]
}
```

## Important

- This command does NOT exit brainstorming mode
- Stay in brainstorming mode and continue generating after showing status
- Do not write code or jump to solutions
