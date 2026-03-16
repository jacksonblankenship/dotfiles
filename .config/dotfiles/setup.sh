#!/usr/bin/env bash
set -u

DOTFILES_DIR="$HOME/.dotfiles"
REPO_HTTPS="https://github.com/jacksonblankenship/dotfiles.git"
REPO_SSH="git@github.com:jacksonblankenship/dotfiles.git"

dot() {
  git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

# 1. Clone or fetch (always use HTTPS — SSH agent isn't available until after checkout)
if [ -d "$DOTFILES_DIR" ]; then
  echo "Dotfiles repo already exists, fetching latest..."
  dot remote set-url origin "$REPO_HTTPS"
  dot fetch origin main || { echo "Error: fetch failed"; exit 1; }
  ref=FETCH_HEAD
else
  echo "Cloning dotfiles..."
  git clone --bare "$REPO_HTTPS" "$DOTFILES_DIR" || { echo "Error: clone failed"; exit 1; }
  ref=HEAD
fi

# 2. Force checkout — overwrites any conflicting files
dot reset --hard "$ref" || { echo "Error: checkout failed"; exit 1; }

# 3. Configure
dot config --local status.showUntrackedFiles no

# 4. Switch remote to SSH (now that .ssh/config is in place)
dot remote set-url origin "$REPO_SSH"

echo "Done! Restart your shell to pick up the new config."
