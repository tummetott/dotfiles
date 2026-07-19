---
name: agent-packaging
description: Use when deciding how an agentic application, including skills, MCP servers, hooks, and plugins, should be discovered, installed, and activated by CLI agents such as Claude Code, Codex, and OpenCode.
---

# Agent Setup

Package agentic applications so their implementation remains agent-agnostic while discovery and launch registration remain explicit for each supported agent.

Store shared implementation in shared package locations. Use agent-specific files only to discover, expose, register, or launch that implementation.

Begin by helping the developer determine whether the application should be packaged as a workspace package or an installable package. Do not assume the developer already knows these packaging models. Explain the practical difference, ask how and where the application should be used, and make the decision together.

Only after the packaging model is clear should you add skills, MCP servers, hooks, project configuration, plugin manifests, marketplace metadata, or other agent-specific integration.

## Workspace Packages

A workspace package is defined and activated by the current repository.

Its skills, configuration, and supporting files are discovered because the user starts the agent from that checkout. Its commands usually operate on files in the same checkout, and unrelated repositories should not discover or activate it automatically.

Use a workspace package when the agentic application belongs to a specific repository and should only be available while working from that repository.

Workspace packages are activated automatically when launching the agent from that repository.

## Installable Packages

An installable package is defined independently of the current repository.

It can be installed, enabled, and used while the user is working inside other repositories. Its implementation lives in an installed plugin, package cache, executable, MCP server, or another managed installation location.

The current repository may still be the package's primary working context or target. However, the package does not depend on that repository for its own discovery, implementation, or lifecycle.

Use an installable package when the agentic application must be available outside its source repository or composed into other workflows.

Installable packages are activated explicitly by the user and operate within the user's current working context.

## Workspace Package Implementation

Use a workspace package when the agentic application belongs to a repository and should become available when a user starts an agent from that checkout.

### Package Layout

Use shared locations for implementation and agent-specific locations only for discovery and registration:

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
.mcp.json                         # Claude project MCP servers
```

### Skills

Create skills according to the `skill-creator` skill.

Store each canonical skill under:

```text
.agents/skills/<skill-name>/
```

Codex discovers the canonical skill directly. Expose it to Claude Code through a repository-contained relative symlink:

```text
.claude/skills/<skill-name> -> ../../.agents/skills/<skill-name>
```

The symlink is part of the repository and resolves only within the checkout. Users do not create global symlinks.

### MCP Servers

Store each MCP implementation once in an agent-agnostic project location. Register it separately for each agent, using the same server name and repository-relative execution command.

For Codex, define project MCP servers in `.codex/config.toml`:

```toml
[mcp_servers.<server-name>]
command = "uv"
args = ["run", "--project", ".", "<server-entrypoint>"]
```

For Claude Code, define the same server in `.mcp.json`:

```json
{
  "mcpServers": {
    "<server-name>": {
      "command": "uv",
      "args": ["run", "--project", ".", "<server-entrypoint>"]
    }
  }
}
```

Commands must run the implementation from the current checkout and must not depend on globally installed copies of repository-owned code.

### Hooks

Store a hook inside a skill when the hook exists only for that skill:

```text
.agents/skills/<skill-name>/hooks/<hook-name>
```

Store a hook at the package level when the hook supports multiple skills, an MCP workflow, or a repository-wide policy:

```text
.agents/hooks/<hook-name>
```

These locations express implementation ownership. They do not activate the hook automatically. Activate hooks by registering the canonical hook path in each agent's project configuration. Use `.agents/hooks/<hook-name>` or `.agents/skills/<skill-name>/hooks/<hook-name>` as `<canonical-hook-path>` in the examples below.

For Codex, register project hooks in `.codex/config.toml`:

```toml
[[hooks.PreToolUse]]
matcher = "Bash"

