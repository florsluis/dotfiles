#!/bin/bash

set -eufo pipefail

# Install Homebrew
command -v brew >/dev/null 2>&1 || \
    (echo '🍺  Installing Homebrew' && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)")

echo '🍺 Installing Homebrew packages' && \
brew bundle --no-lock --file=/dev/stdin <<EOF
# Brews
brew "asciinema"
brew "bash"
brew "bash-completion@2"
brew "chezmoi"
brew "gh"
brew "git"
brew "htop"
brew "ipcalc"
brew "iperf3"
brew "jenv"
brew "jq"
brew "mas"
brew "minikube"
brew "neofetch"
brew "nmap"
brew "nvm"
brew "vim"
brew "speedtest-cli"
brew "tree"
brew "watch"

# Casks
# cask "1password" # Installed manually
cask "appcleaner"
# cask "arc" # Installed manually
cask "calibre"
cask "daisydisk"
cask "docker"
# cask "dozer"
cask "drawio"
cask "iterm2"
# cask "logitech-g-hub" # Installed manually
cask "logseq"
cask "monitorcontrol"
cask "obs"
# cask "podman-desktop"
# cask "parallels"
cask "plug"
cask "qflipper"
cask "raindropio"
cask "spotify"
cask "sublime-text"
cask "visual-studio-code"
cask "warp"
EOF