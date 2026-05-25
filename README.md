# skill-prototype

<div align="center">

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**Throwaway prototypes that answer one question — before you commit to production code.**

An agent skill for Claude Code, Cursor, Codex, and other coding agents.

</div>

<div align="center">
<h3>Quick Install</h3>

```bash
curl -fsSL https://raw.githubusercontent.com/Diffuzmetall/skill-prototype/main/install.sh | bash
```

**Or clone and copy manually:**

```bash
git clone https://github.com/Diffuzmetall/skill-prototype.git
cp -r skill-prototype/{SKILL,LOGIC,UI}.md ~/.claude/skills/prototype/
```

</div>

---

## TL;DR

**The Problem:** You need to validate an idea — a state machine edge case, a page layout, an API shape — but production code is expensive. Mockups lie. Whiteboard diagrams miss the weird transitions. You end up either over-building too early or debating abstractions you can't feel.

**The Solution:** The **prototype** skill tells your coding agent to build *throwaway* artifacts tuned to one question: a keyboard-driven terminal app for logic, or several radically different UI variants on one route for design. Learn fast, capture the answer, delete the rest.

### Why use this skill?

| Feature | What it does |
|---------|----------------|
| **Question-first routing** | Picks LOGIC vs UI branch from what you're actually trying to learn |
| **Logic branch** | Pure reducer/state machine + minimal TUI you drive by hand |
| **UI branch** | 3 structurally different variants on one route, `?variant=` switcher |
| **Portable core** | Logic prototypes isolate the module you can lift into prod; TUI/switcher is disposable |
| **Explicit lifecycle** | Rules for naming, one-command run, no persistence, capture answer, delete |
| **Agent-native** | Works as `/prototype`, manual attach, or description-triggered skill |

---

## Quick Example

```text
# In any project with the skill installed:

You: /prototype — I'm not sure our invite flow handles "expired link, then resend, then accept"

Agent: builds prototype-invite-flow/
       ├── inviteMachine.ts      # pure state machine (keep)
       └── invite-prototype.ts   # TUI shell (delete later)

You: pnpm run prototype:invite
     [a] accept  [e] expire link  [r] resend  [q] quit

You: "wait — resend shouldn't reset the expiry clock"
     → bug in the *idea*, found in 5 minutes, not after a PR

---

You: /prototype three radically different layouts for /settings billing tab

Agent: adds VariantA/B/C on existing /settings route
       floating bottom bar: ←  B — Sidebar layout  →
       shareable URLs: /settings?variant=B

You: "header from B, table density from A"
     → actual design decision, not three Figma frames in isolation
```

---

## Design Philosophy

1. **The question decides the shape.** A logic prototype and a UI prototype are different animals. Picking the wrong branch wastes the whole session.

2. **Throwaway by contract.** Prototypes are labeled, colocated with the code they inform, and meant to be deleted or absorbed — not to rot in the repo.

3. **Surface the state.** After every keystroke or variant switch, you see the full relevant state. Prototypes exist to make the invisible visible.

4. **Lift the logic, trash the shell.** Reducers and state machines stay pure; TUI and variant switchers are thin, disposable wrappers.

5. **One command to run.** If you can't start it without remembering a path, the friction kills exploration.

---

## Comparison

| Approach | Best for | Weakness |
|----------|----------|----------|
| **This skill** | Validating one specific question with runnable throwaway code | Not for shipping features; no tests/polish by design |
| **Free-form "build a prototype"** | Quick spikes | Inconsistent shape; often becomes accidental production code |
| **Figma / static mockups** | Early visual exploration | Misses real data density, auth, and app chrome |
| **Spike branch + full tests** | Production-bound work | Too heavy when you're still unsure the idea is right |
| **Paper / whiteboard** | Cheap brainstorming | Hard to hit edge cases in state machines and flows |

---

## Installation

