#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup"
REPO_HTTPS="https://github.com/jacksonblankenship/dotfiles.git"
REPO_SSH="git@github.com:jacksonblankenship/dotfiles.git"

dot() {
  git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

# 1. Clone
if [ -d "$DOTFILES_DIR" ]; then
  echo "Error: $DOTFILES_DIR already exists"
  exit 1
fi

echo "Cloning dotfiles..."
git clone --bare "$REPO_HTTPS" "$DOTFILES_DIR"

# 2. Checkout, backing up conflicts
if ! dot checkout 2>/dev/null; then
  echo "Backing up conflicting files to $BACKUP_DIR..."
  dot checkout 2>&1 | grep "^\t" | awk '{print $1}' | while read -r f; do
    mkdir -p "$BACKUP_DIR/$(dirname "$f")"
    mv "$f" "$BACKUP_DIR/$f"
  done
  dot checkout
fi

# 3. Configure
dot config --local status.showUntrackedFiles no

# 4. Switch remote to SSH
dot remote set-url origin "$REPO_SSH"

echo "Done! Restart your shell to pick up the new config."