[[hooks.PreToolUse.hooks]]
type = "command"
command = './<canonical-hook-path>'
timeout = 30
statusMessage = "Running workspace hook"
```

For Claude Code, register project hooks in `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "./<canonical-hook-path>"
          }
        ]
      }
    ]
  }
}
```

## Installable Package Implementation

Use an installable package when the agentic application must be available independently of its source checkout, including when it is used from other repositories or composed into larger workflows. Installable packages are implemented through the plugin systems of Claude Code and Codex.

### Package Layout

Create one self-contained plugin root for each installable package:

```text
plugins/
  <plugin-name>/                  # plugin package boundary
    .codex-plugin/
      plugin.json                 # Codex plugin manifest
      mcp.json                    # Codex MCP registration
      hooks.json                  # Codex hook registration
    .claude-plugin/
      plugin.json                 # Claude Code plugin manifest
    .mcp.json                     # Claude Code MCP registration
    skills/
      <skill-name>/
        SKILL.md                  # package-owned skill body
    mcp/
      <server-name>/
        ...                       # shared MCP implementation
    hooks/
      hooks.json                  # Claude Code hook registration
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

### Skills

Store package-owned skills under:

```text
plugins/<plugin-name>/skills/<skill-name>/
```

Create skills according to the `skill-creator` skill. Maintain each skill once.

Codex loads plugin skills from the path declared in `plugins/<plugin-name>/.codex-plugin/plugin.json`:

```json
{
  "skills": "./skills/"
}
```

Claude Code loads plugin skills from:

```text
plugins/<plugin-name>/skills/
```

### MCP Servers

Store a bundled MCP implementation under:

```text
plugins/<plugin-name>/mcp/<server-name>/
```

Maintain the MCP implementation once, and register it separately for each agent. MCP launch registration is agent-specific because each agent resolves bundled plugin resources differently.

Create the Claude Code MCP registration at:

```text
plugins/<plugin-name>/.mcp.json
```

Use `${CLAUDE_PLUGIN_ROOT}` when a Claude Code MCP command needs to address files bundled inside the plugin package:

```json
{
  "<server-name>": {
    "command": "uv",
    "args": ["run", "--project", "${CLAUDE_PLUGIN_ROOT}/mcp/<server-name>", "<server-entrypoint>"]
  }
}
```

Create the Codex MCP registration at:

```text
plugins/<plugin-name>/.codex-plugin/mcp.json
```

Codex MCP commands must be executable from the user's active workspace environment. Use a command available on `PATH`, or use an installation-generated absolute command path when the server is bundled inside the plugin package:

```json
{
  "<server-name>": {
    "command": "<server-executable-on-path>",
    "args": ["<server-arg>"]
  }
}
```

Declare the Codex MCP registration file in `plugins/<plugin-name>/.codex-plugin/plugin.json`:

```json
{
  "mcpServers": "./.codex-plugin/mcp.json"
}
```

### Hooks

Store bundled hook implementations under:

```text
plugins/<plugin-name>/hooks/<hook-name>
```

Maintain the hook implementation once, and register it separately for each agent. Hook launch registration is agent-specific because each agent resolves bundled plugin resources differently.

Create the Claude Code hook registration at:

```text
plugins/<plugin-name>/hooks/hooks.json
```

Use `${CLAUDE_PLUGIN_ROOT}` when a Claude Code hook command needs to address files bundled inside the plugin package:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/<hook-name>",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

Create the Codex hook registration at:

```text
plugins/<plugin-name>/.codex-plugin/hooks.json
```

Codex hook commands must be executable from the user's active workspace environment. Use a command available on `PATH`, or use an installation-generated absolute command path when the hook is bundled inside the plugin package:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "<hook-executable-on-path>",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

Declare the Codex hook registration file in `plugins/<plugin-name>/.codex-plugin/plugin.json`:

```json
{
  "hooks": "./.codex-plugin/hooks.json"
}
```

### Plugin Manifests

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
  "mcpServers": "./.codex-plugin/mcp.json",
  "hooks": "./.codex-plugin/hooks.json",
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

### Marketplace

Publish the package through a Codex marketplace at:

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

Publish the package through a Claude Code marketplace at:

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

## User Installation Instructions

Every package should document how users activate it in the package README.

For workspace packages, tell users to start the agent from the repository checkout. The package is discovered from the current checkout:

```sh
cd <repository>
claude
```

```sh
cd <repository>
codex
```

For Claude Code installable packages, tell users to add the Claude Code marketplace manifest and install the plugin:

```sh
claude plugin marketplace add ./.claude-plugin/marketplace.json
claude plugin install <plugin-name>@<marketplace-name>
```

For Codex installable packages, tell users to add the repository or marketplace root that contains `.agents/plugins/marketplace.json`, then install the plugin:

```sh
codex plugin marketplace add ./
codex plugin add <plugin-name>@<marketplace-name>
```
