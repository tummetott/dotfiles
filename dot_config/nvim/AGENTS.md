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

# Lua Style

`snacks.nvim` (`~/.local/share/nvim/lazy/snacks.nvim/lua/snacks/`)
is the reference for well-designed Neovim Lua.
Consult it when unsure how to structure a module.

Keep behaviour that varies by case in data tables,
so the logic reads straight through without `if/elseif` chains per case.
Funnel public functions through one general function,
and keep the public entry points thin wrappers around it.
Return early on cases a function does not handle,
keeping the main path flat.
Name constants instead of leaving magic numbers inline.

Annotate only what lua_ls cannot infer,
typically parameters of public functions.
Drop `---@return` and `---@type` annotations that the code already makes obvious.
Type names carry no namespace prefix (`Axis`, not `tummetott.winsize.Axis`).
Prefer `---` doc comments on functions,
since lua_ls shows them on hover.
