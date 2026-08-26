---
name: vuln-analysis
description: Evidence-driven workflow for identifying potential vulnerabilities and logic bugs in a specified source file (optionally focusing on a specific symbol).
---

# Code Vulnerability Identification Workflow

## 0. Purpose

Analyze one primary source file (optionally one function/method/type within it) to identify potential vulnerabilities and logic/correctness bugs. Build a concrete model of data flow, trust boundaries, and invariants by tracing backward (inputs/callers) and forward (effects/sinks). Produce a prioritized, evidence-backed list of issues with defensible remediation and test ideas.

Non-goals:
- Do not attempt exploit development, payload crafting, or step-by-step abuse instructions.
- Do not perform a whole-repo “scan”; traversal must stay driven by reachability and evidence needs.

## 1. Requirements (inputs you must obtain)

You must obtain:
- Primary file path (repo-relative).
- Target focus (optional): function/method/type name or symbol signature in that file.

If the user does not provide the primary file path, ask for it.

If available and quick to ask for, also capture (optional):
- Runtime context (server/CLI/library), auth model assumptions, and primary trust boundary (e.g., public HTTP handler vs internal job).
- Language/framework version constraints that affect semantics (e.g., unsafe blocks, serializer behaviors).

## 2. Workflow

This skill should use the `$audit-context-and-vuln-discovery` skill for repository orientation and efficient cross-file navigation.

Scope rule (maximum depth, no restriction):
- You may open and analyze any other file needed to fully understand call chains, data flows, invariants, and reachability.
- When following cross-file symbols, preserve continuity (caller → callee → return) and cite paths + line ranges for each hop.

Evidence standard (anti-handwavy):
- Every substantive claim must include file path + line range.
- If you cannot cite, label it **Assumption** and list exactly what to inspect to confirm/deny.
- Maintain a “global model” (state, trust boundaries, invariants, capabilities). Update it explicitly when contradicted.

Output goal:
- A prioritized list of **potential** vulnerabilities and logic bugs, grounded in evidence.
- Each item includes confidence (Confirmed / Probable / Needs confirmation) and why.

### 2.1 Orientation anchored on the primary file

1) Explain responsibilities:
- Summarize what the file does and where it sits (layer/module).
- Enumerate entrypoints in this file (public/exported functions, handlers, trait impls, exposed methods, RPC endpoints, CLI commands).

2) Identify trust boundaries and untrusted inputs:
- Enumerate attacker-influenced inputs relevant to this file (network, IPC, file, env, DB rows, cache, message bus).
- Note parsing/deserialization boundaries and any schema/validation points.

3) Map key state and side effects:
- State touched (reads/writes): DB tables, caches, global state, filesystem, in-memory maps, session/auth state.
- External dependencies: libraries/services, RPCs, shelling out, crypto, serialization codecs.
- Side effects: logging, metrics, events, network calls.

Deliverable: a short “File Model” section containing (a) entrypoints, (b) trust boundaries, (c) state/effects.

### 2.2 Execution spine selection (what to deep-analyze)

Choose the smallest set of “spine” functions reachable from the primary file that are risk-critical, including those that:
- Gate authn/authz or permissions
- Parse/deserialize attacker-controlled input
- Perform privileged state transitions (money/accounting/roles/ownership)
- Interact with external systems (DB/RPC/files/contracts/queues)

For each spine function, output:
- Symbol + file path + line range
- Why it is risk-critical
- Its inbound entrypoints (and how they reach it), with citations

### 2.3 Deep micro-analysis (max depth, evidence-driven)

For each spine function:

A) Purpose (2+ sentences):
- What it is intended to do and what it actually does (based on code).

B) Inputs & assumptions:
- List key inputs and constraints (types, nullability, bounds, encoding).
- List at least 5 explicit assumptions, but only where meaningful (otherwise “N/A”), and cite where each is enforced or relied upon.

C) Outputs & effects:
- Return values, mutations, writes, emitted events, external calls.

D) Block-by-block analysis with invariants:
- Walk through the function’s logic in blocks.
- Identify at least 3 invariants where applicable (or explain why fewer), and justify ordering constraints (TOCTOU risks, partial failure, rollback behavior).

E) External call analysis:
- For each external call (DB, RPC, filesystem, crypto, serializer), treat it as adversarial/fragile unless guarantees are explicit.
- Note failure modes, retry semantics, timeouts, and partial state hazards (double-writes, reentrancy patterns, idempotency).

While tracing callees across files:
- Preserve continuity and keep a running call chain summary with citations.
- Propagate validated invariants and downgrade unvalidated ones to **Assumption**.

### 2.4 Vulnerability + logic bug discovery (deliverable)

Using the proven model, enumerate candidate issues and validate each with:
- Reachability (how attacker influence enters and reaches the vulnerable point)
- Missing/incorrect check (which invariant/guard fails or is absent)
- Concrete evidence (paths + line ranges, call chain)

Classify each issue as: **Confirmed / Probable / Needs confirmation**.

For each issue, output:
- Title
- Type/Class (security or logic/correctness)
- Severity (High/Med/Low) with a one-line rationale
- Affected code (paths + line ranges)
- Preconditions / attacker influence (defensive, non-weaponized)
- Mechanism (what/why; which invariant/check fails)
- Impact (CIA and/or correctness/economic/reliability)
- Evidence (call chain summary with citations)
- Remediation guidance (principles + options; prefer minimal diffs + defense-in-depth)
- Regression test ideas (high-level assertions, not exploitation steps)

Prioritization rules:
- Prioritize by (1) attacker control, (2) impact magnitude, (3) ease of triggering under realistic conditions, (4) blast radius.

### 2.5 Stop condition (avoid infinite repo traversal)

Continue cross-file chasing until:
- The issue is Confirmed or convincingly ruled out, OR
- You hit an external dependency with no source, OR
- Additional chasing yields no new constraints on reachability/invariants.

When stopping due to external/unknown dependency or diminishing returns:
- Add an “Evidence Needed” subsection specifying exactly what to inspect (symbol/file/config/runtime behavior) to reach Confirmed/ruled-out.

## 3. Output format (strict)

Return results in this order:
1) File Model (entrypoints, trust boundaries, state/effects)
2) Spine Functions (table-like bullets: symbol, location, risk reason, inbound entrypoints)
3) Issues (prioritized list, each fully structured as in 2.4)
4) Evidence Needed (only if any “Needs confirmation” remain)
