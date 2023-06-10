#!/bin/bash

echo "Hello!"

set -eufo pipefail

# Removed unstable install of hombrew
# Install Homebrew
# NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

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
cask "daisydisk"
# cask "docker" # Installed manually
cask "drawio"
cask "iterm2"
# cask "logitech-g-hub" # Installed manually
cask "monitorcontrol"
cask "obs"
cask "qflipper"
cask "raindropio"
cask "spotify"
cask "sublime-text"
cask "visual-studio-code"
cask "warp"
EOF