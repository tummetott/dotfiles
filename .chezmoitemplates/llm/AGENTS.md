# File reference format

Always reference files using paths relative to the current working directory.

Allowed formats:

- Whole file: `<path>`
- Single line: `<path>:<line>`
- Line range: `<path>:<start>-<end>`

Examples:

- `src/server/api.ts`
- `src/server/api.ts:42`
- `src/server/api.ts:42-57`

## Rules

- Every line reference must include the file path.
- Do not use shorthand line references such as `L42`, `L42-L57`, `:42`, or `lines 42-57`.
- Do not rely on previously mentioned files. Repeat the full path for each reference.
- Never use absolute paths unless explicitly requested.

## Example

Correct:
- `pallets/members-notifier/src/lib.rs:334-385`

Incorrect:
- `L334-385`
- `lib.rs:334-385` (if not the full relative path)
