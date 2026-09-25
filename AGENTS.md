# Source and Target State

This repository manages a chezmoi-based dotfiles setup.

Chezmoi has two important locations:

* **Source state:** usually `~/.local/share/chezmoi`. If that path doesn't exist, confirm the actual location with `chezmoi source-path`.
* **Target state:** the files deployed into the user's home directory, for example `~/.config/...`, `~/.zshrc`, and similar paths.

The source state is authoritative. Make durable changes there.

The target state is generated output. Do not make durable changes directly in target files, because a later `chezmoi apply` can overwrite them and those edits are not part of the version-controlled setup.

Treat `chezmoi apply` as an explicit deployment step and never run it automatically.

This setup supports different machine types, including macOS systems, Linux desktops, Raspberry Pis, and restricted servers. Changes preserve that multi-machine model rather than only making the current machine work.

# Repository Structure

The chezmoi source state contains both ordinary configuration files and the logic used to bootstrap and configure a machine.

`.chezmoi.toml.tmpl` is the machine-initialization template, used the first time `chezmoi init` runs on a new machine. It defines machine-specific chezmoi data and asks about choices that differ between machines. Tools are controlled by `install.<tool>` flags. Wherever a tool has an installation path for a target, that path is gated by the corresponding flag.

Three separate files are involved in a flag's lifecycle, and none of them reference each other, so all three need to be kept in sync by hand:

* `.chezmoidata.toml` holds the repository-wide default value (normally `false`) for every `install.<tool>` flag, used by any machine that hasn't overridden it.
* `.chezmoi.toml.tmpl` holds the same flag, asked interactively during `chezmoi init` on a new machine, wrapped in a platform predicate so it's only asked where an install path actually exists for that platform.
* `~/.config/chezmoi/chezmoi.toml` stores each machine's answers from `chezmoi init`. It lives outside the source repository, is unversioned, and is not shared between machines. Users can adjust its install flags after initialization. `chezmoi apply` uses those flags to determine which managed resources to install.

Package installation is split by mechanism:

* `dot_config/private_homebrew/Brewfile.tmpl` contains Homebrew formulas and casks.
* `dot_config/aptitude/empty_Aptfile.tmpl` contains apt-managed packages.
* `dot_config/snap/empty_Snapfile.tmpl` contains snap-managed packages.
* `.chezmoiexternal.toml` contains external downloads: archives, git repositories, plugins, standalone assets, and upstream-release fallbacks for when Homebrew is unavailable.
* `dot_config/mise/config.toml.tmpl` contains mise-managed language runtimes and tools distributed only through a language package manager.
* `.chezmoiscripts/` contains bootstrap and setup scripts, especially work with ordering requirements or work that cannot be expressed as a static package declaration.

Application configuration lives in the corresponding chezmoi source path. For example, `dot_config/nvim/` produces configuration under `~/.config/nvim/`.

Shell initialization, aliases, environment setup, and completions live with the existing shell configuration in the source state (for example, autoloaded shell functions under `dot_config/shell/functions/`, and zsh completions under `dot_local/share/zsh/custom-completions/`). Installation and shell integration are separate concerns, so installing a CLI package does not by itself complete its integration.

When adding a capability that spans multiple integration points, use a similar existing capability as a guide and update the corresponding files.

# Bootstrap and Installation

Homebrew is the default package manager for user-space software in this setup, on both macOS and Linux. Prefer it whenever it's available. This keeps user-space package management consistent across systems, generally provides recent versions, and avoids maintaining unnecessary parallel installation paths.

Homebrew doesn't cover every case. Apt, snap, mise, and `.chezmoiexternal.toml` each step in for a different, specific reason:

