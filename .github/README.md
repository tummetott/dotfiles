# Dots ☕️

### Prerequisites
- Remap CAPSLOCK to CTRL
- macOS: Get the latest system updates
- macOS: Run `xcode-select --install` or install Xcode via AppStore

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
