# ⊙ dotfiles

### Prerequisites
- macOS: Get the latest system updates
- macOS: Run `xcode-select --install` or install Xcode via AppStore
- Ubuntu: Run `ibus-setup`. Go to Emoji tab and remove the `C-;` and `C-.` keymaps
- Linux in VM on macOS: Go to `Settings` -> `Keyboard` and change the input source to `English (UK, Macintosh)`

### Install

Clone dotfiles and init chezmoi
```sh
sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init tummetott
```

Define what applications to install by editing the `chezmoi.toml` file
```sh
vim ~/.config/chezmoi/chezmoi.toml
```

Install dotfiles and applications
```sh
~/.local/bin/chezmoi apply

```

### Post-Installation

- macOS: Open `Karabiner-Elements` manually and grant all required permissions in System Settings. This enables correct CAPSLOCK behaviour
- macOS: Disable the *Ctrl* + *Space* shortcut under `System Settings` -> `Keyboard` -> `Keyboard Shortcuts` -> `Input Sources` -> `Select the previous input source`. Otherwise, macOS intercepts my `tmux` prefix mapping
- Install language-servers with `Mason` from within Neovim

### Usage

Pull updates from the repository
```sh
chezmoi update
```

Configure `~/.config/chezmoi/chezmoi.toml` to your needs, then apply the changes
with
```sh
chezmoi apply
```

### Notes

- `WezTerm` and `Kitty` do not run inside VMs because they require OpenGL. Use `Alacritty` instead.
