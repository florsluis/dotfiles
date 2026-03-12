# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Quick Reference

**First time setup (in actual terminal, not Claude Code):**
```bash
chezmoi init
# 1. Select profile: work, personal, server, or light
# 2. Enter your email
# 3. Select features (multi-select with defaults pre-selected)
chezmoi diff          # Review changes
chezmoi apply         # Apply everything
```

**Change profile or features after setup:**
```bash
# Edit config
nano ~/.config/chezmoi/chezmoi.toml
# Update profile and/or features list

# Apply changes
chezmoi apply
chezmoi data  # Verify
```

**After shell config changes:**
```bash
source ~/.zshrc
```

## Project Overview

This is a **chezmoi dotfiles repository** that manages macOS system configuration, including shell configuration, Homebrew packages, and development tools. The repository is synced via chezmoi to keep the local system in sync with the dotfiles.

## Common Development Commands

### Chezmoi Operations
- **Apply changes locally**: `chezmoi apply` - Applies all dotfiles to the system (idempotent)
- **View what would change**: `chezmoi status` - Shows what files differ from the system
- **Diff a specific file**: `chezmoi diff <file>` - Preview changes before applying
- **Edit a dotfile**: `chezmoi edit <file>` - Edit a dotfile in the repository (opens in editor)
- **Update from system**: `chezmoi re-add` - Refresh dotfile from current system state

### Development Workflow
- **Source changes immediately**: `source ~/.zshrc` (or alias `_src`)
- **Quick edit in VS Code**: Use the `_chezmoi` alias to open the repository directory
- **Review before committing**: Always run `chezmoi status` and `chezmoi diff <file>` before committing changes

## Repository Structure

```
.
├── dot_zshrc.tmpl                           # Shell config (profile & toggle-aware)
├── dot_bashrc                               # Bash configuration
├── dot_vimrc                                # Vim configuration
├── dot_gitconfig.tmpl                       # Git configuration (template)
├── .chezmoi.toml.tmpl                       # Chezmoi config (prompts for profile & toggles)
├── .chezmoiscripts/darwin/
│   ├── run_onchange_before_install-packages.sh      # Universal packages
│   ├── run_onchange_after_install-devtools.sh       # Dev tools (toggle)
│   ├── run_onchange_after_install-docker.sh         # Docker (toggle)
│   ├── run_onchange_after_install-theme.sh          # Powerlevel10k + fastfetch (GUI only)
│   ├── run_onchange_after_install-desktop-apps.sh   # Amphetamine, Magnet, WireGuard (toggle)
│   ├── run_onchange_after_install-spotify.sh        # Spotify (toggle)
│   ├── run_onchange_after_install-productivity.sh   # Productivity apps (toggle)
│   ├── run_onchange_after_install-mediatools.sh     # OBS, Kap (toggle)
│   ├── run_onchange_after_install-monitoring.sh     # Network tools (toggle)
│   ├── run_onchange_after_install-work-specific.sh  # Work tools (toggle)
│   ├── run_onchange_after_install-utilities.sh      # System utils (toggle)
│   ├── run_onchange_after_install-personal-tools.sh # Personal tools (toggle)
│   ├── run_onchange_after_install-ios-developer.sh  # XCode, TestFlight, Developer (toggle)
│   ├── run_onchange_after_install-windows-app.sh    # Windows App (toggle)
│   └── run_onchange_after_configure.sh              # Post-setup cleanup
├── .chezmoiignore                           # Files to ignore
├── scripts/helpers.sh                       # Shell helpers (mostly unused)
└── assets/fonts/                            # Font files for Powerlevel10k
```

## Profile System

This repository uses **profiles + feature toggles** to support different machine types and use cases.

### Four Profiles

| Profile | Use Case | Theme | GUI Apps | Toggles |
|---------|----------|-------|----------|---------|
| **work** | Multiple projects, full dev environment | ✅ Powerlevel10k + fastfetch | ✅ IDE, editors, media tools | devTools, docker, desktopApps, iosDeveloper, windowsRemoteDesktop, mediaTools, monitoring, utilities, productivity, workSpecific, spotify |
| **personal** | Personal projects and hobby coding on separate machine | ✅ Powerlevel10k + fastfetch | ✅ Similar to work but without work-specific tools | devTools, docker, desktopApps, iosDeveloper, windowsRemoteDesktop, mediaTools, utilities, productivity, personalTools, spotify |
| **server** | SSH access, remote machines, minimal setup | ❌ No theme | ❌ No GUI apps | docker (default off), monitoring |
| **light** | One-off, temporary, or minimal setup | ❌ No theme | ❌ No GUI apps | None - barebones only |

