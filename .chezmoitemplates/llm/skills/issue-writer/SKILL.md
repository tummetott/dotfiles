---
name: issue-writer
description: write a markdown security issue for an already identified vulnerability. use when asked to write an issue, draft an issue, or turn a finding into a polished report entry.
---

Write a markdown issue report for an already identified vulnerability.

## Template

Use this exact file structure:

```markdown
---
attack_scenario: "An attacker does..."
classification: "VLN-X: YZW"
component: "Runtime configuration / Pallet X / etc"
commit: ""
tracking: ""
unique_id: ""
attack_impact: ""
status: "Open"
---

[<severity>] <issue-title>

## Background
## Issue Description
## Risk
## Mitigation Suggestion
```

Every report begins with the YAML frontmatter shown above, followed by the title and the four required sections.

Severity must be one of `Info`, `Low`, `Medium`, `High`, or `Critical`.

Do not introduce any additional markdown headings or subheadings anywhere in the output. If emphasis is useful, use **bold** text inline.

## Frontmatter

Every issue file starts with the YAML frontmatter shown above, followed by the issue title and the four required sections.

Fill the frontmatter as follows:

* `attack_scenario` is one short sentence, or at most two short sentences, in prose and starts with `An attacker does...`.
* Keep `attack_scenario` brief and concrete. State the attacker action and the immediate consequence only. Do not include extended reasoning, background, root-cause analysis, or speculative implementation history in this field.
* `classification` must be one of the classifications listed below.
* `component` names the affected area, such as `Runtime configuration`, a pallet, module, package, service, library, or another concrete subsystem.
* If multiple components are affected, list them in the same field and separate them with commas.
* `commit` is the audit commit where the issue was found. Use the same commit hash used for GitHub permalinks in the report.
* `tracking` is empty when first drafting the issue unless the user provides a tracking link. When updating an existing issue and the user provides a GitHub, Jira, or similar tracking link, insert it here.
* `unique_id` is empty when first drafting the issue unless the user provides it. When `tracking` is a GitHub issue URL, set `unique_id` to the final numeric path segment from that URL (the issue number).
* `attack_impact` comes from the threat model when one is available. Use the exact threat identifier from the threat model, not a paraphrase.
* `status` defaults to `Open`. When updating an existing issue and the user provides a different status, update this field to the provided value. Allowed values are `Open`, `Acknowledged`, `Risk accepted`, `Partially mitigated`, and `Mitigated`.

For `attack_impact`, follow this workflow:

* If a threat model is available, look for the closest matching existing threat.
* If a strong match exists, set `attack_impact` to the exact threat identifier from the threat model.
* If no threat model is available, or if the available threat model does not contain a strong match, continue writing the issue and leave `attack_impact` empty.
* After writing the file, ask the user to provide the threat model if none was available, or propose a new threat for review if no strong match was found.
* If the user later approves a proposed new threat or provides the threat model, update the issue file and set `attack_impact` accordingly.

Use one of these classifications for `classification`:

* `VLN-1: Insufficient Existential Deposit`  
  Inadequate existential deposits can lead to denial-of-service attacks by filling blockchain storage, because accounts below the deposit are reaped to conserve space.
* `VLN-2: XCM Exploitation`  
  Denial-of-service attacks via XCM can disrupt parachains or the relay chain, so untrusted incoming XCM messages and `XCMFeeManager` integrations need correct handling.
* `VLN-3: Reliance on On-Chain Randomness`  
  Weak on-chain randomness can be exploited to predict or control critical outcomes.
* `VLN-4: Incorrect Benchmarking`  
  Incorrect or missing benchmarking can underestimate execution cost or database access, which can lead to overweight blocks and spam conditions.
* `VLN-5: Unsafe Arithmetic`  
  Unsafe arithmetic can cause overflows or underflows that produce incorrect accounting, invalid state transitions, or other unexpected states.
* `VLN-6: Unsafe Conversion`  
  Unsafe conversion from larger to smaller values can lose precision or overflow, leading to incorrect calculations and unexpected states.
* `VLN-7: Reachable Panic`  
  Reachable panics, including `panic!`, `unwrap()`, or decoding without depth limits, can turn malformed or adversarial input into denial of service.
* `VLN-8: Insecure Cryptography`  
  Insecure cryptographic libraries, primitives, or integration choices can compromise the chain's security assumptions.
* `VLN-9: Storage Exhaustion`  
  Adversaries can try to fill blockchain storage cheaply, making node operation unsustainable unless storage growth is priced or bounded correctly.
* `VLN-10: Abusable unsigned and Pays::No calls`  
  Unsigned extrinsics or calls that return `Pays::No` can often be abused for spam if admission and rate-limiting controls are insufficient.
* `VLN-11: Outdated Crates`  
  Outdated Rust crates can carry known bugs or invalid behavior that introduces avoidable security risk.
* `VLN-12: Consumers/Providers/Sufficients`  
  Complex entity existence and reference counting logic can be mishandled, leading to broken lifecycle guarantees or blocked state transitions.
* `VLN-13: Incorrect Slashing Logic`  
  Ineffective, incomplete, or bypassable slashing undermines incentives against misbehavior in security-critical roles.
* `VLN-14: Replay Issues`  
  Nonce or replay protection mistakes can permit transaction replay, spam, or double-spend style failures.
* `VLN-15: Insecure Business Logic`  
  Protocol-level logic flaws allow otherwise valid actions to violate intended invariants, incentives, or safety assumptions.
* `VLN-16: Incorrect Rewarding Logic`  
  Ineffective, incomplete, or bypassable rewarding logic undermines incentives for honest participation.

Use the descriptions only to choose the closest matching classification based on the issue's root cause. Set `classification` to the classification label exactly as written above, and do not copy the explanatory description into the frontmatter.

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

Prefer written-out text over bullet points. Use bullet points only when they materially improve clarity. Write in polished, precise prose and keep the reasoning self-contained. Do not invent facts or overstate certainty. If some detail is unclear, qualify that point explicitly while still producing the strongest accurate draft possible from the available context. Match the tone of a professional security audit finding: technical, restrained, specific, and easy to verify.

## Code references

Always reference relevant code with GitHub permalinks. Use the repository in the current working directory and pin links to the currently checked out commit, not a branch name. Every permalink must include exact line numbers or ranges, and raw URLs must be hidden behind human-readable markdown link text.

Example:

```
The [`pre_inherents()`](https://github.com/example/repo/blob/<commit>/path/to/file.rs#L98-L166) hook inside the in-instructions pallet ...
```

Use links as durable references so readers can locate the code being discussed. Use only the minimum set of code references needed to explain the issue clearly.

## Inline code excerpts

When the issue depends on a specific code fragment, include both a permalink and a small inline excerpt immediately afterwards in a fenced code block. Always include an explicit language identifier after the opening backticks. The report must remain understandable without requiring the reader to open the links.

Inline code especially when a specific condition, missing check, state transition, ordering issue, or accounting bug is central to the explanation. Keep excerpts short and focused on the lines needed to support the argument. Do not inline large code blocks unnecessarily.
Use normal triple backticks for any code fences inside the issue file.

## File output

Write the issue directly to a file in the top level of the current working directory. The filename must be derived from the issue title as a short kebab-case slug, not the raw title.

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

Do not print the issue body to stdout. Write the issue content only to the file.

## Final checklist

Before finishing, confirm that the issue:

* is written to a file only
* includes the required frontmatter
* uses the required title line and the four required sections
* uses pinned GitHub permalinks with line numbers / ranges
* keeps the tone technical, restrained, and specific
