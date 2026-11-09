# Source and Target State

This repository manages a chezmoi-based dotfiles setup.

Chezmoi has two important locations:

* **Source state:** usually `~/.local/share/chezmoi`.
  If that path doesn't exist, confirm the actual location with `chezmoi source-path`.
* **Target state:** the files deployed into the user's home directory,
  for example `~/.config/...`, `~/.zshrc`, and similar paths.

The source state is authoritative and version-controlled.
Make durable changes there,
because `chezmoi apply` overwrites the target state.

Treat `chezmoi apply` as an explicit deployment step and never run it automatically.
The user deploys changes themselves and knows when that is needed,
so responses leave out reminders to run `chezmoi apply`.

# Repository Structure

The chezmoi source state contains both ordinary configuration files
and the logic used to bootstrap and configure a machine.

Tools are controlled by `install.<tool>` flags,
and every installation path for a tool is gated by its flag.
Three files hold each flag.
None of them reference each other,
so all three are kept in sync by hand:

* `.chezmoidata.toml` holds the repository-wide default (normally `false`),
  used by any machine that hasn't overridden it.
* `.chezmoi.toml.tmpl` is the machine-initialization template,
  used by `chezmoi init` on a new machine.
  It asks for each flag interactively,
  wrapped in a platform predicate so it's only asked where an install path exists for that platform.
* `~/.config/chezmoi/chezmoi.toml` stores each machine's answers.
  It lives outside the source repository, is unversioned, and is not shared between machines.
  Users can adjust its flags after initialization,
  and only this file decides what `chezmoi apply` installs on that machine.

Package installation is split by mechanism:

* `dot_config/private_homebrew/Brewfile.tmpl` contains Homebrew formulas and casks.
* `dot_config/aptitude/empty_Aptfile.tmpl` contains apt-managed packages.
* `dot_config/snap/empty_Snapfile.tmpl` contains snap-managed packages.
* `.chezmoiexternal.toml` contains external downloads:
  archives, git repositories, plugins, standalone assets,
  and upstream-release fallbacks for when Homebrew is unavailable.
* `dot_config/mise/config.toml.tmpl` contains mise-managed language runtimes
  and tools distributed only through a language package manager.
* `.chezmoiscripts/` contains bootstrap and setup scripts,
  especially work with ordering requirements
  or work that cannot be expressed as a static package declaration.

Application configuration lives in the corresponding chezmoi source path.
For example, `dot_config/nvim/` produces configuration under `~/.config/nvim/`.

Shell initialization, aliases, environment setup, and completions
live with the existing shell configuration in the source state
(for example, autoloaded shell functions under `dot_config/shell/functions/`,
and zsh completions under `dot_local/share/zsh/custom-completions/`).
Installation and shell integration are separate concerns,
so installing a CLI package does not by itself complete its integration.

# Bootstrap and Installation

Homebrew is the default package manager for user-space software in this setup,
on both macOS and Linux.
Prefer it whenever it's available.
This keeps package management consistent across systems,
generally provides recent versions,
and avoids parallel installation paths.

**Apt** is the right choice over Homebrew
when the tool is closer to core system plumbing than to a user-curated toolchain
(`build-essential` and similar),
or when apt needs it before Homebrew can be installed.
On a machine without Homebrew,
apt is also the first thing to check for a tool that still needs to exist there,
as long as the packaged version is recent enough for what this repo's configuration relies on.
Otherwise use an upstream-release fallback in `.chezmoiexternal.toml`.

**Snap** is used on Linux when Homebrew has no path to a tool,
and the tool needs to be recent or needs desktop integration.
Snap publishers push updates independent of the distro's packaging cycle,
so a snap stays current without waiting on apt.
This applies to command-line tools as much as GUI ones.
For GUI applications,
snap also creates application-menu entries, icons, and desktop-environment integration
that neither apt nor a raw binary fetch provides.

**`.chezmoiexternal.toml`** also manages resources that are not package-manager software,
such as git-based frameworks, shell plugins, and other externally fetched assets.
For those it is the canonical mechanism, whether or not Homebrew exists on the machine.

**Mise** manages the language runtime versions this setup uses
(`ruby`, `rust`, `node`, `python`, `go`),
and CLI tools distributed only through one of those languages' package managers
(`cargo install`, `npm install -g`, `pip`/`pipx`, `gem install`, `go install`)
when Homebrew has no formula for them.

Do not create fallback machinery for every package.
Multiple installation paths add maintenance cost,
so a non-Homebrew path exists only
when machines without Homebrew need that software.
Never install the same software through multiple mechanisms on the same machine.
Ask the user when it's unclear which mechanism fits.

# Shared, Platform, and Machine-Specific State

This setup supports different machine types,
including macOS systems, Linux desktops, Raspberry Pis, and restricted servers.
Templates let one repository produce a different target state on each,
and changes preserve that multi-machine model rather than only making the current machine work.

Use existing template data and capability checks to express real differences between environments.
Prefer conditions based on meaningful properties
such as operating system, GUI availability, Homebrew availability, apt availability,
or another capability,
over host-specific conditions
when the distinction can be expressed as a reusable property of the machine.

When adding an install flag, set its default to `false` in `.chezmoidata.toml`,
derive it from applicable machine capabilities in `.chezmoi.toml.tmpl`,
and gate the consuming package or external declaration with the flag.
Update `~/.config/chezmoi/chezmoi.toml` only when the current machine should enable it.

# Adding New Capabilities

When package availability or installation details are unknown,
research the supported platforms and architectures.
For Homebrew candidates, `brew info --json=v2 <formula>` shows supported combinations.
Consult upstream release sources when another mechanism may be appropriate.
Use **Bootstrap and Installation** to select the mechanism.

When a capability spans multiple integration points,
use a similar existing capability as a guide and update the corresponding files.

# Checking Rendered Changes

Run `chezmoi diff --use-builtin-diff --no-pager` only after changing:

* `.tmpl` files
* `.chezmoidata.toml` or `.chezmoiexternal.toml`
* package declarations
* install flags in `~/.config/chezmoi/chezmoi.toml`

Other source files deploy unchanged, so inspect those files directly.

Check that rendering succeeds,
platform and machine conditions are correct,
no other platform is affected,
packages and externals are gated by the correct install flags,
referenced files and resources exist,
and the diff contains only intended changes.
