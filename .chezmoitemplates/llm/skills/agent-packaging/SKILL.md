---
name: agent-packaging
description: Use when deciding how an agentic application, including skills, MCP servers, hooks, and plugins, should be discovered, installed, and activated by CLI agents such as Claude Code, Codex, and OpenCode.
---

# Agent Setup

Package agentic applications so their implementation remains agent-agnostic while discovery and launch registration remain explicit for each supported agent.

Store shared implementation in shared package locations. Use agent-specific files only to discover, expose, register, or launch that implementation.

Begin by helping the developer determine whether the application should be packaged as a workspace package or an installable package. Do not assume the developer already knows these packaging models. Explain the practical difference, ask how and where the application should be used, and make the decision together.

Only after the packaging model is clear should you add skills, MCP servers, hooks, project configuration, plugin manifests, marketplace metadata, or other agent-specific integration.

## Choosing a Packaging Model

### Workspace Packages

A workspace package is defined and activated by the current repository.

Its skills, configuration, and supporting files are discovered because the user starts the agent from that checkout. Its commands usually operate on files in the same checkout, and unrelated repositories should not discover or activate it automatically.

Use a workspace package when the agentic application belongs to a specific repository and should only be available while working from that repository.

Workspace packages are activated automatically when launching the agent from that repository.

### Installable Packages

An installable package is defined independently of the current repository.

It can be installed, enabled, and used while the user is working inside other repositories. Its implementation lives in an installed plugin, package cache, executable, MCP server, or another managed installation location.

The current repository may still be the package's primary working context or target. However, the package does not depend on that repository for its own discovery, implementation, or lifecycle.

Use an installable package when the agentic application must be available outside its source repository or composed into other workflows.

Installable packages are activated explicitly by the user and operate within the user's current working context.

## Agent Runtime Differences

Claude Code, Codex, and OpenCode package the same concepts differently because they discover and launch runtime components differently. Understanding these runtime differences explains why MCP server and hook registration differs between agents.

### Path Resolution

Workspace packages execute from the repository that contains the package. The current working directory is the repository root, so repository relative paths resolve naturally. MCP servers and hooks can therefore be registered using paths relative to the current checkout.

Installable packages execute from the user's current workspace, not from the plugin installation. The agent caches the installed plugin at an internal location that is not known at package authoring time, so repository relative paths no longer resolve to bundled files.

Claude Code exposes the plugin installation directory through `${CLAUDE_PLUGIN_ROOT}`. Use this variable whenever an MCP server or hook must reference files bundled inside the plugin.

Codex exposes `${PLUGIN_ROOT}` (and `${CLAUDE_PLUGIN_ROOT}` as a compatibility alias) for hook commands. Codex does not expand these variables for MCP server commands (a known bug). Bundled MCP server commands must therefore use either a command available on `PATH` or an absolute path.

OpenCode has no unified installable package format. Skills, MCP servers, and event hooks are three independent subsystems with separate discovery and registration mechanisms. There is no single install command that bundles them together into one installable unit the way Claude Code and Codex plugins do. Global availability requires separate activation steps for each component, documented under Activation.

### Environment Variables

Claude Code commonly launches MCP servers and hooks with the environment inherited from the Claude Code process. User defined environment variables are therefore available without additional registration.

Codex does not automatically expose every environment variable to launched MCP servers. Whenever an MCP server reads a user provided environment variable, declare it explicitly using `env_vars` in the Codex MCP registration.

For example:

```toml
env_vars = ["GITLAB_TOKEN"]
```

`env_vars` declares the variable names to pass through from the launching environment. It does not declare, store, or supply their values.

This applies to secrets, API keys, tokens, path overrides, and any other runtime environment variables that the MCP server expects to read.

OpenCode does not automatically expose environment variables to launched MCP servers either. Declare each variable explicitly using the `environment` key in the MCP registration. Unlike Codex's `env_vars` which declares names only, `environment` takes key-value pairs. Use the `{env:VAR}` substitution syntax to pull values from the launching environment at runtime:

```json
"environment": {
  "GITLAB_TOKEN": "{env:GITLAB_TOKEN}"
}
```

### OpenCode Plugins vs. Agent Plugins

The term "plugin" means different things across agents. In Claude Code and Codex, a plugin is an installable package that bundles agentic components such as skills, MCP servers, hooks, and other integrations with a manifest for discovery and installation.

In OpenCode, a plugin is a JavaScript or TypeScript module that subscribes to runtime events such as `tool.execute.before` and `session.idle`. It is not a container for skills or MCP server registrations. OpenCode plugins implement behavior that would be expressed as declarative shell command hooks in Claude Code and Codex.

This skill uses "plugin" to mean the Claude Code and Codex concept. Where OpenCode requires a plugin to implement equivalent hook behavior, that is noted explicitly.

## Package Layouts

For workspace packages, use shared locations for implementation and agent-specific locations only for discovery and registration:

