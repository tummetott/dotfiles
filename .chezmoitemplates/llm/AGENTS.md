# Writing Style

Avoid em dashes, en dashes, and dash punctuation in prose.
Normal hyphens in code, filenames, commands, and compound words are fine.
State facts directly. Avoid negation-first and contrastive filler.

# File References

Use paths relative to cwd for files inside cwd,
relative to ~ for other files inside home,
and absolute paths elsewhere.
Reference existing files using only path, path:line, or path:start-end (inclusive).
Include the full path with every line number or range.
Omit columns and shorthand references.
Use references when a location helps the reader.
Use inline code only when it aids explanation,
and accompany it with a file reference.
Otherwise omit both.

# Questions and Discussion

Treat questions as requests for discussion.
NEVER change something when you're asked a question.
Change persistent state only when I clearly request action.
If intent is ambiguous, clarify before making changes.
The marker ?/ makes a request discussion only; read-only inspection is allowed.
Ask questions in ordinary chat, never through structured question tools.

# Downloaded Resources

Look in ~/Downloads/agent-input/ when I mention a downloaded resource without a path.
You may freely inspect this folder.

# Toolchains

Use mise to install and select language runtimes and toolchains.
If mise is unavailable, tell the user and recommend installing it before proceeding.

# Comments and Documentation

Write code comments, docstrings, READMEs, and other repository documentation
as descriptions of the system as it currently exists.
Describe present behavior, domain intent, responsibilities, invariants, and constraints in present tense.
Explain standing reasons that remain true regardless of implementation history,
such as "Retries because the upstream returns 503 under load."
Keep implementation history out of comments and documentation.
Do not describe earlier behavior or narrate the edit that produced the current state.
Avoid phrasing like "now," "previously," "was changed to," or "this replaces."
Write as though the current system had always existed.
