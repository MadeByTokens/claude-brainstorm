# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Claude Brainstorm is a Claude Code plugin that enforces brainstorming mode, preventing Claude from jumping to solutions. It uses hooks to intercept interactions and keep Claude in divergent thinking mode.

## Architecture

The plugin consists of three core components:

1. **Commands** (`commands/*.md`) - Slash commands that users invoke:
   - `/brainstorm:start <topic>` - Initialize session, present technique menu
   - `/brainstorm:fork <topic>` - Create nested thread for tangent exploration
   - `/brainstorm:back` - Return to parent thread
   - `/brainstorm:status` - Show progress (current thread, forks, top ideas)
   - `/brainstorm:done` - End session, generate summary file
   - `/brainstorm:help` - Show commands and techniques

2. **Hooks** (`hooks/`) - Automatic enforcement:
   - `brainstorm-enforcer.sh` (UserPromptSubmit) - Injects rules reminder on every prompt when session active
   - `hooks.json` - Configures PreToolUse hooks for Write, Bash, WebSearch

3. **Scripts** (`scripts/`) - Session management and auto-approval:
   - `start-session.sh` - Creates `.brainstorm-state` and `brainstorm-*.md` session file
   - `end-session.sh` - Cleans up state file
   - `approve-brainstorm-*.sh` - Auto-approve hooks for plugin operations

## State Management

Active sessions create `.brainstorm-state` in the working directory containing:
- `BRAINSTORM_ACTIVE`, `SESSION_FILE`, `TOPIC`, `STARTED`
- `CURRENT_THREAD`, `THREAD_STACK`, `FORK_COUNT`, `IDEA_COUNT`

The enforcer hook sources this file on every prompt. Presence of `BRAINSTORM_ACTIVE=1` triggers rule injection.

## Hook Flow

```
User prompt → UserPromptSubmit → brainstorm-enforcer.sh checks .brainstorm-state
                                          ↓
                               If active: injects rules to Claude
                                          ↓
                               Claude processes in brainstorm mode
                                          ↓
Tool calls → PreToolUse → approve-*.sh scripts auto-approve:
  - Writes to brainstorm-*.md (includes *-summary.md files)
  - Bash: start-session.sh, end-session.sh, tree commands
  - WebSearch (during active sessions)
```

## Modification Points

- **Change enforced rules**: Edit `hooks/brainstorm-enforcer.sh` (NEVER/ALWAYS lists)
- **Add brainstorming techniques**: Edit `commands/start.md` (technique menu)
- **Change session file format**: Edit `commands/start.md` (template) and `scripts/start-session.sh` (initial creation)
- **Modify fork/back behavior**: Edit `commands/fork.md` and `commands/back.md`
- **Change auto-approve patterns**: Edit corresponding `scripts/approve-brainstorm-*.sh`

## Commit Style

- One line only, no multi-line messages
- No co-author or Claude mentions

## Plugin Metadata

Defined in `.claude-plugin/plugin.json`. Current version: 1.1.0
