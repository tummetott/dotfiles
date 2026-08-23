---
name: neovim-config
description: Guidance for working with the user's chezmoi-managed Neovim configuration. Use when the user asks to modify, debug, inspect, or reason about their Neovim config, plugins, lazy.nvim setup, or plugin behavior in the context of their dotfiles repository. Do not use for general Neovim questions unless the request is specifically about this managed configuration.
---

# Neovim Config

The Neovim configuration is chezmoi-managed. Source lives at `dot_config/nvim/` in the chezmoi source repository, deployed to `~/.config/nvim/`. Edit the source, not the deployed copy.

The plugin manager is `lazy.nvim`. Installed plugins are cloned to `~/.local/share/nvim/lazy/<plugin-name>`, lazy.nvim's default location. Check that path directly when debugging a plugin, rather than searching the home directory for it.