### 1. One-liner (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/Diffuzmetall/skill-prototype/main/install.sh | bash
```

Installs into `~/.claude/skills/prototype`, `~/.cursor/skills/prototype`, and `~/.agents/skills/prototype` when those parent directories exist.

### 2. Manual copy

```bash
git clone https://github.com/Diffuzmetall/skill-prototype.git
mkdir -p ~/.claude/skills/prototype
cp skill-prototype/{SKILL,LOGIC,UI}.md ~/.claude/skills/prototype/
```

Repeat for Cursor (`~/.cursor/skills/`) or Codex (`~/.agents/skills/`) as needed.

### 3. Per-project skill (Cursor / Claude Code)

```bash
git clone https://github.com/Diffuzmetall/skill-prototype.git .cursor/skills/prototype
# or
git clone https://github.com/Diffuzmetall/skill-prototype.git .claude/skills/prototype
```

Symlink also works if you prefer a single canonical copy.

### Custom install paths

```bash
CLAUDE_SKILLS_DIR=/path/to/skills \
CURSOR_SKILLS_DIR=/path/to/skills \
bash install.sh
```

---

## Quick Start

1. **Install** the skill (see above).
2. **Open a project** where you have a concrete question — not "make it better", but "does X then Y break the state machine?" or "which layout feels right on real data?"
3. **Invoke** `/prototype` (or describe the question; the skill description triggers on "prototype this", "try a few designs", etc.).
4. **Run** the artifact the agent produces (`pnpm run …`, or the URL with `?variant=`).
5. **Capture** the answer in a commit message, ADR, issue, or `NOTES.md`.
6. **Delete** the throwaway shell; lift validated logic or the winning UI variant into real code.

---

## Skill Reference

This repo is the skill. There is no separate CLI.

| File | Role |
|------|------|
| [`SKILL.md`](SKILL.md) | Entry point: routing, shared rules, lifecycle |
| [`LOGIC.md`](LOGIC.md) | Terminal/TUI branch: reducers, state machines, TUI frame rules |
| [`UI.md`](UI.md) | UI branch: variants, `?variant=` switcher, sub-shape A vs B |

### Triggers

The agent should load this skill when you say things like:

- `/prototype`
- "prototype this"
- "let me play with it"
- "sanity-check this state machine"
- "try a few designs for this page"
- "mock up UI options"

### Branch selection

| Your question | Branch | Artifact |
|---------------|--------|----------|
| Does this logic / state / data model work? | **LOGIC** | Interactive terminal app |
| What should this look like? | **UI** | 3+ structurally different variants on one route |

When ambiguous: backend module → LOGIC; page/component → UI. The agent should state the assumption.

---

## Configuration

No config file. The skill follows host-project conventions:

- **Language/runtime** — match the project (TypeScript, Python, Go, …).
- **Task runner** — `package.json` scripts, `Makefile`, `justfile`, etc.
- **Routing** — existing framework conventions for UI prototypes (Next.js, React Router, …).
- **Styling** — project's component library (shadcn, MUI, Tailwind, …).

Optional environment variables for `install.sh` only:

| Variable | Default | Purpose |
|----------|---------|---------|
| `SKILL_PROTOTYPE_REPO` | This GitHub repo | Clone source for install script |
| `CLAUDE_SKILLS_DIR` | `~/.claude/skills` | Claude Code skills root |
| `CURSOR_SKILLS_DIR` | `~/.cursor/skills` | Cursor skills root |
| `AGENTS_SKILLS_DIR` | `~/.agents/skills` | Codex / agents skills root |

---

## Architecture

```text
┌─────────────────────────────────────────────────────────────┐
│  User question: "Does logic work?" vs "What should it look?"│
└───────────────────────────┬─────────────────────────────────┘
                            │
              ┌─────────────┴─────────────┐
              ▼                           ▼
     ┌─────────────────┐         ┌─────────────────┐
     │  LOGIC.md       │         │  UI.md          │
     │  pure module    │         │  VariantA/B/C   │
     │  + TUI shell    │         │  + switcher bar │
     └────────┬────────┘         └────────┬────────┘
              │                           │
              ▼                           ▼
     ┌─────────────────┐         ┌─────────────────┐
     │  User drives    │         │  User flips     │
     │  keystrokes     │         │  ?variant=      │
     └────────┬────────┘         └────────┬────────┘
              │                           │
              └─────────────┬─────────────┘
                            ▼
                 ┌─────────────────────┐
                 │  Answer captured    │
                 │  (ADR / issue /     │
                 │   NOTES.md)         │
                 └──────────┬──────────┘
                            ▼
                 ┌─────────────────────┐
                 │  Delete throwaway   │
                 │  Absorb winner      │
                 └─────────────────────┘
```

**Shared rules** (both branches): throwaway naming, one command to run, in-memory state by default, no tests, surface full state, delete when done.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Agent builds production code instead of throwaway | Re-invoke with `/prototype` and paste the question from [SKILL.md](SKILL.md): "throwaway code that answers one question" |
| Wrong branch (TUI instead of UI variants) | Say explicitly: "UI branch — three layouts on `/settings`" or "LOGIC branch — state machine only" |
| Skill not found | Verify files exist: `ls ~/.claude/skills/prototype/SKILL.md` (or Cursor/Codex path). Re-run `install.sh` |
| UI switcher visible in production | Ensure switcher is gated on `NODE_ENV !== 'production'` (see [UI.md](UI.md)) |
| Prototype left in repo after decision | Follow cleanup in SKILL.md: delete losers + switcher; rewrite winner properly before merge |
| install.sh skips a directory | Parent skills folder must exist first; create `~/.claude/skills` then re-run |

---

## Limitations

- **Not a framework.** Markdown instructions for agents — no runtime, no npm package, no validation of agent output.
- **Agent-dependent.** Quality varies by model and whether the skill is attached or triggered.
- **English-first skill text.** Agent instructions are in English; your prompts can be any language.
- **No persistence layer.** By design — if persistence is the question, use a scratch DB/file explicitly named as prototype-only.
- **UI branch needs a host app.** Variants are meaningful only when rendered inside real layout and data (sub-shape A preferred).

---

## FAQ

**Is this a library I import?**  
No. Copy or install the three markdown files into your agent's skills directory.

**Can I use only part of it?**  
Yes. `SKILL.md` alone gives routing and rules; branch files add depth when the agent reads them.

**Will the agent always delete prototypes?**  
It should, per the skill — but remind it after you've decided. The lifecycle is part of the contract.

**How many UI variants?**  
Default 3, cap at 5. More than that stops being "radically different."

**Can prototypes have tests?**  
The skill says no. If you need tests, you're past prototyping — build the real thing.

**Does this work with Cursor, Claude Code, and Codex?**  
Yes. Any agent that loads `SKILL.md`-format skills from a skills directory.

**What stays after a logic prototype?**  
The pure module (reducer, state machine, functions). The TUI shell is deleted.

**What stays after a UI prototype?**  
One rewritten variant in production code — not a copy-paste of throwaway components.

---

## Contributing

Issues and PRs are welcome. This repo intentionally contains **only** the prototype skill (three markdown files + install script). Please don't expand scope with unrelated skills, personal configs, or internal tooling.

For substantial changes, open an issue first so we agree the change still fits "one question, throwaway artifact, capture answer, delete."

---

## License

MIT — see [LICENSE](LICENSE).
