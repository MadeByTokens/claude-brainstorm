---
description: End the brainstorming session with a summary. Use when the user wants to wrap up and see what was generated.
---

# End Brainstorming Session

The user is ending their brainstorming session. Wrap up gracefully.

## Actions to Perform

1. **Run the end script** to clear brainstorm state:
   ```bash
   PLUGIN_PATH/scripts/end-session.sh
   ```
   Replace `PLUGIN_PATH` with the actual path from the `<brainstorm-plugin-path>` tag in your context.

   **Capture the SESSION_FILE path from the output** - you'll need it for subsequent steps.

   If the script returns `ENDED=0`, inform the user there's no active brainstorm session and stop.

2. **Write final summary to session file**
   - Add a "## Final Summary" section at the end
   - List key themes that emerged
   - Note total number of ideas generated
   - Note any forks that were explored

3. **Display numbered idea list and ask user to pick top ideas**

   If no ideas were generated, skip to step 5 and note "No formal ideas captured" in the display.

   Otherwise, display all ideas numbered (1, 2, 3...), then proceed to the Top Ideas Selection section below.

4. **Generate summary file** (unless user chose "Skip summary")

   Create a file in the same directory as the session file. Name it by inserting `-summary` before `.md`:
   - Session: `brainstorm-checkout-20260119-1530.md`
   - Summary: `brainstorm-checkout-20260119-1530-summary.md`

5. **Display session complete message** (see Display Format below)

6. **Offer next steps** (see Next Steps section below)

## Top Ideas Selection

Use the AskUserQuestion tool to let the user choose which ideas go in the summary:

```json
{
  "questions": [
    {
      "question": "Which ideas should go in the summary?",
      "header": "Top ideas",
      "multiSelect": false,
      "options": [
        {"label": "Pick for me", "description": "I'll select the 3-5 most promising ideas"},
        {"label": "All ideas", "description": "Include all ideas in condensed form"},
        {"label": "Skip summary", "description": "Don't generate a summary file"}
      ]
    }
  ]
}
```

Note: AskUserQuestion always allows free-text input via "Other". If user selects "Other", they can enter specific idea numbers (e.g., "1, 3, 7").

## Summary File Format

Keep to ~20 lines. Omit sections that don't apply (e.g., no "Forks Explored" if there were no forks).

```markdown
# Summary: [Topic]
Date: [date] | Ideas: [count] | Forks: [count]

## Key Themes
- [theme 1]
- [theme 2]
- [theme 3]

## Top Ideas
- [selected idea 1]
- [selected idea 2]
- [selected idea 3]

## Forks Explored
- [fork 1 name]: [1-line summary of what was explored]

Full session: [session filename]
```

This file is designed to load into another Claude session quickly.

## Display Format

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

Files saved:
- Full session: [path to session file]
- Summary: [path to summary file]
```

If user chose "Skip summary", omit the Summary line from "Files saved".

## Next Steps

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
- The summary file is designed to be loaded into a new Claude session for follow-up
- Be encouraging about what was generated, but don't over-praise
