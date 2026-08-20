# ⊙ dotfiles

### Prerequisites
- macOS: Get the latest system updates
- macOS: Run `xcode-select --install` or install Xcode via AppStore
- Ubuntu: Run `ibus-setup`. Go to Emoji tab and remove the `C-;` and `C-.` keymaps
- Linux VM on macOS: Go to `Settings` -> `Keyboard` and change the input source to `English (UK, Macintosh)`
- Linux without `snapd` preinstalled: If you want snap-packaged apps (e.g. `ghostty`), install and enable it manually first, since not every distro's `snapd` package auto-enables its systemd units the way Ubuntu's does:
  ```sh
  sudo apt install snapd
  sudo systemctl enable --now snapd.apparmor
  sudo systemctl enable --now snapd
  ```

### Install

Clone dotfiles and init chezmoi
```sh
sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init tummetott
```

Define what applications to install by editing the `chezmoi.toml` file
```sh
vi ~/.config/chezmoi/chezmoi.toml
```

Install dotfiles and applications (chezmoi not in PATH yet)
```sh
~/.local/bin/chezmoi apply

```

**Note**: If GitHub rate-limits your API requests, create a [personal access token](https://github.com/settings/tokens) and make it available to chezmoi by exporting it as an environment variable: `export GITHUB_TOKEN="<token>"`

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

#### Terminal emulator compatibility

| Terminal   | macOS (bare metal) | macOS (VM)          | Linux (bare metal) | Linux (VM)                  |
| ---------- | ------------------- | -------------------- | ------------------- | ----------------------------- |
| Alacritty  | Yes                 | No (OpenGL error)      | Yes      | Yes         |
| Ghostty    | Yes                 | Yes                   | Yes      | Yes |
| WezTerm    | Yes                 | No (OpenGL error) | Yes [^1] | Yes [^1] |
| Kitty      | Yes                 | No (OpenGL error)     | Not Tested | Not Tested |
| iTerm2     | Yes                 | Yes        | N/A                  | N/A                            |

[^1]: Only on amd64. The `wezterm/wezterm-linuxbrew` tap only packages an x86_64 bottle; expected to support arm64 eventually.

