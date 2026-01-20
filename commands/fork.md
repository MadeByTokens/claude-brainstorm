---
description: Branch into a tangent topic during brainstorming. Creates a new thread to explore a side idea without losing the main thread.
---

# Fork Brainstorming Thread

The user wants to explore a tangent. Create a new branch in the brainstorming session.

## Arguments

`$ARGUMENTS` contains the topic for the fork.

## Actions to Perform

1. **Update session state:**
   - Push current thread onto the thread stack
   - Set current thread to the new fork name
   - Add fork to the list of open forks
   - Assign fork number (FORK 1, FORK 2, or nested like FORK 1.1)

2. **Update session file:**
   - Add a separator line `---`
   - Add new section header: `## [FORK X] [topic name]`
   - Add parent reference: `Parent: [previous thread]`

3. **Acknowledge the fork to user:**

```
FORKED: "[topic]"
Parent: [previous thread name]

Exploring this tangent now. Use /brainstorm:back to return.

[Then immediately start brainstorming on this new topic - ask a provocative question or offer initial ideas]
```

## Fork Numbering

- First fork from MAIN: FORK 1
- Second fork from MAIN: FORK 2
- Fork from FORK 1: FORK 1.1
- Fork from FORK 1.1: FORK 1.1.1
- etc.

## Important

- Stay in brainstorming mode
- Immediately start generating ideas for the new fork topic
- Keep the same energy and rules as the main brainstorm
- Don't ask "are you sure?" - just fork and go
- Forks can be nested as many levels as needed

## If No Topic Provided

If `$ARGUMENTS` is empty, ask:
"What tangent do you want to explore?"
