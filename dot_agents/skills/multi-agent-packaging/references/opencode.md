# OpenCode

A plugin in OpenCode is a JavaScript or TypeScript module that subscribes to runtime events such as `tool.execute.before` and `session.idle`. It is not a container for skills or MCP server registrations, it implements hook-like behavior directly.

OpenCode does not automatically expose environment variables to launched MCP servers. Declare each variable explicitly using the `environment` key in the MCP registration, using the `{env:VAR}` substitution syntax to pull values from the launching environment at runtime.

## Unpackaged Global Setup

**Skills**: place the canonical skill under `~/.agents/skills/<skill-name>/SKILL.md`.

**MCP Servers**: `opencode mcp add` is interactive only, so edit the global config directly instead, `~/.config/opencode/opencode.json`:

```json
{
  "mcp": {
    "<server-name>": {
      "type": "local",
      "command": ["uv", "run", "--directory", "<project-path>", "<server-entrypoint>"]
    }
  }
}
```

**Hooks**: OpenCode has no declarative hook system, hooks are implemented as TypeScript or JavaScript plugin modules that subscribe to runtime events. Place the plugin under `~/.config/opencode/plugins/<plugin-name>.ts`; OpenCode discovers and loads it automatically at startup, no explicit registration needed. A module exports a function that returns a hooks object:

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

Because the plugin is both the registration and the implementation, there is no separate shell script by default. The `.ts` file itself is OpenCode-specific and only ever read from this directory, but if the hook logic needs to be reused outside OpenCode, store the shared implementation as a plain shell script under `~/.agents/hooks/<hook-name>` instead, and invoke it from the OpenCode plugin using the Bun shell:

```typescript
export const MyHook: Plugin = async ({ $ }) => {
  return {
    "tool.execute.before": async () => {
      await $`~/.agents/hooks/<hook-name>`
    },
  }
}
```

## Workspace Package

**Activation**: `cd <repository> && opencode` discovers and activates the package automatically from the checkout.

**Skills**: OpenCode discovers the canonical skill directly from `.agents/skills/<skill-name>/`.

**MCP Servers**: register in `opencode.json`:

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

**Hooks**: same TypeScript or JavaScript plugin model, and the same shared-shell-script pattern, as Unpackaged Global Setup above, but store the file under `.opencode/plugins/` in the repository instead; OpenCode discovers and loads all TypeScript and JavaScript files there automatically on startup, the same way.

## Installable Package

OpenCode has no single manifest that bundles skills, MCP servers, and hooks together as one distributable unit the way Claude Code and Codex plugins do. It does support installable plugins for hook-like behavior specifically, published as npm packages and declared by name:

```json
{
  "plugin": ["<npm-package-name>"]
}
```

OpenCode installs the package automatically via Bun at startup, caching it under `~/.cache/opencode/node_modules/`. There is no separate install/uninstall command, adding or removing the package name from this list is the whole lifecycle, and no version-pinning syntax is documented beyond whatever the npm package name itself specifies.

Skills and MCP servers have no equivalent installable-package path in OpenCode; use Unpackaged Global Setup above for those.
