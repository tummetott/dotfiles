# File reference format

When referencing files, always use paths relative to the current working directory.

Allowed formats:

- Whole file: `<path>`
- Single line: `<path>:<line>`
- Line range: `<path>:<start>-<end>`

Examples:
- `src/server/api.ts`
- `src/server/api.ts:42`
- `src/server/api.ts:42-57`

Rules:
- Use `<path>` when referring to the entire file.
- Use `<path>:<line>` when referring to a specific line.
- Use `<path>:<start>-<end>` when referring to a range.
- Never use absolute paths unless explicitly requested.
