# Neovim Config

The Neovim configuration is chezmoi-managed.
Source lives at `~/.local/share/chezmoi/dot_config/nvim/`,
deployed to `~/.config/nvim/`.
Edit the source, not the deployed copy.

The plugin manager is `lazy.nvim`.
Installed plugins are cloned to `~/.local/share/nvim/lazy/<plugin-name>`.
Check that path directly when debugging a plugin,
rather than searching for it.

Every terminal this configuration runs in supports the kitty keyboard protocol.
Keymaps rely on that, and legacy terminal keycode limitations are out of scope.

Never use Ctrl+Shift keymaps in Neovim,
because they are reserved for the terminal multiplexer (Zellij or tmux).
The user dislikes Alt-prefixed keymaps; avoid them when choosing key bindings.