```text
.agents/
  skills/
    <skill-name>/
      SKILL.md                    # canonical skill body
      hooks/
        <hook-name>               # skill-scoped hook
  hooks/
    <hook-name>                   # shared hook
.claude/
  skills/
    <skill-name> -> ../../.agents/skills/<skill-name>  # symlink to canonical skill
  settings.json                   # Claude hook registration
.codex/
  config.toml                     # Codex MCP servers and hook registration
.opencode/
  plugins/
    <hook-name>.ts                # OpenCode hook implementation
.mcp.json                         # Claude Code MCP servers, shared with Codex when possible
opencode.json                     # OpenCode project config
```

For installable packages, create one self-contained plugin root. OpenCode has no installable package model and is not part of this layout.

```text
plugins/
  <plugin-name>/                  # plugin package boundary
    .codex-plugin/
      plugin.json                 # Codex plugin manifest
    .codex/
      config.toml                 # Codex plugin MCP servers
    .claude-plugin/
      plugin.json                 # Claude Code plugin manifest
    .mcp.json                     # Claude Code MCP server registration
    skills/
      <skill-name>/
        SKILL.md                  # package-owned skill body
    hooks/
      hooks.json                  # Claude Code and Codex hook registration
      <hook-name>                 # hook implementation

.agents/
  plugins/
    marketplace.json              # Codex marketplace

.claude-plugin/
  marketplace.json                # Claude Code marketplace
```

The package boundary is:

```text
plugins/<plugin-name>/
```

Everything required at runtime must either be inside this boundary or be an explicitly declared external dependency. Use lowercase hyphen-case for plugin, skill, and MCP server identifiers. Keep the plugin directory name and the `name` in both plugin manifests identical.

`.claude/settings.local.json` holds user-local trust gates and permission overrides. It must always be git-ignored and never committed to the repository.

## Package Components

### Skills

Create skills according to the `skill-creator` skill. Maintain each skill once.

For workspace packages, store each canonical skill under:

```text
.agents/skills/<skill-name>/
```

Codex and OpenCode discover the canonical skill directly from this location. Expose it to Claude Code through a repository-contained relative symlink:

```text
.claude/skills/<skill-name> -> ../../.agents/skills/<skill-name>
```

The symlink is part of the repository and resolves only within the checkout. Users do not create global symlinks.

For installable packages, store package-owned skills under:

```text
plugins/<plugin-name>/skills/<skill-name>/
```

Claude Code discovers plugin skills from this canonical directory. Declare the same skills directory in `plugins/<plugin-name>/.codex-plugin/plugin.json` so Codex loads plugin skills from that path:

```json
{
  "skills": "./skills/"
}
```

OpenCode has no installable package model. Skills cannot be bundled and installed the way Claude Code and Codex plugins can. See Activation for how to make OpenCode skills globally available.

### MCP Servers

Store each MCP implementation once in an agent-agnostic location, and keep the server name consistent across registrations.

Each agent uses its own registration format and file. OpenCode always requires a separate `opencode.json` entry because its command format and environment variable declaration differ from Claude Code and Codex. Claude Code and Codex can share a `.mcp.json` when the server reads no environment variables; add a separate `.codex/config.toml` whenever `env_vars` is needed or the command path differs.

For workspace packages, place registration files at the repository root:

```text
.mcp.json          # Claude Code, or shared with Codex when no env vars are needed
.codex/config.toml # Codex, when splitting from .mcp.json
opencode.json      # OpenCode (mcp key alongside other project config)
```

For installable packages, Claude Code and Codex register at the plugin root. OpenCode has no installable package model; its global MCP registration is documented under Activation.

```text
plugins/<plugin-name>/
|-- .mcp.json
`-- .codex/
    `-- config.toml
```

All three agents support relative paths for workspace packages because commands execute from the repository checkout.

Claude Code registration (`.mcp.json`):

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

Codex registration (`.codex/config.toml`):

```toml
[mcp_servers.<server-name>]
command = "uv"
args = ["run", "--project", "<project-path>", "<server-entrypoint>"]
env_vars = ["GITLAB_TOKEN"]
```

Omit `env_vars` when the server does not read environment variables.

OpenCode registration (`opencode.json`):

```json
{
  "mcp": {
    "<server-name>": {
      "type": "local",
      "command": ["uv", "run", "--directory", "<project-path>", "<server-entrypoint>"],
      "environment": {
        "GITLAB_TOKEN": "{env:GITLAB_TOKEN}"
      }
    }
  }
}
```

Omit `environment` when the server does not read environment variables.

Claude Code registrations for installable packages may use `${CLAUDE_PLUGIN_ROOT}` to locate bundled files. Codex does not expand `${PLUGIN_ROOT}` or `${CLAUDE_PLUGIN_ROOT}` in MCP server commands (known bug). For Python MCP servers packaged with `uv`, the recommended workaround is to install the server as a `uv` tool during plugin installation. This links the server entry point into `uv`'s bin directory and makes it available as a plain command on `PATH`:

```toml
[mcp_servers.<server-name>]
command = "<server-name>"
env_vars = ["GITLAB_TOKEN"]
```

Document the `uv tool install` step in the plugin README alongside the other installation steps.

### Hooks