### Feature Selection

During `chezmoi init`, after selecting your profile, you get a **multi-select prompt** to choose features:

```
Select features to install (use space to select, enter to confirm):
[x] devTools
[x] docker
[x] spotify
[ ] mediaTools
[ ] monitoring
[x] productivity
[ ] workSpecific
[ ] utilities
```

**Defaults per profile:**

| Feature | Work | Personal | Server | Light |
|---------|------|----------|--------|-------|
| **devTools** | ✅ default | ✅ default | ❌ | ❌ |
| **docker** | ✅ default | ✅ default | ❌ | ❌ |
| **spotify** | ✅ default | ✅ default | ❌ | ❌ |
| **productivity** | ✅ default | ✅ default | ❌ | ❌ |
| **desktopApps** | ✅ default | ✅ default | ❌ | ❌ |
| **mediaTools** | ❌ opt-in | ❌ opt-in | ❌ | ❌ |
| **utilities** | ❌ opt-in | ❌ opt-in | ❌ | ❌ |
| **monitoring** | ❌ opt-in | ❌ | ✅ default | ❌ |
| **iosDeveloper** | ❌ opt-in | ❌ opt-in | ❌ | ❌ |
| **windowsRemoteDesktop** | ❌ opt-in | ❌ opt-in | ❌ | ❌ |
| **workSpecific** | ❌ opt-in | ❌ | ❌ | ❌ |
| **personalTools** | ❌ | ❌ opt-in | ❌ | ❌ |

### How It Works

1. **`.chezmoi.toml.tmpl`** - Prompts for profile, then multi-select features, saves both in `[data]` section
2. **`dot_zshrc.tmpl`** - Uses `{{ if eq .profile "work" }}` and `{{ if has "devTools" .features }}` for conditionals
3. **Install scripts** - Each feature has a script checking `grep -q '"featureName"'` in the features JSON list before installing

## Key Configuration Files

### dot_zshrc.tmpl
Main zsh configuration (template). Uses profiles and toggles:

**Always included**:
- Homebrew PATH
- Chezmoi aliases (`_chezmoi`, `_src`)
- **Shortcut aliases** (universal):
  - `g` → `git`
  - `k` → `kubectl`
  - `dc` → `docker compose`
  - `pivot` → fuzzy-search projects via fzf, `cd` to selection

**GUI profiles (work/personal)** - conditional on `{{ if or (eq .profile "work") (eq .profile "personal") }}`:
- Powerlevel10k theme + instant prompt
- Theme configuration from `~/.p10k.zsh`

**Dev tools enabled** - conditional on `{{ if .devTools }}`:
- NVM (Node version manager)
- CURL PATH configuration
- **mise activation** — runtime version manager (`eval "$(mise activate zsh)"`)
- For work: GitHub PR functions, codebase aliases
- For personal: Project aliases

**Work profile + productivity toggle**:
- Slack, Outlook, Logseq, Arc shortcuts
- `headstorm()` and `production()` functions

**Server & light profiles**:
- Minimal setup only

### .chezmoi.toml.tmpl
Chezmoi configuration template. Prompts for:
1. **profile**: work, personal, server, or light
2. **email**: User's email address
3. **hostname**: Auto-detected from system
4. **Toggles**: Depends on profile (see Feature Toggles above)

### Homebrew Installation
Two-stage installation process:

**1. Universal Install** (`run_onchange_before_install-packages.sh`)
- Installs Xcode Command Line Tools (if needed)
- Installs Homebrew (if needed)
- Installs universal packages: bash, git, chezmoi, gh, curl, vim, tree, watch, htop, jq
- `fzf` — fuzzy finder for project switching
- `just` — task runner for per-repo workflows
- `mas` — Mac App Store CLI for managing App Store apps

**2. Profile + Toggle-Based Installs** (all after universal)

Each script checks its toggle flag before installing:

