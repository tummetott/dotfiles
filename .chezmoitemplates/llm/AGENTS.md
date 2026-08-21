# Writing Style

Never use em dashes or en dashes in prose. Avoid dash based sentence punctuation entirely. Prefer commas, parentheses, or separate sentences instead. Normal hyphens in code, compound words, commands, filenames, and technical terms are fine.

Avoid negation-first or contrastive filler constructions (e.g., "X, not Y", "this isn't theoretical", "is not cosmetic"). State facts directly and positively.

# File reference format
Always reference files using paths relative to the most appropriate base:
- **Inside cwd**: use paths relative to cwd, for example `src/server/api.ts`
- **Inside home**: use paths relative to `~`, for example `~/other-project/src/lib.rs`
- **Anything else**: use absolute paths, for example `/etc/nginx/nginx.conf`

Allowed formats:
- Whole file: `path`
- Single line: `path:line`
- Line range (inclusive): `path:start-end`

## Rules
- Line numbers must never appear without the full file path.
- Line ranges are inclusive (e.g., `:10-15` includes both lines 10 and 15).
- Only use the defined formats for line and range references. Shorthands like `L42`, `L42-L57`, `:42`, or `lines 42-57` are not allowed.
- Always use the complete path (in the appropriate format defined above) inside reference syntax. Referring back to a function or symbol by name in surrounding prose is fine once it has been properly referenced.
- Only reference files that actually exist in the repository. Do not invent file paths.
- Column references are intentionally not used.

## When to use references vs. inline code
Use both sparingly, only when they add value, not by default.

- **References** are the primary source of truth. Use them when pointing to a location matters: for navigation, traceability, or directing attention to a specific place in the codebase.
- **Inline code** is for explanation. Use it when showing a snippet actively helps — walking through logic, proving a point, or making an explanation self-contained. Don't force the reader to look up code just to follow along. Inline code must always be accompanied by a reference so it can be located and acted on.
- **Neither** is needed when the explanation stands on its own.

The guiding question is: *does including this reference or snippet actually help here?* If not, leave it out.

# Comments and Documentation

Write code comments, docstrings, READMEs, and other repository documentation as descriptions of the system as it currently exists. Comments and documentation state the current, settled truth about the system, independent of the edits that produced it, so a change leaves the codebase reading as if it had always been written that way.

Distinguish two kinds of "why". A standing reason is a constraint that holds regardless of history, for example "retries because the upstream returns 503 under load" or "clamps to zero because negative values corrupt the index", and belongs in the text permanently. A change reason explains a past edit, for example "no longer does X" or "changed from Y". It describes a state the reader cannot see, drifts out of truth the moment the next edit lands, and becomes noise. Keep the first, drop the second.

Guidelines:
- Describe present behavior, domain intent, invariants, constraints, and responsibilities.
- Use present-tense, state-based language.
- Avoid implementation-history phrasing tied to prior versions (e.g., "now", "previously", "was changed to", "refactored to", "this replaces", "does X instead of Y").
- Reserve implementation history for artifacts whose purpose is to record it, such as migration notes, release notes, commit messages, and compatibility guidance, where the change itself is the point.

Prefer describing what the system does:
- "Uses a cache to avoid repeated lookups."
- "The parser validates signatures before parsing payload data."
- "Retry logic bounds retry attempts and backs off between failures."
