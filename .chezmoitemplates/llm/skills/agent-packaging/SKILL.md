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

Claude Code and Codex package the same concepts differently because they discover and launch runtime components differently. Understanding these runtime differences explains why MCP server and hook registration differs between the two agents.

### Path Resolution

Workspace packages execute from the repository that contains the package. The current working directory is the repository root, so repository relative paths resolve naturally. MCP servers and hooks can therefore be registered using paths relative to the current checkout.

Installable packages execute from the user's current workspace, not from the plugin installation. The agent caches the installed plugin at an internal location that is not known at package authoring time, so repository relative paths no longer resolve to bundled files.

Claude Code exposes the plugin installation directory through `${CLAUDE_PLUGIN_ROOT}`. Use this variable whenever an MCP server or hook must reference files bundled inside the plugin.

Codex does not expose an equivalent plugin root variable. Bundled MCP servers and hooks must therefore be launched using either absolute paths resolved at installation time or executables that are available on the user's PATH.

### Environment Variables

Claude Code commonly launches MCP servers and hooks with the environment inherited from the Claude Code process. User defined environment variables are therefore available without additional registration.

Codex does not automatically expose every environment variable to launched MCP servers. Whenever an MCP server reads a user provided environment variable, declare it explicitly using `env_vars` in the Codex MCP registration.

For example:

```json
{
  "env_vars": ["GITLAB_TOKEN"]
}
```

`env_vars` declares the variable names to pass through from the launching environment. It does not declare, store, or supply their values.

This applies to secrets, API keys, tokens, path overrides, and any other runtime environment variables that the MCP server expects to read.

## Package Layouts

For workspace packages, use shared locations for implementation and agent-specific locations only for discovery and registration:

```text
.agents/
  skills/
    <skill-name>/
      SKILL.md                    # canonical skill body
      hooks/
        <hook-name>               # hook implementation used only by this skill
  hooks/
    <hook-name>                   # workspace-level hook implementation
.claude/
  skills/
    <skill-name> -> ../../.agents/skills/<skill-name>  # Claude skill adapter
  settings.json                   # Claude project hooks and settings
.codex/
  config.toml                     # Codex project MCP servers, hooks, and settings
.mcp.json                         # shared project MCP servers, or Claude project MCP servers when Codex registration splits
mcp/
  <server-name>/
    <server-files>                # workspace MCP implementation
```

For installable packages, create one self-contained plugin root:

```text
plugins/
  <plugin-name>/                  # plugin package boundary
    .codex-plugin/
      plugin.json                 # Codex plugin manifest
    .codex/
      config.toml                 # Codex plugin MCP servers, hooks, and settings
    .claude/
      settings.json               # Claude Code plugin hooks and settings
    .claude-plugin/
      plugin.json                 # Claude Code plugin manifest
    .mcp.json                     # shared plugin MCP servers, or Claude Code MCP servers when Codex registration splits
    skills/
      <skill-name>/
        SKILL.md                  # package-owned skill body
    mcp/
      <server-name>/
        <server-files>            # shared MCP implementation
    hooks/
      <hook-name>                 # shared hook implementation

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

## Package Components

### Skills

Create skills according to the `skill-creator` skill. Maintain each skill once.

For workspace packages, store each canonical skill under:

```text
.agents/skills/<skill-name>/
```

Codex discovers the canonical skill directly. Expose it to Claude Code through a repository-contained relative symlink:

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

### MCP Servers

Store each MCP implementation once in an agent-agnostic location, and keep the server name consistent across registrations.

Claude Code and Codex both support the `.mcp.json` registration format. A shared registration is practical only when both agents can execute the same command unchanged. Packaged MCPs often do not meet this requirement because Claude Code supports `${CLAUDE_PLUGIN_ROOT}`, while Codex may require different command paths or explicit `env_vars`. Therefore, use `.mcp.json` for Claude Code and `.codex/config.toml` for Codex.

For workspace packages, place the registration files and MCP implementation in the repository root:

```text
.mcp.json
.codex/config.toml
mcp/<server-name>/
```

For installable packages, place the registration files under the plugin root and bundle the MCP implementation under `mcp/<server-name>/`:

```text
plugins/<plugin-name>/
|-- .mcp.json
|-- .codex/
|   `-- config.toml
`-- mcp/
    `-- <server-name>/
```

Claude Code registration:

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

Codex registration:

```toml
[mcp_servers.<server-name>]
command = "uv"
args = ["run", "--project", "<project-path>", "<server-entrypoint>"]
env_vars = ["GITLAB_TOKEN"]
```

Omit `env_vars` when the server does not read local environment variables.

Workspace packages may use relative paths because commands execute from the repository checkout. Installable Codex registrations cannot rely on relative paths because commands execute from the user's active workspace. Use either a command available on `PATH` or an installation-generated absolute command path. Claude Code registrations may instead use `${CLAUDE_PLUGIN_ROOT}` to locate bundled files.

### Hooks

Store each hook implementation once. Keep registration separate from implementation. Use the same command in both agent registrations only when both Claude Code and Codex can execute it unchanged.

For workspace packages, store hooks according to ownership:

```text
.agents/skills/<skill-name>/hooks/<hook-name>
.agents/hooks/<hook-name>
```

Hooks used by one skill belong to that skill. Hooks shared across skills, MCP workflows, or repository-wide policies belong under `.agents/hooks`.

For installable packages, store bundled hook implementations under:

```text
plugins/<plugin-name>/hooks/<hook-name>
```

Register hooks in each agent's configuration. For workspace packages, use the repository root configuration:

```text
.claude/settings.json
.codex/config.toml
```

For installable packages, use the plugin's configuration:

```text
plugins/<plugin-name>/.claude/settings.json
plugins/<plugin-name>/.codex/config.toml
```

Workspace registrations may use relative paths because commands execute from the repository checkout. Installable Codex registrations cannot use relative paths to address bundled plugin files because commands execute from the user's active workspace. Use either a command available on `PATH` or an installation-generated absolute command path. Claude Code may instead use `${CLAUDE_PLUGIN_ROOT}` to locate bundled hook implementations.

Codex registration:

```toml
[[hooks.PreToolUse]]
matcher = "Bash"

[[hooks.PreToolUse.hooks]]
type = "command"
command = "<command>"
timeout = 30
statusMessage = "Running hook"
```

Claude Code registration:

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

### Plugin Manifests

Create plugin manifests for installable packages.

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

For workspace packages, document that users start the agent from the repository checkout. The package is discovered from the current checkout:

```sh
cd <repository>
claude
```

```sh
cd <repository>
codex
```

For Claude Code installable packages:

```sh
claude plugin marketplace add ./.claude-plugin/marketplace.json
claude plugin install <plugin-name>@<marketplace-name>
```

For Codex installable packages:

```sh
codex plugin marketplace add ./
codex plugin add <plugin-name>@<marketplace-name>
```
