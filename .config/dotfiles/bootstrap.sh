#!/usr/bin/env bash

# GitHub configuration
# If modified, update ~/.config/fish/functions/dotfiles.fish
github_username="jacksonblankenship"
dotfiles_repo_name="dotfiles"

# URLs for the dotfiles repository
dotfiles_path="${github_username}/${dotfiles_repo_name}.git"
dotfiles_https="https://github.com/${dotfiles_path}"
dotfiles_ssh="git@github.com:${dotfiles_path}"

# Local git repository paths
dotfiles_work_tree="$HOME"
dotfiles_git_dir="$HOME/.${dotfiles_repo_name}"

# Homebrew dependencies for core configuration
homebrew_dependencies=(
  "coreutils" # Latest versions of common utilities
  "fish"      # Default shell
  "nvim"      # Default editor
  "lsd"       # LS replacement
  "ccat"      # Cat replacement
  "starship"  # Fish shell theme
  "gh"        # GitHub CLI
  "docker"    # Docker
)

# Directories to create
directories=(
  "$HOME/projects"
  "$HOME/tmp"
)

# Logging utility
_echo() {
  case "$1" in
  error)
    printf "\\n\\e[1;31m[ ❌ ]\\e[0m %s\\n" "$2"
    ;;
  info)
    printf "\\n\\e[1;34m[ ℹ️ ]\\e[0m %s\\n" "$2"
    ;;
  warn)
    printf "\\n\\e[1;33m[ ⚠️  ]\\e[0m %s\\n" "$2"
    ;;
  success)
    printf "\\n\\e[1;32m[ ✅ ]\\e[0m %s\\n" "$2"
    ;;
  *)
    echo "Improper usage of logger"
    exit 1
    ;;
  esac
}

# Skip user interaction in CI
if [[ -z "$CI" ]]; then
  # Confirm user's intent to proceed
  echo
  read -p $'\e[1;33m[ ⚠️ ]\e[0m This process will overwrite your existing dotfiles. Continue? (Y/n) ' -n 1 -r
  echo

  # Abort if user does not consent
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    _echo "info" "Aborting..."
    exit 1
  fi
else
  _echo "info" "Skipping user interaction in CI environment."
fi

# Verify macOS system
if [[ ! "$OSTYPE" == "darwin"* ]]; then
  _echo "error" "This script is only compatible with macOS systems."
  exit 1
fi

# Ensure command line tools are installed
if ! xcode-select -p >/dev/null 2>&1; then
  _echo "error" "Command line developer tools are required. Run 'xcode-select --install' and try again."
  exit 1
fi

# Clone dotfiles repository
# @link https://www.atlassian.com/git/tutorials/dotfiles
_echo "info" "Cloning dotfiles from $dotfiles_https"

# Remove conflicting directory if it exists
if [[ -d "$dotfiles_git_dir" ]]; then
  rm -rf "$dotfiles_git_dir"
fi

# Clone the dotfiles repository
if git clone --bare "$dotfiles_https" "$dotfiles_git_dir"; then
  _echo "success" "Checking out dotfiles to $dotfiles_work_tree"

  # Checkout dotfiles to the home directory, overriding conflicts
  git --git-dir="$dotfiles_git_dir" --work-tree="$dotfiles_work_tree" checkout --force

  # Instruct git to ignore untracked files
  git --git-dir="$dotfiles_git_dir" --work-tree="$dotfiles_work_tree" config --local status.showUntrackedFiles no
else
  _echo "error" "Unable to clone dotfiles"
  exit 1
fi

# Install asdf
# @link https://asdf-vm.com/guide/getting-started.html#_2-download-asdf
asdf_dir="$HOME/.asdf"
asdf_tool_versions="$HOME/.tool-versions"

_echo "info" "Installing asdf"

if ! command -v asdf >/dev/null 2>&1; then
  if [[ -d "$asdf_dir" ]]; then
    rm -rf "$asdf_dir"
  fi

  if ! git clone https://github.com/asdf-vm/asdf.git "$asdf_dir" --branch v0.11.1; then
    _echo "error" "Unable to clone asdf"
    exit 1
  fi

  # Symlink asdf completions to fish config if not already present
  if [[ -f $HOME/.asdf/completions/asdf.fish ]] && [[ ! -f $HOME/.config/fish/completions/asdf.fish ]]; then
    _echo "success" "Symlinking asdf fish completions"

    mkdir -p "$HOME/.config/fish/completions"
    ln -s "$HOME/.asdf/completions/asdf.fish" "$HOME/.config/fish/completions"
  fi

  # Temporarily source asdf for installation purposes
  # shellcheck source=/dev/null
  . "$asdf_dir/asdf.sh"
fi

# Configure asdf
_echo "info" "Updating asdf"

# Update asdf as the given branch may be out of date
if ! asdf update; then
  _echo "error" "Failed to update asdf"
  exit 1
fi

_echo "info" "Adding nodejs plugin to asdf"

