---
name: python-mcp-server-design
description: Reference for designing an MCP server written in Python with FastMCP. Use when writing or designing a new Python MCP server, or adding tools to one.
dependencies: uv, fastmcp
---

# Writing Python MCP Servers with FastMCP

A reference for how to design an MCP server written in Python with FastMCP.

## Structure as an idiomatic Python package

Lay the server out as a real Python package under `src/<package>/`, with a
`pyproject.toml` declaring dependencies and the entry point. Split concerns
into separate modules rather than a single file: domain logic, subprocess or
runner helpers, schema and data types, and the tool definitions. Scale the
structure with the server; a small server can be one module, but let it grow
into modules as concerns accumulate.

Keep the `@mcp.tool` functions thin. A tool is an adapter: it takes the request,
delegates to a plain core function that does the actual work with ordinary
arguments and return values, and shapes the result for the client. The core
carries no MCP concepts, so it is testable without the MCP layer and reusable
behind other adapters.

The same core can back a command-line adapter that parses arguments, calls the
core, and sets an exit code. Do not make the `@mcp.tool` function itself the CLI
entry point: the two interfaces have different I/O contracts, error semantics,
and progress channels, and the MCP `Context` has no meaning on the command line.
Whether a CLI adapter exists at all is a per-server decision.

## Run from canonical location with uv

Run the server via `uv`, from its canonical source location, never from a copy.
A copy is complete and current only as of whatever last produced it; any drift
fails silently. Executing from the source tree removes that failure class
instead of forcing you to keep a copy correct.

Install it with `uv tool install --editable`. An editable install exposes the
entry point on `PATH` while keeping `__file__` pointed at the source tree, so
the server always runs from canonical location. A regular install builds a copy
into an isolated environment, reintroducing the drift it is the whole point to
avoid.

A consequence of running from source: ordinary code edits take effect on the
next server-process start, with no reinstall. Only dependency or entry-point
changes require reinstalling.

## Design the whole server async

Clients impose a request timeout on every MCP tool call (OpenCode's is a
hardcoded ~60s). The client resets that timer each time the tool sends a
progress notification (a heartbeat). So any tool that can run longer than the
timeout must send periodic heartbeats, or the client aborts the call while the
work is still running.

A heartbeat can only be sent while the call is in flight, which requires the
tool to yield control mid-work, so it must be `async`. A synchronous tool holds
the thread until it returns and can never emit a heartbeat.

Design the entire server async from the start. A single blocking call anywhere
in an async tool stalls the event loop, which stalls the heartbeat and
reintroduces the timeout. Drive external processes and I/O with their async
equivalents; offload unavoidable blocking work (CPU-bound parsing, sync-only
libraries) to a worker thread so the loop stays free to emit heartbeats.

## Emit progress heartbeats

A tool receives a `Context` by declaring it as a typed parameter. The context
carries the progress-reporting channel.

The `Context` parameter is dependency-injected by FastMCP from its type
annotation. It is not part of the tool's public input schema, so the model and
client never see it or supply it. Only the annotation matters, not the
parameter name.

```python
from fastmcp import Context

@mcp.tool
async def scan(target: str, ctx: Context) -> dict:
    async for step in run_work(target):
        await ctx.report_progress(progress=step.done, total=step.total)
    return step.result
```

Send a heartbeat on a fixed interval while long work runs. Resetting the client
timer only requires that a notification arrives; the value and message can be a
placeholder. Where the work exposes real progress, report it, so the same
mechanism also drives an accurate progress indicator.

Heartbeats are best-effort. A heartbeat can fail independently of the work (a
disconnected client, a transport error), and sending one must never abort work
that is otherwise succeeding. Swallow heartbeat failures rather than
propagating them.
