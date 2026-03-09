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

echo '🍺 Installing universal Homebrew packages' &&
    brew bundle --file=/dev/stdin <<EOF
# Brews - Universal packages
brew "bash"
brew "bash-completion@2"
brew "chezmoi"
brew "curl"
brew "gh"
brew "git"
brew "htop"
brew "jq"
brew "vim"
brew "tree"
brew "watch"
EOF

# Exit without error even if some homebrew packages don't install with brew bundle
trap 'exit 0' ERR

echo '🎉 All done!'