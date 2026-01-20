---
description: Display help and reference for brainstorming commands, techniques, and usage.
---

# Brainstorming Help

The user wants to see help information about the brainstorming plugin. Display a clear, concise reference.

## Display Format

Show the following help information:

```
BRAINSTORM HELP

Commands:
  /brainstorm:start [topic]  - Start a new brainstorming session
  /brainstorm:fork <topic>   - Branch into a tangent or sub-topic
  /brainstorm:back           - Return to parent thread
  /brainstorm:status         - See current thread, open forks, top ideas
  /brainstorm:done           - End session with summary
  /brainstorm:help           - Show this help

Techniques Available:
  - Free Association    Wild ideas, no filter
  - SCAMPER             Substitute, Combine, Adapt, Modify, Put to other uses, Eliminate, Reverse
  - Six Thinking Hats   Facts, Emotions, Caution, Benefits, Creativity, Process
  - Reverse Brainstorm  "How could we fail?" then flip the answers
  - Analogy Hunt        Steal solutions from other domains
  - Constraint Play     "What if no budget?" / "What if infinite time?"

How It Works:
  1. Start a session with /brainstorm:start
  2. Select one or more techniques
  3. Ideas are generated in batches and logged to a session file
  4. Fork into tangents anytime, return with /brainstorm:back
  5. Claude will suggest forks when promising tangents emerge
  6. Claude proactively searches the web for inspiration and analogies
  7. End with /brainstorm:done to get a summary

Session Files:
  - Ideas are saved to: brainstorm-[topic]-[timestamp].md
  - Located in current working directory
```

## After Help

Use the AskUserQuestion tool to offer next steps:

```json
{
  "questions": [
    {
      "question": "What would you like to do?",
      "header": "Next",
      "multiSelect": false,
      "options": [
        {"label": "Start brainstorming", "description": "Begin a new session with /brainstorm:start"},
        {"label": "Learn more about techniques", "description": "Get detailed explanation of a technique"},
        {"label": "Continue", "description": "Go back to what I was doing"}
      ]
    }
  ]
}
```

## If User Selects "Learn more about techniques"

Provide a detailed explanation of the selected technique. Use AskUserQuestion to let them pick which technique:

```json
{
  "questions": [
    {
      "question": "Which technique would you like to learn about?",
      "header": "Technique",
      "multiSelect": false,
      "options": [
        {"label": "SCAMPER", "description": "7-step systematic transformation framework"},
        {"label": "Six Thinking Hats", "description": "6 perspectives for comprehensive thinking"},
        {"label": "Reverse Brainstorm", "description": "Failure-first approach"},
        {"label": "Analogy Hunt", "description": "Cross-domain inspiration"}
      ]
    }
  ]
}
```

### Technique Details

**SCAMPER**:
- **Substitute**: What can we swap out? Different materials, people, processes?
- **Combine**: What can we merge? Features, ideas, purposes?
- **Adapt**: What can we borrow from elsewhere? Other industries, nature, history?
- **Modify**: What can we change in scale, shape, or form? Bigger, smaller, faster?
- **Put to other uses**: What else could this be used for? New contexts, audiences?
- **Eliminate**: What can we remove? Simplify, strip down?
- **Reverse**: What if we did the opposite? Flip assumptions?

**Six Thinking Hats**:
- **White Hat**: Facts and information only - what do we know?
- **Red Hat**: Emotions and intuition - what feels right/wrong?
- **Black Hat**: Caution and critical judgment - what could go wrong?
- **Yellow Hat**: Benefits and optimism - what's good about this?
- **Green Hat**: Creativity and alternatives - what else could we try?
- **Blue Hat**: Process and organization - what's our approach?

**Reverse Brainstorm**:
Instead of "How do we solve X?", ask "How could we make X worse?" or "How could we guarantee failure?" Generate lots of failure modes, then flip each one into a solution.

**Analogy Hunt**:
Look for parallel problems in completely different domains:
- Nature: How does biology solve this?
- Other industries: How does healthcare/gaming/aviation handle this?
- History: How was this solved before technology?
- Art/Games: What creative approaches exist?

## Important

- This command works whether or not a brainstorming session is active
- If a session is active, stay in brainstorming mode after showing help
- Do not write code or jump to solutions
