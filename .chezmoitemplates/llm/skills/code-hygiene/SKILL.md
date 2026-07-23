---
name: code-hygiene
description: General guidelines for writing code and making changes. Use when writing or modifying code in any language or project.
---

# Code Hygiene

General guidelines for how code is written and changed. Each guideline is a
standing rule, independent of any specific task or language.

## Code describes the present, not its history

Code, comments, and documentation describe the current design and the standing
reasons it must be so, never the change that produced it. A fix results in a
codebase that reads as if it had always been written that way.

Distinguish the two kinds of "why". A standing reason is a constraint that
remains true regardless of history ("retries because the upstream returns 503
under load", "clamped to zero because negative values corrupt the index"); it
belongs in the code and should stay. A change reason explains a past edit ("no
longer does X", "changed from Y", "used to break because Z"); it describes a
state the reader cannot see, drifts out of truth, and is noise. Keep the first,
drop the second.

Explain what the code does and the ongoing reasons it must be so, in the
present tense. The same holds for READMEs and reference documentation: describe
how the thing works now, not how it used to.

Change rationale belongs in commit messages, changelogs, and decision records,
where it is tied to the change it explains, not in the source or docs that
outlive it. Those artifacts are the sole exception: their purpose is to record
history.
