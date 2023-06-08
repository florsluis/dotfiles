#!/bin/bash

set -eufo pipefail

# Install Homebrew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew bundle --no-lock --file=/dev/stdin <<EOF

# Brews
brew "asciinema"
brew "bash"
brew "bash-completion2"
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
brew "speedtest"
brew "tree"
brew "watch"

# Casks
# cask "qflipper"
cask "1password"
cask "arc"
cask "daisydisk"
cask "docker"
cask "drawio"
cask "iterm2"
cask "logitech-g-hub"
cask "monitorcontrol"
cask "obs"
cask "raindropio"
cask "spotify"
cask "sublime-text"
cask "visual-studio-code"
cask "warp"

EOF