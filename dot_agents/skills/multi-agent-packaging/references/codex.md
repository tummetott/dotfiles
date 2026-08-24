# Codex

Codex does not automatically expose every environment variable to launched MCP servers. Declare it explicitly in the Codex MCP registration using one of two keys: `env_vars` forwards an existing variable from the launching environment by name, without declaring, storing, or supplying its value, use it for secrets, API keys, tokens, and anything else that already lives in the shell or CI environment. `env` sets a literal value directly in the config instead, use it for non-secret flags or defaults that don't depend on the launching environment.

## Unpackaged Global Setup

**Skills**: place the canonical skill under `~/.agents/skills/<skill-name>/SKILL.md`.

**MCP Servers**: register with the CLI, which writes to the user-level `~/.codex/config.toml`:

```sh
codex mcp add <server-name> -- uv run --directory <project-path> <server-entrypoint>
```

To forward an existing shell variable by name rather than a literal value, add `env_vars` to the resulting entry by hand, the CLI only supports literal `--env KEY=VALUE` values:

```toml
[mcp_servers.<server-name>]
command = "uv"
args = ["run", "--directory", "<project-path>", "<server-entrypoint>"]
env_vars = ["GITLAB_TOKEN"]
```

**Hooks**: register in that same user-level `~/.codex/config.toml`:

```toml
[[hooks.PreToolUse]]
matcher = "Bash"

[[hooks.PreToolUse.hooks]]
type = "command"
command = "~/.agents/hooks/<hook-name>"
timeout = 30
statusMessage = "Running hook"
```

Both MCP servers and hooks registered there apply across every project.

## Workspace Package

**Activation**: `cd <repository> && codex` discovers and activates the package automatically from the checkout.

**Skills**: Codex discovers the canonical skill from `.agents/skills/<skill-name>/`.

**MCP Servers**: register in the repository root configuration, `.codex/config.toml`:

```toml
[mcp_servers.<server-name>]
command = "uv"
args = ["run", "--project", "<project-path>", "<server-entrypoint>"]
env_vars = ["GITLAB_TOKEN"]
```

**Hooks**: hooks are shell commands registered against agent events in configuration files, with implementations stored separately under `.agents/hooks/`. Register hooks in the repository root configuration, `.codex/config.toml`:

```toml
[[hooks.PreToolUse]]
matcher = "Bash"

[[hooks.PreToolUse.hooks]]
type = "command"
command = ".agents/hooks/<hook-name>"
timeout = 30
statusMessage = "Running hook"
```

## Installable Package

Codex defines `${PLUGIN_ROOT}` (aliased as `${CLAUDE_PLUGIN_ROOT}`) but expands it only for hooks, not MCP server commands (a known bug). Reaching canonical location for an MCP server command therefore requires a workaround.

**Plugin Manifest**: create the manifest at `plugins/<plugin-name>/.codex-plugin/plugin.json`:

```json
{
  "name": "<plugin-name>",
  "version": "0.1.0",
  "description": "Short package description.",
  "author": {
    "name": "<author-or-team>"
  },
  "skills": "./skills/",
  "hooks": "./hooks.json",
  "interface": {
    "displayName": "<Plugin Display Name>",
    "shortDescription": "Short package description.",
    "longDescription": "Longer package description.",
    "developerName": "<author-or-team>",
    "category": "Productivity"
  }
}
```

**Skills**: declare the skills directory in the plugin manifest above (`"skills": "./skills/"`) so Codex loads plugin skills from `plugins/<plugin-name>/skills/`.

**MCP Servers**: because `${PLUGIN_ROOT}` is not expanded in MCP server commands, the recommended workaround for Python MCP servers packaged with `uv` is to install the server as an editable `uv` tool during plugin installation. This links the server entry point into `uv`'s bin directory and makes it available as a plain command on `PATH`, while keeping the entry point's source location inside the plugin directory:

```toml
[mcp_servers.<server-name>]
command = "<server-name>"
env_vars = ["GITLAB_TOKEN"]
```

```sh
uv tool install --editable <plugin-root>
```

Use `--editable`, not a regular install: a regular install copies the package into an isolated tool environment, so code resolving its own location via `Path(__file__)` lands there instead of the plugin directory. An editable install keeps `__file__` pointing at the plugin's source tree, keeping bundled files reachable.

**Hooks**: store bundled implementations under `plugins/<plugin-name>/hooks/` and register them in the plugin's `hooks/hooks.json`, declared via the `hooks` field in the plugin manifest above (without it, Codex never loads the file), with commands prefixed by `${CLAUDE_PLUGIN_ROOT}`:

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

**Marketplace**: publish through a Codex marketplace at `.agents/plugins/marketplace.json`:

```json
{
  "name": "<marketplace-name>",
  "interface": {
    "displayName": "<Marketplace Display Name>"
  },
  "plugins": [
    {
      "name": "<plugin-name>",
      "source": {
        "source": "local",
        "path": "./plugins/<plugin-name>"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Productivity"
    }
  ]
}
```

**Activation**:

```sh
codex plugin marketplace add ./.agents/plugins
codex plugin add <plugin-name>@<marketplace-name>
```

If the plugin includes a Python MCP server installed as a `uv` tool, add the install step:

```sh
uv tool install --editable <path-to-mcp-package>
```
