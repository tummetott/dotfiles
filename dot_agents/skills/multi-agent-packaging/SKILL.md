---
name: multi-agent-packaging
description: Use when helping developers package agentic applications for CLI coding agents such as Claude Code, Codex, and OpenCode. Guide decisions between user-level global setups, repository-scoped workspace setups, and installable packages, then provide agent-specific guidance for configuring and distributing skills, MCP servers, hooks, plugins, manifests, and marketplaces. Use when a developer asks how to structure, install, migrate, or package an agent integration across one or more supported CLI agents.
---

# Agent Setup

This is a reference for packaging agentic applications, including skills, MCP servers, hooks, and plugins, for CLI agents such as Claude Code, Codex, and OpenCode. Ask the developer which agent or agents they actually want to target, if not already clear from the request, then read the matching reference file below for each.

For each targeted agent, help the developer determine whether the application should be set up as an unpackaged global setup, a workspace package, or an installable package. Do not assume the developer already knows these setups; explain the practical difference, ask how and where the application should be used, and decide together.

Create skills according to the `skill-creator` skill, and document activation in the package README, regardless of which agent or setup they end up packaged for.

## Choosing a Setup

These three categories are this guide's own cross-agent vocabulary, not official terminology from any one agent's own documentation.

### Unpackaged Global Setup

An unpackaged global setup has no package boundary at all: no manifest, no plugin, no repository that owns it. Skills, MCP servers, and hooks are placed or symlinked directly into each agent's global configuration location, so they are available regardless of which directory the agent is launched from.

Its source of truth may still live in a personal repository, such as a dotfiles setup, but that repository is not a package: it is not installed, versioned, or distributed as a unit, and nothing about it assumes anyone else will ever pull it in.

Use an unpackaged global setup when the application is for the developer's own machine only, with no need for a shareable install step, a version, or a marketplace listing.

Unpackaged global setups are activated once, manually, by placing or symlinking the implementation into each targeted agent's global configuration location. There is no install/uninstall lifecycle beyond that.

### Workspace Packages

A workspace package is defined and activated by the current repository.

Its skills, configuration, and supporting files are discovered because the user starts the agent from that checkout. Its commands usually operate on files in the same checkout, and unrelated repositories should not discover or activate it automatically.

Use a workspace package when the agentic application belongs to a specific repository and should only be available while working from that repository.

Workspace packages are activated automatically when launching the agent from that repository. All agents support relative paths for workspace packages because commands execute from the repository checkout, so repository-relative paths always resolve correctly.

### Installable Packages

An installable package is defined independently of the current repository, with a manifest that gives it its own name, version, and author.

It is installed once through the agent's own plugin mechanism, which then tracks its state: the package can be enabled, disabled, or removed without touching the source repository, and it stays available across every repository the user works in afterward. The current repository may still be its primary working context, but the package does not depend on that repository for its own discovery, implementation, or lifecycle.

Use an installable package when the application needs to be distributed to other users, versioned, isolated from other packages, or cleanly enabled and disabled without manual edits.

Because its runtime location is chosen by the agent at install time rather than by the author at authoring time, an installable package should still run from its canonical location, the authored source tree, whenever possible: that copy is complete and current by construction, while any other runtime location is a derived copy that can silently drift out of date or go incomplete. Each agent reference below documents how, or whether, it can reach canonical location directly, and what to do when it can't.

## Agent References

Once the target agent(s) and setup are decided, read the matching reference file for exact mechanics, file locations, and commands. Each file is self-contained and covers all three setups for that agent.

- `references/claude-code.md`
- `references/codex.md`
- `references/opencode.md`
