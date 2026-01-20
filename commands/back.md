---
description: Return to the parent thread after exploring a fork. Use when done with a tangent and ready to continue the main brainstorm.
---

# Return to Parent Thread

The user wants to return from the current fork to its parent thread.

## Actions to Perform

1. **Update session state:**
   - Pop the current thread from the stack
   - Set current thread to the parent (top of stack)
   - Keep the fork in the "open forks" list (it's explored, not deleted)

2. **Update session file:**
   - Add a separator line `---`
   - Add continuation header: `## [PARENT THREAD] [topic] (continued)`
   - Add return reference: `Returned from: [fork name]`

3. **Acknowledge the return to user:**

```
BACK TO: [parent thread name]
(Explored: [fork name])

[Brief 1-line summary of what was explored in the fork]

Where were we? [Continue the parent thread's brainstorm, or ask what to explore next]
```

## If Already at MAIN

If the user calls /brainstorm:back while already at MAIN (no parent to return to), display:

```
Already at MAIN thread - no parent to return to.

Current open forks: [list forks if any]
```

Then use AskUserQuestion to offer options:

```json
{
  "questions": [
    {
      "question": "What would you like to do?",
      "header": "Navigate",
      "multiSelect": false,
      "options": [
        {"label": "Fork", "description": "Branch into a new tangent"},
        {"label": "Keep exploring", "description": "Continue on the main thread"}
      ]
    }
  ]
}
```

## Important

- Stay in brainstorming mode
- After returning, continue the parent thread's brainstorm
- Briefly acknowledge what was explored in the fork
- Don't lose momentum - keep generating
