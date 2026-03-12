# Chezmoi Dotfiles

macOS system configuration & development environment manager using [chezmoi](https://www.chezmoi.io).

## TL;DR: What Problem Does This Solve?

**The Problem:** Setting up a new macOS machine takes hours—manually installing 100+ tools, configuring shell settings, managing API keys, and syncing configurations. Every reinstall means repeating this tedious process. Mistakes introduce inconsistencies across machines.

**The Solution:** Infrastructure-as-code for your personal machine. Version-control your entire macOS setup (dotfiles, tool configs, installed apps) in a Git repository. Run one command—`chezmoi init`—and get a fully configured development environment in as little as 30 minutes instead of hours.

**The Benefit:**
- **For individuals:** New machine? Full setup in as little as 20 minutes instead of 4+ hours. No forgotten tools or configs.
- **Consulting/Contracting: Multiple projects or clients:** Jump between client projects with different tool requirements without environment conflicts.

## How It Works

**Three-layer installation system:**

1. **Universal packages** (git, vim, curl, chezmoi) — installed on every profile
2. **Profile-based tools** (work/personal/server/light) — choose once at init, installs profile-specific packages
3. **Optional features** (Docker, Xcode, Spotify, media tools) — toggle individually per profile

**Supports all installation methods:**
- **Homebrew formulas** (CLI tools): `brew "speedtest"`, `brew "nmap"`
- **Homebrew Casks** (GUI apps): `cask "docker"`, `cask "spotify"`
- **Mac App Store apps** via `mas` CLI: `mas "Xcode", id: 497799835`

**Batch installation by feature:** Instead of installing tools one-by-one, toggle a feature like "iOS Developer" to install an entire stack at once:

```bash
# Toggle "iosDeveloper: true" in your config, then chezmoi apply runs:
brew bundle --file=/dev/stdin <<EOF
tap "homebrew/cask"
brew "libimobiledevice"              # CLI tool (formula)
cask "spotify"                       # GUI app (cask)
mas "Xcode", id: 497799835           # App Store app
mas "TestFlight", id: 899247664
mas "Developer", id: 640199958
EOF
```

One toggle installs everything needed for iOS development—no manual clicking, no forgetting a tool. Use the same approach for other stacks: "React Native", "Docker", "Monitoring", etc.

## Quick Start

### One-liner (fresh macOS)
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply florsluis
```

### Manual setup
```bash
# Clone and initialize
chezmoi init
# → Select profile: work, personal, server, light
# → Enter email & name
# → Select features to install (multi-select)

# Apply to your system
chezmoi apply

# After editing dotfiles
chezmoi edit ~/.zshrc
chezmoi apply
```

## Profiles

| Profile | Use Case | Theme | GUI |
|---------|----------|-------|-----|
| **work** | Multiple client projects | ✅ Powerlevel10k | ✅ IDE, editors |
| **personal** | Personal projects | ✅ Powerlevel10k | ✅ Similar to work |
| **server** | Remote machines | ❌ Minimal | ❌ CLI only |
| **light** | Temporary setup | ❌ Barebones | ❌ CLI only |

## Tools Installed

### Universal (all profiles)
- `bash`, `git`, `curl`, `vim`, `chezmoi`, `gh`
- `fzf` — fuzzy finder
- `just` — task runner
- `jq`, `htop`, `tree`, `watch`

### DevTools (optional toggle, default: on for work/personal)
- `mise` — runtime version manager (node, python, ruby, etc.)
- `nvm`, `jenv`, `pyenv` — coexist with mise, migrate projects incrementally
- `minikube` — local Kubernetes
- `iterm2`, `warp` — terminal emulators
- `visual-studio-code`, `sublime-text` — editors
- `asciinema` — recording tool

### Other toggles
- **docker** — Docker Desktop
- **spotify** — Spotify app
- **productivity** — Logseq, Typora, Drawio, Raindrop
- **mediaTools** — OBS, Kap
- **monitoring** — Speedtest, Nmap, Iperf3
- **utilities** — AppCleaner, BetterDisplay, DaisyDisk
- **workSpecific** — Acli, Jira CLI, Qflipper (work only)
- **personalTools** — Calibre (personal only)

## Shortcuts & Workflows

### Aliases
```bash
g status                    # → git status
k get pods                  # → kubectl get pods
dc ps                       # → docker compose ps
pivot                       # → fuzzy-search & switch to project
```

### Project Management
```bash
# Switch to a client project
pivot                       # fzf over ~/codebase, cd there

# Manage runtimes per project
cd ~/codebase/client-a
mise install                # read versions from mise.toml
node --version              # uses project's pinned version
```

### Editing Dotfiles
```bash
# Edit a dotfile (opens in your editor)
chezmoi edit ~/.zshrc

# Preview changes before applying
chezmoi diff

# Apply changes
chezmoi apply

# Reload shell
source ~/.zshrc
```

## Project Structure

```
.
├── dot_zshrc.tmpl                    # Main shell config
├── dot_bashrc                        # Bash config
├── dot_vimrc                         # Vim config
├── dot_gitconfig.tmpl                # Git config (templated)
├── dot_justfile.tmpl                 # (if using just globally)
├── .chezmoi.toml.tmpl                # Init prompts (profile + features)
├── .chezmoiscripts/darwin/
│   ├── run_onchange_before_install-packages.sh
│   ├── run_onchange_after_install-devtools.sh.tmpl
│   ├── run_onchange_after_install-docker.sh.tmpl
│   └── ... (other feature toggles)
├── CLAUDE.md                         # Detailed architecture docs
└── README.md                         # This file
```

## Common Tasks

### Change Profile or Features
```bash
nano ~/.config/chezmoi/chezmoi.toml
# Edit [data] section: profile, features list
chezmoi apply
```

### Add a New Tool
```bash
# For all profiles:
# Edit: .chezmoiscripts/darwin/run_onchange_before_install-packages.sh
# Add: brew "toolname"

# For specific features:
# 1. Create: .chezmoiscripts/darwin/run_onchange_after_install-FEATURE.sh.tmpl
# 2. Add feature check: if ! echo "{{ .features | toJson }}" | grep -q '"featureName"'; then exit 0; fi
# 3. Add to .chezmoi.toml.tmpl prompts
```

### Migrate from nvm/pyenv to mise
```bash
cd ~/codebase/project
mise use node@20              # creates mise.toml
mise use python@3.12
mise install
rm .nvmrc .python-version    # if they exist
```

## Tips

- **Chezmoi is idempotent** — safe to run `chezmoi apply` repeatedly
- **Use `chezmoi status`** before `chezmoi apply` to see what changed
- **Template files need `.tmpl`** if they use chezmoi syntax (`{{ }}`)
- **Shell functions live in `dot_zshrc.tmpl`** — they're loaded on startup
- **mise is per-directory** — each repo with `mise.toml` uses its own versions

## Links

- [chezmoi docs](https://www.chezmoi.io)
- [mise docs](https://mise.jdx.dev)
- [just docs](https://just.systems)
- [fzf docs](https://github.com/junegunn/fzf)

See **CLAUDE.md** for detailed architecture & templating patterns.

## Next Steps

- Add 1Password integration for credential management
- Set up GitHub SSH key auto-generation on first init
- Create project-level `just` task templates
- Add shell function to switch git email per profile
- Automate daily dotfiles sync checks