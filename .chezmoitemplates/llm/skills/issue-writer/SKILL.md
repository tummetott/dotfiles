---
name: issue-writer
description: write a markdown security issue for an already identified vulnerability. use when asked to write an issue, draft an issue, or turn a finding into a polished report entry.
---

Write a markdown issue report for an already identified vulnerability.

Use this exact structure and no other headings:

~~~markdown
[<severity>] <issue-title>

## Background
## Issue Description
## Risk
## Mitigation Suggestion
~~~

Severity must be one of `Info`, `Low`, `Medium`, `High`, or `Critical`.

Do not introduce any additional markdown headings or subheadings anywhere in the output. If emphasis is useful, use **bold** text inline.
The final response must contain only a single outer `~~~markdown` fenced block, with no text before or after it. This wrapper is for chat display only and must not be included when writing the issue to a file.

## Output requirements

`## Background` must be brief, usually about two sentences, and serve as an executive summary for readers who are not familiar with the project. This section is meant for the report and is not shared with the client in GitHub. The first sentence should explain the purpose of the affected module, component, pallet, hook, or subsystem. The second sentence should explain the role of the affected function, method, validation step, accounting path, state transition, or execution flow relevant to the issue. Keep this section neutral and contextual. Do not argue the bug here.

`## Issue Description` must explain the bug in clear, self-contained prose. In most cases, follow this flow:

1. identify the relevant code path or check,
2. explain what the current logic does,
3. explain the incorrect, missing, or inconsistent assumption,
4. describe how the bug can be triggered, and
5. explain why the resulting behavior is unsafe or incorrect.

The report should be understandable without requiring the reader to open the links. When useful, include a compact concrete scenario, a short ordered sequence, or a small state snapshot to make the failure mode obvious.

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

Use links as durable references so readers can locate the code being discussed. Use only the minimum set of code references needed to explain the issue clearly.

## Inline code excerpts

When the issue depends on a specific code fragment, include both a permalink and a small inline excerpt immediately afterwards in a fenced code block with syntax highlighting. The report must remain understandable without requiring the reader to open the links.

Inline code especially when a specific condition, missing check, state transition, ordering issue, or accounting bug is central to the explanation. Keep excerpts short and focused on the lines needed to support the argument. Do not inline large code blocks unnecessarily.
Use normal triple backticks for all inner code fences so they remain nested inside the outer `~~~markdown` block.

## File output

When writing the issue to a file, save it in the top level of the current working directory. The filename must be derived from the issue title as a short kebab-case slug, not the raw title.

Normalize filenames as follows:

* lowercase everything
* replace spaces and other separators with `-`
* remove characters that are not letters, numbers, or `-`
* collapse repeated dashes into a single `-`
* trim leading and trailing dashes
* prefix the filename with the severity
* suffix the filename with `-issue.md`
* ensure the full filename is no longer than 35 characters
* if needed, aggressively shorten the title slug semantically rather than preserving the full title literally

Use this format:

`<severity>-<title-slug>-issue.md`

Examples:

* `high-missing-access-control-issue.md`
* `medium-incorrect-reward-accounting-issue.md`

## Working approach

Write the title and the four required sections only.

Start by identifying the minimum set of code locations needed to explain the bug. Then:

* write a brief background for non-experts,
* explain the issue through the concrete code path,
* include a short code excerpt when it materially improves comprehension,
* walk through the broken assumption and trigger scenario,
* describe the realistic impact in system context, and
* finish with a concrete mitigation suggestion that restores the intended invariant or safety property.

Match the tone of a professional security audit finding: technical, restrained, specific, and easy to verify.
