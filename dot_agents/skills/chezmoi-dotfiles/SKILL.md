---
name: chezmoi-dotfiles
description: Guidance for working with the user's chezmoi-managed dotfiles repository. Use when the user explicitly mentions chezmoi, their dotfiles repository, or asks to add, modify, debug, or integrate configuration as part of their reproducible multi-machine dotfiles setup. Also use when a task inside that repository involves package installation, install flags, machine-specific settings, platform conditions, external resources, bootstrap scripts, shell integration, or application configuration. Do not use for general questions about configuring applications, shells, package managers, or operating systems unless the request is specifically connected to the chezmoi-managed environment.
---

# Source and Target State

This skill is for working with a chezmoi-managed dotfiles setup.

Chezmoi has two important locations:

* **Source state:** usually `~/.local/share/chezmoi`. If that path doesn't exist, confirm the actual location with `chezmoi source-path`.
* **Target state:** the files deployed into the user's home directory, for example `~/.config/...`, `~/.zshrc`, and similar paths.

The source state is authoritative. Make durable changes there.

The target state is generated output. Do not make durable changes directly in target files, because a later `chezmoi apply` can overwrite them and those edits are not part of the version-controlled setup.

Use `chezmoi diff` to inspect what the current source state would change in the target state. Treat `chezmoi apply` as an explicit deployment step and never run it automatically, even when the diff looks clean.

This setup supports different machine types, including macOS systems, Linux desktops, Raspberry Pis, and restricted servers. Changes preserve that multi-machine model rather than only making the current machine work.

# Repository Structure

The chezmoi source state contains both ordinary configuration files and the logic used to bootstrap and configure a machine.

`.chezmoi.toml.tmpl` is the machine-initialization template, used the first time `chezmoi init` runs on a new machine. It defines machine-specific chezmoi data and asks about choices that differ between machines. Tools are controlled by `install.<tool>` flags. Wherever a tool has an installation path for a target, that path is gated by the corresponding flag.

Three separate files are involved in a flag's lifecycle, and none of them reference each other, so all three need to be kept in sync by hand:

* `.chezmoidata.toml` holds the repository-wide default value (normally `false`) for every `install.<tool>` flag, used by any machine that hasn't overridden it.
* `.chezmoi.toml.tmpl` holds the same flag, asked interactively during `chezmoi init` on a new machine, wrapped in a platform predicate so it's only asked where an install path actually exists for that platform.
* `~/.config/chezmoi/chezmoi.toml` holds each individual machine's actual answer. This file lives outside the source repository entirely, it is not version-controlled and not shared between machines. It is what `chezmoi apply` actually reads to decide what to install on the machine it runs on. Changing the flag in the two files above does not change what's installed on any already-initialized machine; that requires editing this file too.

Package installation is split by mechanism:

* `dot_config/private_homebrew/Brewfile.tmpl` contains Homebrew formulas and casks.
* `dot_config/aptitude/empty_Aptfile.tmpl` contains apt-managed packages.
* `dot_config/snap/empty_Snapfile.tmpl` contains snap-managed packages.
* `.chezmoiexternal.toml` contains external downloads: archives, git repositories, plugins, standalone assets, and upstream-release fallbacks for when Homebrew is unavailable.
* `dot_config/mise/config.toml.tmpl` contains mise-managed language runtimes and tools distributed only through a language package manager.
* `.chezmoiscripts/` contains bootstrap and setup scripts, especially work with ordering requirements or work that cannot be expressed as a static package declaration.

Application configuration lives in the corresponding chezmoi source path. For example, `dot_config/nvim/` produces configuration under `~/.config/nvim/`.

Shell initialization, aliases, environment setup, and completions live with the existing shell configuration in the source state (for example, autoloaded shell functions under `dot_config/shell/functions/`, and zsh completions under `dot_local/share/zsh/custom-completions/`). Installation and shell integration are separate concerns, so installing a CLI package does not by itself complete its integration.

Before changing something, inspect an existing feature that solves a similar problem and identify all files involved in it. The dotfile repository is the concrete implementation of the system described by this skill.

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

When changing an install flag, inspect how an existing flag is represented in all three flag locations plus the package or external declaration that consumes it.

# Adding New Capabilities

Treat a new tool or capability as a feature of the whole chezmoi setup, not merely as a package declaration or configuration file.

Start by finding a similar existing tool and inspect every part of its integration. Depending on the feature, that may include:

* `dot_config/private_homebrew/Brewfile.tmpl`
* `dot_config/aptitude/empty_Aptfile.tmpl`
* `dot_config/snap/empty_Snapfile.tmpl`
* `.chezmoiexternal.toml`
* `dot_config/mise/config.toml.tmpl`, for tools distributed only through a language package manager
* `.chezmoi.toml.tmpl`
* `.chezmoidata.toml`
* `.chezmoiscripts/`
* application configuration under `dot_config/...`
* shell functions under `dot_config/shell/functions/`
* completions under `dot_local/share/zsh/custom-completions/`
* platform or GUI template conditions
* the current machine's own `~/.config/chezmoi/chezmoi.toml`, if the tool should be enabled here right now

Not every tool needs every integration point, and chezmoi does not fail loudly when one is missing, so a feature can look done here while staying incomplete elsewhere.

# Safe Change Workflow

After changing templates or source files, inspect what chezmoi actually renders rather than reasoning only from the template source:

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

Do not edit a target file merely to make the current machine work while leaving the corresponding source unchanged. That creates configuration drift and the change can disappear on the next apply.

# Ambiguity and Intent

Resolve implementation questions by inspecting the existing chezmoi source state first.

If an analogous tool already establishes how install flags, package declarations, externals, templates, shell integration, or platform conditions work, follow that precedent instead of asking the user to choose implementation details that the source state already answers.

Ask when the unresolved question is about intent rather than mechanics.

The most important case is a completely new tool, file, or behavior with no precedent in the source state. Infer intent from the request when possible: if the user explicitly asks to add it to dotfiles, chezmoi, or make it reproducible across machines, treat it as a permanent addition; if the user only asks to install or configure something on the current machine, do not automatically add it to chezmoi. If the distinction materially affects the implementation and intent remains unclear, ask whether the change should be local-only or managed by chezmoi.

When no exact precedent exists, fall back to the reasoning in Bootstrap and Installation and Repository Structure rather than guessing.