# Add Node.js plugin to asdf
if ! asdf plugin add nodejs; then
  _echo "error" "Unable to add nodejs plugin to asdf"
  exit 1
fi

# Add Python plugin to asdf
if ! asdf plugin add python; then
  _echo "error" "Unable to add python plugin to asdf"
  exit 1
fi

_echo "info" "Installing tool versions listed in $asdf_tool_versions"

# Install versions listed in .tool-versions
if [[ ! -f "$asdf_tool_versions" ]]; then
  _echo "error" "Unable to locate asdf tool versions at $asdf_tool_versions"
  exit 1
else
  if ! asdf install; then
    _echo "error" "Unable to install asdf tool versions"
    exit 1
  fi
fi

# Ensure Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install Homebrew if not found
if ! command -v brew >/dev/null 2>&1; then
  _echo "info" "Homebrew not found. Attempting to install Homebrew..."

  # Install Homebrew
  # https://github.com/homebrew/install#install-homebrew-on-macos-or-linux
  if ! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
    _echo "error" "Unable to install Homebrew"
    exit 1
  fi

  # Source Homebrew for installation purposes
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

_echo "info" "Installing required Homebrew dependencies..."

# Install all required Homebrew dependencies
for package in "${homebrew_dependencies[@]}"; do
  _echo "info" "Ensuring $package is installed..."
  if ! brew list "$package" >/dev/null 2>&1; then
    if ! brew install "$package"; then
      _echo "error" "Failed to install Homebrew package $package."
      exit 1
    fi
  fi
done

# Skip Nerd Fonts installation in CI
if [[ -z "$CI" ]]; then
  _echo "info" "Installing Nerd Fonts..."

  # Install all Nerd Fonts
  # https://gist.github.com/davidteren/898f2dcccd42d9f8680ec69a3a5d350e
  if brew tap homebrew/cask-fonts; then
    if ! brew search '/font-.*-nerd-font/' | awk '{ print $1 }' | xargs -I{} brew install --cask {}; then
      _echo "error" "Failed to install some or all Nerd Fonts."
      exit 1
    fi
  else
    _echo "error" "Failed to tap homebrew/cask-fonts."
    exit 1
  fi
else
  _echo "info" "Skipping Nerd Fonts installation in CI environment."
fi

# Skip Brewfile installation in CI
if [[ -z "$CI" ]]; then
  _echo "info" "Installing Homebrew packages from Brewfile..."

  # Install Homebrew packages using Brewfile
  if [[ -f "$HOME/.Brewfile" ]]; then
    if ! brew bundle install --global; then
      _echo "error" "Failed to install packages using Brewfile."
      exit 1
    fi
  fi
else
  _echo "info" "Skipping Brewfile installation in CI environment."
fi

# Skip GitHub key generation and HTTPS to SSH protocol switch in CI
if [[ -z "$CI" ]]; then
  # Generate Ed25519 key pair by authenticating with GitHub
  if [ ! -f "$HOME/.ssh/id_ed25519.pub" ]; then
    # If authenticated with GitHub, sign out
    if gh auth status >/dev/null 2>&1; then
      _echo "info" "Logging out of GitHub CLI"

      if ! gh auth logout; then
        _echo "error" "Unable to log out of GitHub CLI"
        exit 1
      fi
    fi

    _echo "info" "Authenticating with GitHub"

    if ! gh auth login --hostname github.com --git-protocol ssh --web; then
      _echo "error" "Unable to authenticate with GitHub"
      exit 1
    fi
  fi
else
  _echo "info" "Skipping GitHub key generation and protocol switch in CI environment."
fi

_echo "info" "Changing dotfiles repo protocol to SSH"

# Change the dotfiles repository protocol from HTTPS to SSH
if ! git --git-dir="$dotfiles_git_dir" --work-tree="$dotfiles_work_tree" remote set-url origin "$dotfiles_ssh"; then
  _echo "error" "Unable to change dotfiles repo protocol to SSH"
  exit 1
fi

# Set the default Git editor to Neovim
if [[ "$(gh config get editor)" != "nvim" ]]; then
  _echo "info" "Setting default Git editor to Neovim"

  gh config set editor nvim
fi

# Create standard directories
for directory in "${directories[@]}"; do
  if [[ ! -d $directory ]]; then
    _echo "info" "Creating directory $directory"
    if ! mkdir -p "$directory"; then
      _echo "error" "Failed to create directory $directory"
      exit 1
    fi
  fi
done

# Add fish to /etc/shells if not present
if ! grep "$(which fish)" /etc/shells >/dev/null 2>&1; then
  _echo "info" "Adding $(which fish) to /etc/shells"

  which fish | sudo tee -a /etc/shells
fi

_echo "info" "Changing default shell to fish"

# Skip changing shell in CI
if [[ -z "$CI" ]]; then
  # Change default shell to fish
  chsh -s "$(which fish)"
else
  _echo "info" "Skipping changing default shell in CI environment."
fi

_echo "success" "Bootstrap complete. Changes will take effect in the next terminal session."
