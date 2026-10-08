---
name: markdown-line-breaks
description: "Use when writing or editing prose in a Markdown file (.md, .mdx, README, docs, notes). Skip for non-Markdown files, for generated Markdown, and for prose destined for an issue, PR or chat message."
---

# Markdown Line Breaks

Prose in Markdown files uses semantic line breaks:
one line per sentence,
and within a long sentence a break at each clause boundary,
meaning a comma, a conjunction, or the start of a subordinate clause.

Line length carries no meaning.
A line may be 30 characters or 110.
Never break at a column limit,
never reflow a paragraph to even out its margins,
and never leave a line holding a single stranded word.
A line running much past 100 characters is a symptom rather than a violation,
and usually means a clause boundary was missed.

This keeps a diff to the sentences that actually changed.
Column-based wrapping reflows every following line of a paragraph
when one word is inserted near its start,
which buries the edit.

Consecutive lines render as one paragraph under CommonMark,
so the breaks are invisible in the rendered output.
A blank line still separates paragraphs.

Leave existing files alone unless the task is to rewrite them.
Converting a column-wrapped paragraph rewrites all of it,
which is the diff noise this rule exists to avoid.
Match the surrounding style instead.
