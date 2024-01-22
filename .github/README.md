# ⊙ dotfiles

### Prerequisites
- Remap `CAPSLOCK` to `CTRL`
- macOS: Get the latest system updates
- macOS: Run `xcode-select --install` or install Xcode via AppStore
- Ubuntu: Run `ibus-setup`. Go to Emoji tab and remove the `C-;` and `C-.` keymaps
- Linux in VM on macOS: Go to `Settings` -> `Keyboard` and change the input source to `English (UK, Macintosh)`

### Install

```sh
sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply tummetott
```

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
