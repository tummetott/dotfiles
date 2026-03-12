---
name: issue-writer
description: write a markdown security issue for an already identified vulnerability. use when asked to write an issue, draft an issue, or turn a finding into a polished report entry.
---

Write a markdown issue report for an already identified vulnerability.

Use this exact structure and no other headings:

```markdown
[<severity>] <issue-title>

## Background
## Issue Description
## Risk
## Mitigation Suggestion
````

Severity must be one of `INFO`, `LOW`, `MEDIUM`, `HIGH`, or `CRITICAL`.

Do not introduce any additional markdown headings or subheadings anywhere in the output. If emphasis is useful, use bold text inline.

## Output requirements

`## Background` must be about two sentences and serve as an executive summary for readers who are not familiar with the project. This section is meant for the report and is not shared with the client in GitHub. The first sentence should explain the purpose of the affected module, component, or pallet. The second sentence should explain the role of the affected function, method, hook, extrinsic, or code path.

`## Issue Description` must explain the bug in clear prose. Describe what the vulnerable logic does, what assumption is incorrect or missing, how the bug can be triggered, and why the implementation is unsafe or incorrect. The writeup should be understandable without requiring the reader to click links.

`## Risk` must explain the practical impact in context. Focus on realistic consequences, not exaggerated worst-case outcomes. If impact depends on privileges, environmental assumptions, or specific preconditions, state that plainly.

`## Mitigation Suggestion` must give a practical remediation that addresses the root cause. Prefer actionable engineering guidance over vague advice. If there are multiple reasonable fixes, present the preferred one first.

## Writing style

Prefer written-out text over bullet points. Use bullet points only when they materially improve clarity. Write in polished, precise prose and keep the reasoning self-contained. Do not invent facts or overstate certainty. If some detail is unclear, qualify that point explicitly while still producing the strongest accurate draft possible from the available context.

## Code references

Always reference relevant code with GitHub permalinks. Use the repository in the current working directory and pin links to the currently checked out commit, not a branch name. Every permalink must include exact line numbers or ranges, and raw URLs must be hidden behind human-readable markdown link text.

Example:

```
The [`pre_inherents()`](https://github.com/example/repo/blob/<commit>/path/to/file.rs#L98-L166) hook inside the in-instructions pallet ...
```

Use links as durable references so readers can locate the code being discussed.

## Inline code excerpts

When the issue depends on a specific code fragment, include both a permalink and a small inline excerpt immediately afterwards in a fenced code block with syntax highlighting. The report should remain understandable without requiring the reader to open the links.

Inline code especially when a specific condition, missing check, state transition, ordering issue, or accounting bug is central to the explanation. Keep excerpts short and focused on the lines needed to support the argument. Do not inline large code blocks unnecessarily.

## Working approach

Write the title and the four required sections only. Start by identifying the minimum set of code locations needed to explain the bug. Then write the background for non-experts, explain the issue with precise code references, inline the key excerpt when it materially improves comprehension, describe the practical risk, and finish with a concrete mitigation suggestion.
