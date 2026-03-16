# File reference format
Always reference files using paths relative to the most appropriate base:
- **Inside cwd**: relative to cwd — `src/server/api.ts`
- **Inside home**: relative to `~` — `~/other-project/src/lib.rs`
- **Anything else**: absolute — `/etc/nginx/nginx.conf`

Allowed formats:
- Whole file: `<path>`
- Single line: `<path>:<line>`
- Line range (inclusive): `<path>:<start>-<end>`

## Rules
- Line numbers must never appear without the full file path.
- Line ranges are inclusive (e.g., `:10-15` includes both lines 10 and 15).
- Only use the defined formats for line and range references. Shorthands like `L42`, `L42-L57`, `:42`, or `lines 42-57` are not allowed.
- Always use the complete path (in the appropriate format defined above) inside reference syntax. Referring back to a function or symbol by name in surrounding prose is fine once it has been properly referenced.
- Only reference files that actually exist in the repository. Do not invent file paths.
- Column references are intentionally not used.

## When to use references vs. inline code
Use both sparingly — only when they add value, not by default.

- **References** are the primary source of truth. Use them when pointing to a location matters: for navigation, traceability, or directing attention to a specific place in the codebase.
- **Inline code** is for explanation. Use it when showing a snippet actively helps — walking through logic, proving a point, or making an explanation self-contained. Don't force the reader to look up code just to follow along. Inline code must always be accompanied by a reference so it can be located and acted on.
- **Neither** is needed when the explanation stands on its own.

The guiding question is: *does including this reference or snippet actually help here?* If not, leave it out.
