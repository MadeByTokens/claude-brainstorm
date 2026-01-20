<img width="1024" height="559" alt="image" src="https://github.com/user-attachments/assets/060c3ff9-2717-4bd1-adf5-7ea80bb6e203" />

# Claude Brainstorm Plugin

A Claude Code plugin that enforces brainstorming mode, preventing Claude from jumping to solutions.

## The Problem

Claude is trained to be helpful, which often means rushing to solutions. Ask "how could we improve user onboarding?" and you'll get a list of implementable suggestions. That's great for execution, but terrible for ideation.

Real brainstorming requires staying in divergent thinking mode - generating possibilities without evaluating them. This plugin forces that behavior through hooks that intercept every interaction and remind Claude of the rules.

## How It Works

The plugin uses Claude Code's hook system to inject a "brainstorm mode enforcer" on every user prompt. When active:

- Claude generates ideas in batches instead of proposing solutions
- Code writing is blocked (Claude literally can't create `.py`, `.js`, etc. files)
- Feasibility evaluation is suppressed unless explicitly requested
- Ideas are logged to a timestamped markdown file automatically
- Thread navigation lets you explore tangents without losing context
- Claude proactively searches the web for inspiration and analogies
- Fork suggestions help you explore promising tangents

## Installation

### Option A: Via MadeByTokens Marketplace (Recommended)

See https://github.com/MadeByTokens/claude-code-plugins-madebytokens

### Option B: CLI Flag at Launch

```bash
# Clone the repo
git clone https://github.com/MadeByTokens/claude-brainstorm.git

# Launch Claude Code with the plugin directory
claude --plugin-dir /path/to/claude-brainstorm
```

### Option C: Manual Settings Configuration

Clone the repo, then add it to your Claude Code settings file:

**User scope** (`~/.claude/settings.json`):
```json
{
  "pluginDirs": ["/path/to/claude-brainstorm"]
}
```

**Project scope** (`.claude/settings.json` in your project):
```json
{
  "pluginDirs": ["/path/to/claude-brainstorm"]
}
```

---

The plugin self-approves its own operations (session scripts, tree commands, brainstorm file writes) via hooks, so no manual permission configuration is needed.

## Usage

### Start a session

```
/brainstorm:start improving our checkout flow
```

Claude presents a technique menu and begins generating ideas. Choose from:
- **Free Association** - Wild ideas, no filter
- **SCAMPER** - Systematic transformation (Substitute, Combine, Adapt, Modify, Put to other uses, Eliminate, Reverse)
- **Six Thinking Hats** - Rotate through perspectives (Facts, Emotions, Caution, Benefits, Creativity, Process)
- **Reverse Brainstorm** - "How could we fail?" then flip
- **Analogy Hunt** - Steal solutions from other domains
- **Constraint Play** - "What if no budget?" / "What if infinite time?"

### Explore a tangent

```
/brainstorm:fork voice-controlled navigation
```

Creates a nested thread. Ideas stay organized. Use hierarchically - forks can have forks.

### Return to parent thread

```
/brainstorm:back
```

Pops back to where you were. The session file tracks the full path.

### Check progress

```
/brainstorm:status
```

Shows:
- Current thread and full breadcrumb path
- Open forks
- Top 5 ideas so far
- Total idea count

### End session

```
/brainstorm:done
```

The only way to exit brainstorm mode. Claude adds a summary to the session file and offers to help prioritize.

### Get help

```
/brainstorm:help
```

Shows all commands, available techniques, and how sessions work.

## Session Files

Sessions are saved to `brainstorm-[topic]-[timestamp].md` in your working directory. Format:

```markdown
# Brainstorm: improving checkout flow
Date: 2026-01-19 15:30
Technique(s) used: Free Association, SCAMPER

## [MAIN] improving checkout flow
- Idea: One-click purchase for returning customers
- Idea: Progress indicator showing steps remaining
- Idea: Guest checkout with optional account creation at end

---
## [FORK 1] voice-controlled navigation
Parent: MAIN
- Idea: "Hey checkout, apply my usual payment"
- Idea: Voice confirmation instead of clicking buttons

---
## [MAIN] improving checkout flow (continued)
Returned from: FORK 1
- Idea: Integrate voice from fork into accessibility features

## Final Summary
Key themes:
- Reducing friction for returning users
- Accessibility and alternative input methods
- Trust signals at decision points

Stats:
- Ideas generated: 23
- Forks explored: 1
- Techniques used: Free Association, SCAMPER
```

## Architecture (for developers)

```
.
├── .claude-plugin/
│   └── plugin.json              # Plugin metadata
├── commands/
│   ├── start.md                 # /brainstorm:start - session initialization
│   ├── fork.md                  # /brainstorm:fork - create nested thread
│   ├── back.md                  # /brainstorm:back - return to parent
│   ├── status.md                # /brainstorm:status - show progress
│   ├── done.md                  # /brainstorm:done - end session
│   └── help.md                  # /brainstorm:help - show help and techniques
├── hooks/
│   ├── hooks.json               # Hook configuration (PreToolUse + UserPromptSubmit)
│   └── brainstorm-enforcer.sh   # UserPromptSubmit hook (mode enforcement)
└── scripts/
    ├── start-session.sh             # Creates .brainstorm-state and session file
    ├── end-session.sh               # Removes .brainstorm-state
    ├── approve-brainstorm-write.sh  # Auto-approves writes to brainstorm-*.md
    ├── approve-brainstorm-bash.sh   # Auto-approves plugin bash commands
    └── approve-brainstorm-websearch.sh  # Auto-approves web searches during sessions
```

### State Management

Active sessions create `.brainstorm-state` in the working directory:

```bash
BRAINSTORM_ACTIVE=1
SESSION_FILE=./brainstorm-checkout-flow-20260119-1530.md
TOPIC=improving checkout flow
STARTED=20260119-1530
CURRENT_THREAD=MAIN
THREAD_STACK=MAIN
FORK_COUNT=0
IDEA_COUNT=0
```

The enforcer hook checks for this file on every prompt. If present and `BRAINSTORM_ACTIVE=1`, it injects the rules reminder. Deleting this file (or running `/brainstorm:done`) exits the mode.

### Hook Flow

```
User types something
       ↓
UserPromptSubmit hook fires
       ↓
brainstorm-enforcer.sh checks .brainstorm-state
       ↓
If active: injects rules reminder to Claude
       ↓
Claude processes in brainstorm mode
       ↓
If Claude runs bash (start-session.sh, end-session.sh, tree):
  PreToolUse hook fires → approve-brainstorm-bash.sh → auto-approved
       ↓
If Claude writes to brainstorm-*.md:
  PreToolUse hook fires → approve-brainstorm-write.sh → auto-approved
       ↓
If Claude searches the web:
  PreToolUse hook fires → approve-brainstorm-websearch.sh → auto-approved
```

### Modifying Behavior

**Change the rules Claude follows**: Edit `hooks/brainstorm-enforcer.sh`. The `NEVER DO` and `ALWAYS DO` lists in the heredoc are what Claude sees on every prompt.

**Add brainstorming techniques**: Edit `commands/start.md`. The technique menu and detailed instructions are there.

**Change session file format**: Edit `commands/start.md` (the template) and `scripts/start-session.sh` (the initial file creation).

**Modify fork/back behavior**: Edit `commands/fork.md` and `commands/back.md`. Thread stack logic is described there.

**Change file auto-approve behavior**: Edit `scripts/approve-brainstorm-write.sh` to allow/block different file patterns.

**Change bash auto-approve behavior**: Edit `scripts/approve-brainstorm-bash.sh` to allow/block different bash commands.

**Change web search auto-approve behavior**: Edit `scripts/approve-brainstorm-websearch.sh` to modify when web searches are auto-approved.

## Limitations

- Only one brainstorm session per working directory at a time (single `.brainstorm-state` file)
- State is directory-local - changing directories loses the session context
- The enforcer hook runs on every prompt, even non-brainstorm ones (exits silently if no active session)

## Why Not Just Prompt?

You can tell Claude "let's brainstorm, don't give me solutions." It works... sometimes. But:

| Manual prompting | This plugin |
|------------------|-------------|
| Claude sometimes forgets | Enforced on every prompt |
| Ideas scattered in chat | Logged to markdown file |
| Tangents get messy | Fork/back navigation |
| No progress tracking | Status command |
| "Where were we?" | Thread stack remembers |

The plugin trades flexibility for consistency. If you need Claude to stay in brainstorm mode for an extended session, the hooks guarantee it.

## License

MIT