| Script | Installs | Condition |
|--------|----------|-----------|
| **devtools** | VS Code, iTerm2, Warp, NVM, Jenv, Mise, Minikube, Asciinema | `{{ .devTools }}` |
| **docker** | Docker Desktop | `{{ .docker }}` |
| **theme** | Powerlevel10k, fastfetch | GUI profiles (work/personal) |
| **desktop-apps** | Amphetamine, Magnet, WireGuard | `{{ .desktopApps }}` |
| **spotify** | Spotify | `{{ .spotify }}` |
| **productivity** | Logseq, Typora, Drawio, Raindropio | `{{ .productivity }}` |
| **mediatools** | OBS, Kap | `{{ .mediaTools }}` |
| **monitoring** | Speedtest (Ookla), Nmap, Iperf3, Ipcalc | `{{ .monitoring }}` |
| **ios-developer** | Xcode, TestFlight, Developer | `{{ .iosDeveloper }}` |
| **windows-app** | Windows App (remote desktop) | `{{ .windowsRemoteDesktop }}` |
| **work-specific** | Acli, Jira CLI, Qflipper | `{{ .workSpecific }}` (work only) |
| **utilities** | Appcleaner, Betterdisplay, Daisydisk | `{{ .utilities }}` |
| **personal-tools** | Calibre | `{{ .personalTools }}` (personal only) |

**Note**: Some packages are manually installed (1password, Arc, Logitech G Hub).

### dot_gitconfig.tmpl
Uses chezmoi templating to prompt for email on first setup. Simple configuration template.

## Architecture Notes

### Templating System
Native chezmoi templating for flexible configuration:

- **`.chezmoi.toml.tmpl`**: Runs during `chezmoi init`, prompts for profile + toggles, stores in `[data]`
- **`dot_zshrc.tmpl`**: Uses `{{ if eq .profile "work" }}` and `{{ if .devTools }}` for conditional loading
- **Install scripts**: Use `{{ .TOGGLE_NAME }}` to conditionally run

Available variables in all templates:
- `{{ .profile }}`: "work", "personal", "server", or "light"
- `{{ .email }}`: User's email address
- `{{ .hostname }}`: Machine hostname (auto-detected)
- `{{ .features }}`: List of selected features (array of strings)

### Script Lifecycle
Chezmoi scripts use naming conventions:
- `run_onchange_before_*`: Runs before applying template files
- `run_onchange_after_*`: Runs after applying template files
- Scripts re-run if their content changes (useful for updating package lists)

### Profile vs Toggle Design
- **Profile**: Chosen once at init, defines the machine type (work/personal/server/light)
- **Toggles**: Per-profile customizations that default intelligently (docker on by default for work/personal, off for server)
- **Advantage**: Single profile with flexible features > multiple rigid profiles

### Manual Installations
Some apps require manual setup (prefer manual for app-store sync, security, or licensing):
- 1password, Arc, Logitech G Hub - keep as manual installs
- Other apps can be toggled or moved to manual if needed

## Important Considerations

### When Making Changes
1. Files with conditional content must use `.tmpl` extension
2. Test templates: `chezmoi execute-template dot_zshrc.tmpl`
3. Preview changes: `chezmoi diff` before `chezmoi apply`
4. After edits, reload: `source ~/.zshrc`
5. Commit changes to git when meaningful

### Editing Profile/Feature-Aware Files

In templates, use the `has` function to check if a feature is in the list:

```zsh
# GUI profiles only
{{- if or (eq .profile "work") (eq .profile "personal") }}
  # Desktop config here
{{- end }}

# Specific feature enabled
{{- if has "devTools" .features }}
  # Only if devTools is in the features list
{{- end }}

# Profile + feature combination
{{- if and (eq .profile "work") (has "monitoring" .features) }}
  # Work profile with monitoring enabled
{{- end }}
```

In shell scripts, check the JSON features array:

```bash
# Only run if feature is enabled
if ! echo "{{ .features | toJson }}" | grep -q '"featureName"'; then
    exit 0
fi
```

### Changing Profile or Features
After initial setup, to change settings:
1. Edit the config file:
   ```bash
   nano ~/.config/chezmoi/chezmoi.toml
   ```
