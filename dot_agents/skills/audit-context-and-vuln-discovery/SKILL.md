---
name: audit-context-and-vuln-discovery
description: Ultra-granular, evidence-driven code auditing workflow that first builds deep architectural context, then systematically discovers, validates, and documents vulnerabilities without exploit development.
---

# Deep Context + Vulnerability Discovery Skill (Ultra-Granular, Evidence-Driven)

## 0. Purpose

This skill defines a two-stage audit workflow:

1) **Context Building (Pure Understanding):** bottom-up, line-by-line comprehension that builds a stable architectural and behavioral model.
2) **Vulnerability Discovery (Evidence-Based):** systematic identification, validation, and documentation of security issues grounded in the context model.

This skill is optimized for:
- Complex, high-risk codebases (crypto, authn/z, parsers, distributed systems, kernel/userland boundaries).
- Reducing false positives and “vibes-based” findings.
- Producing audit-grade artifacts (evidence, invariants, threat models, testable hypotheses).

Constraints:
- Do not provide exploit development, weaponization, or step-by-step instructions for abuse.
- Do not rely on speculation. If uncertain, state “Unclear; need to inspect X” and list evidence needed.

---

## 1. Operating Principles

### 1.1 Evidence First
- Every claim should be anchored to:
  - file path + line numbers (or exact function signatures), and
  - observable behavior (control flow, data flow, state transitions), and
  - explicit assumptions.

If you cannot cite evidence, label the statement as an assumption.

### 1.2 Micro-First, Then System
- Default to **block-by-block / line-by-line** analysis for non-trivial code.
- Continuously link: line → block → function → module → system flows.

### 1.3 Stability & Anti-Contradiction
- Maintain and update a persistent global model.
- When contradicted: “Earlier I thought X; now Y, because evidence Z.”

### 1.4 Trust Boundaries Are Real
- Treat all external inputs and dependencies as adversarial until proven otherwise:
  - user input, network, file formats, env vars, IPC, plugins, callbacks, oracles, external contracts/services.

---

## 2. When to Use

Use for:
- Security audits, architecture review, threat modeling.
- High assurance reviews where correctness matters.

Avoid for:
- Quick Q&A, shallow code review, implementation-only tasks.

---

## 3. Phases Overview

### Phase 1 — Initial Orientation (Bottom-Up Scan)
Goal: establish anchors (modules, entrypoints, state, actors) without guessing.

### Phase 2 — Ultra-Granular Context Building (Micro-Analysis)
Goal: derive accurate local invariants and correct mental model of critical functions.

### Phase 3 — Global System Understanding (Invariants + Flows)
Goal: reconstruct system workflows, state transitions, and trust boundaries.

### Phase 4 — Vulnerability Discovery (Hypotheses → Validation → Evidence)
Goal: generate candidate issues, validate them, and document audit-grade findings.

### Phase 5 — Triage & Report-Ready Findings (No Exploit Dev)
Goal: prioritize, classify, and produce remediation-oriented outputs.

---

## 4. Phase 1 — Initial Orientation (Bottom-Up Scan)

Perform a minimal mapping:

1. **Major modules/files**
   - responsibilities, relationships, boundaries

2. **Externally reachable entrypoints**
   - HTTP handlers, RPC, CLI, public library APIs, on-chain public/external functions, cron jobs, message queue consumers

3. **Actors**
   - users, admins, relayers, signers, services, third parties, contracts, “system” components

4. **State**
   - storage variables, DB tables, caches, key-value stores, config, global singletons, session stores

5. **Preliminary call graph**
   - top entrypoints → core functions → external dependencies

Output should include explicit file paths and line citations.

---

## 5. Phase 2 — Ultra-Granular Function Analysis (Default Mode)

Every non-trivial function receives a structured micro-analysis.

### 5.1 Per-Function Microstructure Checklist

For each function:

1) **Purpose**
- Why it exists, its role in the system, what it must guarantee.

2) **Inputs & Assumptions**
- Parameters and implicit inputs (state, sender, env, time, randomness, config).
- Preconditions and constraints (type, range, encoding, authentication).
- Trust assumptions (who controls what).

3) **Outputs & Effects**
- Returns, state writes, events/logs, external calls, error handling behaviors.

4) **Block-by-Block / Line-by-Line Analysis**
For each logical block:
- What it does.
- Why it is ordered here.
- Assumptions it relies on.
- Invariants established/maintained.
- What later logic depends on it.

Apply per block:
- **First Principles** (what must be true for safety/correctness?)
- **5 Whys / 5 Hows** (micro-level)

5) **Cross-Function Dependencies**
- Internal calls: jump into callee.
- External calls: treat as hostile unless code is available.

### 5.2 Continuity Rule (No Context Reset)
Treat the call chain as one execution. Propagate assumptions and invariants across boundaries.

### 5.3 External Calls — Two Cases

**Case A — Code Available**
Treat as internal:
- jump into target function
- continue micro-analysis

**Case B — True External / Black Box**
Analyze adversarially:
- enumerate outcomes: revert, malformed return, partial failure, latency, retries, inconsistent state, unexpected callbacks/reentrancy, misconfiguration
- record which assumptions the caller makes about the external dependency

---

## 6. Phase 3 — Global System Understanding

After enough micro-analysis:

1) **State & Invariant Reconstruction**
- Map reads/writes of each state element.
- Derive system invariants that must hold across functions.

2) **Workflow Reconstruction**
- Identify end-to-end flows (login, session refresh, deposit/withdraw, upgrade, governance action, etc.).
- Track step-by-step state transitions.

3) **Trust Boundary Mapping**
- Actor → entrypoint → privileged transitions → external dependencies.

4) **Complexity & Fragility Clustering**
- High branching, multi-step flows, coupled state, heavy parsing, concurrency, cryptography.

This output becomes the basis for vulnerability discovery.

---

## 7. Phase 4 — Vulnerability Discovery (Evidence-Based)

This phase is allowed and required in this skill.

### 7.1 Candidate Generation (Hypothesis Set)
Generate hypotheses systematically from the global model:

- **Input validation & parsing**
  - type confusion, length checks, encoding, canonicalization, numeric overflow/underflow, truncation, deserialization hazards

- **Authentication & authorization**
  - missing checks, confused deputy, privilege escalation, role misbinding, TOCTOU between check and use

- **State machine & invariants**
  - invariant violations, partial updates, inconsistent states, reordering hazards, unexpected transitions

- **External interactions**
  - unsafe assumptions, inconsistent error handling, retries causing duplicate effects, callback hazards/reentrancy, dependency trust issues

- **Concurrency & timing**
  - races, non-atomic sequences, deadlocks, inconsistent cache/DB, weak idempotency

- **Cryptography & signatures**
  - incorrect domain separation, nonce misuse, replay risk, ambiguous message formats, weak randomness assumptions

- **Resource & DoS**
  - unbounded loops, unbounded memory growth, expensive operations on attacker-controlled input, log amplification

- **Secrets & sensitive data**
  - logging, error messages, side-channel-ish leakage patterns, insecure storage

### 7.2 Validation Procedure (No Exploit Development)
For each candidate hypothesis:

1) **Locate the evidence**
- exact code locations with line ranges
- the specific control-flow and data-flow path

2) **Describe the unsafe condition**
- what inputs/states trigger it (high-level, non-weaponized)
- what invariant is violated

3) **Check preconditions**
- authentication, authorization, feature flags, config assumptions, environment dependencies

4) **Check reachable path**
- confirm there is a plausible entrypoint (direct or indirect)
- confirm attacker influence over required inputs/state

5) **Confirm consequences**
- impact described in terms of confidentiality/integrity/availability or correctness properties
- avoid instructions for abuse

6) **List tests to confirm**
- unit/integration tests suggested at a high level (no step-by-step exploit)
- specific assertions, expected failures, and invariant checks

### 7.3 Evidence Requirements (Per Finding)
Minimum required evidence for a “confirmed” vulnerability:
- entrypoint and path to the issue
- the exact check or invariant that fails
- proof of reachability (by call chain reasoning)
- at least one concrete scenario described at a safe, non-abusive level
If one of these is missing, label as “needs confirmation” and list what to inspect.

---

## 8. Phase 5 — Triage & Report-Ready Findings (Remediation-Oriented)

For each confirmed (or probable) issue:

1) **Title**
- crisp, specific, no sensational language

2) **Type / Class**
- e.g., authz bypass, invariant violation, unsafe external call assumption, parsing confusion, race condition

3) **Affected Components**
- files/functions/entrypoints

4) **Description (Mechanism)**
- what happens, why it happens, which invariant/check fails

5) **Impact (Non-Exploit)**
- confidentiality/integrity/availability implications, worst-case + typical case

6) **Likelihood / Preconditions**
- attacker capabilities required, environmental constraints, mitigations already present

7) **Evidence**
- line references and call chain summary

8) **Recommended Remediation (Principles + Options)**
- describe the corrective principle and a few implementation options
- do not provide exploit code or attack scripts

9) **Regression Tests**
- assertions that should pass after the fix

---

## 9. Output Formats

### 9.1 Context Output (Phases 1–3)
For each analyzed function:
- **Purpose** (≥2 sentences)
- **Inputs & Assumptions** (≥5)
- **Outputs & Effects**
- **Block-by-Block Analysis**
- **Cross-Function Dependencies**
- **Invariants** (≥3)
- **Open Questions / Evidence Needed**

### 9.2 Vulnerability Output (Phases 4–5)
For each finding:
- **Title**
- **Classification**
- **Affected code** (paths + line ranges)
- **Trigger/Preconditions** (non-weaponized)
- **Mechanism** (what + why)
- **Impact**
- **Evidence**
- **Remediation guidance**
- **Regression tests**

---

## 10. Completeness Checklist

Before concluding:

### Context Completeness
- All required sections present.
- Line-level citations for key claims.
- Invariants and assumptions explicitly enumerated.
- Call chain continuity maintained.

### Vulnerability Completeness
- Each finding has: reachability, failing check/invariant, impact, evidence.
- Uncertainties are labeled and tracked.
- No exploit development or step-by-step abuse instructions.

---

## 11. Non-Goals and Safety Constraints

While discovering vulnerabilities is in scope, the following are out of scope:
- exploit development, weaponization, payload crafting, attack scripts
- instructions intended to cause harm or unauthorized access

If a request drifts into the above, respond with a refusal and redirect to defensive testing and remediation.

---