Claude Code and Codex share a declarative hook model: hooks are shell commands registered against agent events in configuration files, with implementations stored separately under `.agents/hooks/`. OpenCode has no equivalent declarative hook system. In OpenCode, hook-like behavior is expressed as a TypeScript module that subscribes to runtime events using OpenCode's plugin system.

Store shell hook implementations once, according to ownership:

```text
.agents/skills/<skill-name>/hooks/<hook-name>
.agents/hooks/<hook-name>
```

Hooks used by one skill belong to that skill. Hooks shared across skills, MCP workflows, or repository-wide policies belong under `.agents/hooks`.

#### Claude Code and Codex

For workspace packages, register hooks in the repository root configuration:

```text
.claude/settings.json
.codex/config.toml
```

For installable packages, store bundled implementations under `plugins/<plugin-name>/hooks/` and register them in the plugin's `hooks/hooks.json`. Workspace hook commands may use relative paths. Installable package hook commands must use `${CLAUDE_PLUGIN_ROOT}` because they execute from the user's active workspace, not the plugin installation directory. Both Claude Code and Codex resolve `${CLAUDE_PLUGIN_ROOT}` to the installed plugin root.

Workspace Codex registration (`.codex/config.toml`):

```toml
[[hooks.PreToolUse]]
matcher = "Bash"

[[hooks.PreToolUse.hooks]]
type = "command"
command = "<command>"
timeout = 30
statusMessage = "Running hook"
```

`.claude/settings.json` (workspace) and `hooks/hooks.json` (installable package) use the same JSON schema:

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

#### OpenCode

Store the implementation in `.opencode/plugins/`. OpenCode discovers and loads all TypeScript and JavaScript files in that directory automatically on startup for workspace use. For global use, register the same file with `opencode plugin <path> --global`.

A plugin subscribes to events by returning a hooks object from its exported function:

```typescript
import type { Plugin } from "@opencode-ai/plugin"

export const MyHook: Plugin = async ({ client }) => {
  return {
    "tool.execute.before": async () => {
      // hook logic here
    },
  }
}
```

Available events include `tool.execute.before`, `tool.execute.after`, `session.idle`, `file.edited`, and others. The plugin receives a context object with `project`, `client`, `$` (Bun shell), `directory`, and `worktree`.

Because the plugin is both the registration and the implementation, there is no separate shell script. If the hook logic is shared with Claude Code and Codex, store the shared implementation under `.agents/hooks/` as a shell script and invoke it from the OpenCode plugin using the Bun shell:

```typescript
export const MyHook: Plugin = async ({ $, directory }) => {
  return {
    "tool.execute.before": async () => {
      await $`${directory}/.agents/hooks/<hook-name>`
    },
  }
}
```

### Plugin Manifests

Create plugin manifests for installable packages. OpenCode has no plugin manifest format.

Create the Codex manifest at:

```text
plugins/<plugin-name>/.codex-plugin/plugin.json
```

For example:

```json
{
  "name": "<plugin-name>",
  "version": "0.1.0",
  "description": "Short package description.",
  "author": {
    "name": "<author-or-team>"
  },
  "skills": "./skills/",
  "interface": {
    "displayName": "<Plugin Display Name>",
    "shortDescription": "Short package description.",
    "longDescription": "Longer package description.",
    "developerName": "<author-or-team>",
    "category": "Productivity"
  }
}
```

Create the Claude Code manifest at:

```text
plugins/<plugin-name>/.claude-plugin/plugin.json
```

For example:

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

### Marketplaces

Publish installable packages through a Codex marketplace at:

```text
.agents/plugins/marketplace.json
```

For example:

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

Publish installable packages through a Claude Code marketplace at:

```text
.claude-plugin/marketplace.json
```

For example:

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

Do not use names reserved for, or likely to be confused with, an official marketplace.

## Activation

Document package activation in the package README.

For workspace packages, document that users start the agent from the repository checkout. All agents discover the package from the current checkout:

```sh
cd <repository>
claude   # or: codex, opencode
```

For Claude Code installable packages:

```sh
claude plugin marketplace add ./.claude-plugin/marketplace.json
claude plugin install <plugin-name>@<marketplace-name>
```

For Codex installable packages:

```sh
codex plugin marketplace add ./.agents/plugins
codex plugin add <plugin-name>@<marketplace-name>
```

If the plugin includes a Python MCP server installed as a `uv` tool, add the install step:

```sh
uv tool install <path-to-mcp-package>
```

OpenCode has no equivalent installable package format. Global activation requires separate steps for each component. Run these once from the cloned repository:

```sh
# skills
ln -sfn "$(pwd)/.agents/skills/<skill-name>" ~/.config/opencode/skills/<skill-name>

# MCP servers
opencode mcp add <server-name> -- uv run --directory "$(pwd)/<server-path>" <server-entrypoint>

# event hooks
opencode plugin "$(pwd)/.opencode/plugins/<hook-name>.ts" --global
```

Repeat the skill and MCP steps for each skill and server in the package. Multiple packages can be installed independently; each command adds to the global configuration without replacing entries from other packages.