**Apt** is worth choosing over Homebrew when there's a concrete reason: the tool is closer to core system plumbing than to a user-curated toolchain (`build-essential` and similar), or it's a package apt needs before Homebrew itself can even be installed. On a machine with no Homebrew at all, apt is also the first thing to check for a tool that still needs to exist there. Use it when the packaged version is recent enough for what this repo's configuration relies on. When it isn't, `.chezmoiexternal.toml` provides a direct upstream-release fallback instead, specifically to avoid settling for a stale apt package for tools whose configuration needs newer behavior.

**Snap** is used on Linux when Homebrew has no path to a tool, and the tool needs to be recent or needs proper desktop integration. Snap publishers push updates independent of the distro's packaging cycle, so a snap can stay current without waiting on apt, this applies to command-line tools as much as GUI ones. For GUI applications specifically, snap also creates proper application-menu entries, icons, and desktop-environment integration that neither apt nor a raw binary fetch provides on their own.

`.chezmoiexternal.toml` has two distinct responsibilities. One is the upstream-release fallback described above, for when Homebrew is unavailable and apt's version is too old or doesn't exist. The other is unrelated to Homebrew availability entirely: managing resources that are not package-manager software in the first place, git-based frameworks, shell plugins, and other externally fetched assets. For those, `.chezmoiexternal.toml` is the canonical mechanism regardless of whether Homebrew exists on the machine.

**Mise** manages two related things: the language runtime versions this setup uses (`ruby`, `rust`, `node`, `python`, `go`), and any CLI tool whose natural distribution is through one of those languages' own package managers (`cargo install`, `npm install -g`, `pip`/`pipx`, `gem install`, `go install`). Brew-first still applies here too, if Homebrew has a formula for the tool, use that. Mise becomes the right mechanism specifically when a tool is only distributable through a language package manager and Homebrew has no formula for it.

Do not create fallback machinery for every package. Supporting multiple installation paths adds maintenance cost, so a non-Homebrew path exists only when the environment genuinely needs that software on machines without Homebrew. Never install the same software through multiple mechanisms on the same machine. Ask the user when it's genuinely unclear which mechanism fits.

# Shared, Platform, and Machine-Specific State

`.chezmoi.toml.tmpl` and the other templates in the source state allow one repository to produce different target states on different machines.

Use existing template data and capability checks to express real differences between environments. Prefer conditions based on meaningful properties such as operating system, GUI availability, Homebrew availability, apt availability, or another actual capability, over host-specific conditions when the distinction can be expressed as a reusable property of the machine.

Install flags allow a tool or application to exist in shared source state while being enabled only on machines where it belongs. The shared source state (`.chezmoidata.toml`, `.chezmoi.toml.tmpl`) defines available behavior and defaults; each machine's own `~/.config/chezmoi/chezmoi.toml` keeps the choices that are intentionally machine-specific, and only that file affects what an actual `chezmoi apply` does on that machine.

When adding an install flag, set its default to `false` in `.chezmoidata.toml`, derive it from applicable machine capabilities in `.chezmoi.toml.tmpl`, and gate the consuming package or external declaration with the flag. Update `~/.config/chezmoi/chezmoi.toml` only when the current machine should enable it.

# Adding New Capabilities

When package availability or installation details are unknown, research the supported platforms and architectures. For Homebrew candidates, `brew info --json=v2 <formula>` shows supported combinations. Consult upstream release sources when another mechanism may be appropriate. Use **Bootstrap and Installation** to select the mechanism, and refer to an analogous existing capability when implementation details are unclear.

# Safe Change Workflow

After changing templates, install declarations, external resources, scripts, platform conditions, or source-to-target mappings, inspect what chezmoi renders:

```text
chezmoi diff
```

Check that:

* templates render successfully
* conditions select the intended platform or machine
* package and external entries use the correct install flags
* referenced files and resources exist
* a change intended for one platform does not unexpectedly affect another
* the rendered diff contains only the intended changes

Treat requests to modify, fix, or debug managed configuration as changes to source state. Use target state only to inspect deployed output or diagnose rendering, and make durable changes in source state.
