---
description: End the brainstorming session with a summary. Use when the user wants to wrap up and see what was generated.
---

# End Brainstorming Session

The user is ending their brainstorming session. Wrap up gracefully.

## Actions to Perform

1. **FIRST: Run the end script** to clear brainstorm state:
   ```bash
   ./scripts/end-session.sh
   ```
   This removes `.brainstorm-state`, which disables the enforcer hook.

2. **Write final summary to session file**
   - Add a "## Final Summary" section at the end
   - List key themes that emerged
   - Note total number of ideas generated
   - Note any forks that were explored

3. **Display to user:**

```
SESSION COMPLETE

Key themes that emerged:
- [Theme 1]: [brief description]
- [Theme 2]: [brief description]
- [Theme 3]: [brief description]

Stats:
- Ideas generated: [count]
- Forks explored: [count]
- Techniques used: [list]

Session saved to: [path to session file]
```

4. **Offer next steps using AskUserQuestion:**

Use the AskUserQuestion tool to let the user choose what to do next:

```json
{
  "questions": [
    {
      "question": "What would you like to do with these ideas?",
      "header": "Next step",
      "multiSelect": false,
      "options": [
        {"label": "Pick winners", "description": "Select the best ideas and start planning"},
        {"label": "Prioritize", "description": "Help rank and organize the ideas"},
        {"label": "Implement", "description": "Start building something from this session"},
        {"label": "Done for now", "description": "Save and exit, come back later"}
      ]
    }
  ]
}
```

## Important

- This command EXITS brainstorming mode
- After this, Claude returns to normal assistant behavior
- The session file remains for future reference
- Be encouraging about what was generated, but don't over-praise