2. Update the data section:
   ```toml
   [data]
     profile = "personal"
     email = "your@email.com"
     hostname = "your-machine"
     features = ["devTools", "docker", "spotify", "productivity"]
   ```
3. Apply changes:
   ```bash
   chezmoi apply
   chezmoi data  # Verify the change
   ```

### Adding New Tools

**For profile-specific tools:**
1. Add to `dot_zshrc.tmpl` with profile check:
   ```zsh
   {{- if eq .profile "work" }}
   # Your work-only config
   {{- end }}
   ```

**For new optional features:**
1. Create `run_onchange_after_install-FEATURE.sh`:
   ```bash
   if ! echo "{{ .features | toJson }}" | grep -q '"newFeature"'; then
       exit 0
   fi
   ```
2. Add `newFeature` to the `promptMultichoice` lists in `.chezmoi.toml.tmpl` (per profile)
3. Use `{{ if has "newFeature" .features }}` in templates
4. Test with all profiles before committing

### GitHub PR Functions
`list_prs()` and `review_pull_request()` (work profile):
- Requires `gh` CLI installed (universal package)
- Requires GitHub authentication: `gh auth login`
- Only loaded when `devTools` enabled in work profile

### Font Requirements
Powerlevel10k needs fonts to display correctly (GUI systems only):
- Fonts in `assets/fonts/` must be installed on the system
- Automatic on first setup if using GUI profile

## Client Pivot Workflow

Seamlessly switch between client projects without environment conflicts.

### Tools

- **mise** — Runtime version manager (node, python, ruby, go, java, rust, etc.)
  - Per-repo configuration via `mise.toml`
  - Auto-activates runtimes when entering a project directory
  - Coexists with nvm/pyenv/jenv (no removal required)

- **just** — Task runner for per-repo workflows
  - Define dev, test, build, deploy commands in project's `justfile`
  - Execute with `just <recipe>` from any repo directory

- **fzf** — Fuzzy finder for quick project selection
  - `pivot` alias opens interactive project browser
  - Fuzzy-search over `{{ .projectsDir }}` directories

### Usage

```bash
# Switch to a project
pivot
# → Opens fzf, select project, cd there

# Inside a project with mise.toml
mise install              # Install runtimes
node --version            # Uses project-pinned version

# Inside a project with justfile
just                      # List recipes
just dev                  # Start dev environment
just test                 # Run tests
just build                # Build project
```

### Implementation Details

**Shell Aliases** (in `dot_zshrc.tmpl`):
- `g` → `git`
- `k` → `kubectl`
- `dc` → `docker compose`
- `pivot` → `cd {{ .projectsDir }}/$(ls {{ .projectsDir }} | fzf)`

**Mise Activation** (in `dot_zshrc.tmpl`, devTools block):
- `eval "$(mise activate zsh)"` — enables per-directory runtime switching
- Reads `mise.toml` in project root, loads specified versions
- Unsets when leaving directory

**Project Structure Example**:
```
~/codebase/client-a/
├── mise.toml          # node = "20", python = "3.12"
├── justfile           # recipes: dev, test, build, deploy
└── ...source files
```

### Migration from nvm/pyenv

Existing projects continue to work with nvm/pyenv. To migrate a project to mise:

```bash
cd ~/codebase/client-a
mise use node@20              # Read from .nvmrc or prompt
mise use python@3.12
mise install
rm .nvmrc .python-version     # Optional cleanup
```

Mise shims take precedence over nvm/pyenv when active, so old and new projects coexist.

### Future Enhancement: 1Password Integration

Credentials (API keys, database passwords, tokens) will be stored in 1Password vault, not in `.env` files. Chezmoi templates will pull credentials during setup or runtime, eliminating plaintext secrets in git or local files.

## Per-Client Git Identities

For each client with a separate account, copy `assets/gitconfig-client.template` to `~/.gitconfig-{client-name}`, edit with the client email, then add an `includeIf` block to `~/.gitconfig`:

```ini
[includeIf "gitdir:~/code/{client-name}/"]
    path = ~/.gitconfig-{client-name}
```

## Git Workflow
This repository follows standard git practices:
- Each commit should represent a logical change
- Recent commits focus on: aliases/functions, brew export paths, xcode setup, PR management, and client pivot workflow
- Changes are applied to the local system via `chezmoi apply`