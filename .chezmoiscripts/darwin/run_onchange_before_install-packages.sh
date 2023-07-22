#!/bin/bash

set -eufo pipefail

if ! command -v xcodebuild -version >/dev/null 2>&1; then
    echo '🍎 Installing Xcode Command Line Tools' && xcode-select --install
fi

# Install Homebrew
if ! command -v brew >/dev/null 2>&1; then
    echo '🍺  Installing Homebrew' && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    export PATH="/opt/homebrew/bin:$PATH"
fi

echo '🍺 Installing Homebrew packages' &&
    brew bundle --no-lock --file=/dev/stdin <<EOF
# Brews
brew "asciinema"
brew "bash"
brew "bash-completion@2"
brew "chezmoi"
brew "curl"
brew "gh"
brew "git"
brew "htop"
brew "ipcalc"
brew "iperf3"
brew "iproute2mac"
brew "jenv"
brew "jq"
brew "mas"
brew "minikube"
brew "neofetch"
brew "nmap"
brew "nvm"
# brew "romkatv/powerlevel10k/powerlevel10k"
brew "vim"
# brew "shfmt"
brew "speedtest-cli"
brew "tree"
brew "watch"

# Casks
# cask "1password" # Installed manually
cask "appcleaner"
# cask "arc" # Installed manually
cask "betterdisplay"
cask "calibre"
cask "daisydisk"
cask "docker"
# cask "dozer"
cask "drawio"
cask "iterm2"
cask "kap"
# cask "logitech-g-hub" # Installed manually
cask "logseq"
# cask "monitorcontrol"
cask "obs"
# cask "podman-desktop"
# cask "parallels"
cask "plug"
cask "qflipper"
cask "raindropio"
cask "spotify"
cask "sublime-text"
cask "typora"
cask "visual-studio-code"
cask "warp"
EOF

# Exit without error even if some homebrew packages don't install with brew bundle
trap 'exit 0' ERR

echo '🎉 All done!'