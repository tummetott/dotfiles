# Claude Code

Claude Code commonly launches MCP servers and hooks with the environment inherited from the Claude Code process, so already-exported variables are available without additional registration.

## Unpackaged Global Setup

**Skills**: place the canonical skill under `~/.agents/skills/<skill-name>/SKILL.md`, then symlink it into Claude Code's personal skills directory:

```sh
ln -sfn ~/.agents/skills/<skill-name> ~/.claude/skills/<skill-name>
```

This keeps the canonical location of skills compliant with the agent skills spec.

**MCP Servers**: register with user scope so it applies across every project:

```sh
claude mcp add --scope user <server-name> -- uv run --directory <project-path> <server-entrypoint>
```

This is stored under a top-level `mcpServers` key in `~/.claude.json`. To forward a specific variable by name rather than relying on inheritance, set it explicitly: a literal value with `--env KEY=value`, or by referencing the launching environment with `${VAR}` expansion in the stored entry, for example `"env": {"GITLAB_TOKEN": "${GITLAB_TOKEN}"}`.

**Hooks**: register in the user-level `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "<command>"
          }
        ]
      }
    ]
  }
}
```

Hooks registered there fire across every project.

## Workspace Package

**Activation**: `cd <repository> && claude` discovers and activates the package automatically from the checkout.

**Skills**: store each canonical skill under `.agents/skills/<skill-name>/`, then expose it to Claude Code through a repository-contained relative symlink:

```text
.claude/skills/<skill-name> -> ../../.agents/skills/<skill-name>
```

The symlink is part of the repository, using a relative path so it resolves only within the checkout, not the user's home directory.

**MCP Servers**: register at the repository root in `.mcp.json`:

```json
{
  "mcpServers": {
    "<server-name>": {
      "command": "uv",
      "args": ["run", "--project", "<project-path>", "<server-entrypoint>"]
    }
  }
}
```

**Hooks**: hooks are shell commands registered against agent events in configuration files, with implementations stored separately under `.agents/hooks/`. Register hooks in the repository root configuration, `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": ".agents/hooks/<hook-name>"
          }
        ]
      }
    ]
  }
}
```

## Installable Package

**Plugin Manifest**: create the manifest at `plugins/<plugin-name>/.claude-plugin/plugin.json`:

```json
{
  "name": "<plugin-name>",
  "description": "Short package description.",
  "version": "0.1.0",
  "author": {
    "name": "<author-or-team>"
  }
}
```

**Skills**: store package-owned skills under `plugins/<plugin-name>/skills/<skill-name>/`.

**MCP Servers**: register at the plugin root, `plugins/<plugin-name>/.mcp.json`, using `${CLAUDE_PLUGIN_ROOT}` to locate bundled files regardless of where the plugin was installed:

```json
{
  "mcpServers": {
    "<server-name>": {
      "command": "uv",
      "args": ["run", "--project", "${CLAUDE_PLUGIN_ROOT}", "<server-entrypoint>"]
    }
  }
}
```

**Hooks**: store bundled implementations under `plugins/<plugin-name>/hooks/` and register them in the plugin's `hooks/hooks.json`, using the same schema shown under Workspace Package above, with commands prefixed by `${CLAUDE_PLUGIN_ROOT}`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/<hook-name>"
          }
        ]
      }
    ]
  }
}
```

**Marketplace**: publish through a Claude Code marketplace at `.claude-plugin/marketplace.json`:

```json
{
  "name": "<marketplace-name>",
  "owner": {
    "name": "<owner-or-team>"
  },
  "plugins": [
    {
      "name": "<plugin-name>",
      "source": "./plugins/<plugin-name>",
      "description": "Short package description.",
      "version": "0.1.0",
      "author": {
        "name": "<author-or-team>"
      }
    }
  ]
}
```

**Activation**:

```sh
claude plugin marketplace add ./.claude-plugin/marketplace.json
claude plugin install <plugin-name>@<marketplace-name>
```
