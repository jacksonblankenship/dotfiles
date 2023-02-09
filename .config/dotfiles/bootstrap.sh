#!/usr/bin/env bash

# github information
# if this is modified, ~/.config/fish/functions/dotfiles.fish should be updated
github_username="jacksonblankenship"
dotfiles_repo_name="dotfiles"

# https/ssh urls for the dotfiles repository on github
dotfiles_path="${github_username}/${dotfiles_repo_name}.git"
dotfiles_https="https://github.com/${dotfiles_path}"
dotfiles_ssh="git@github.com:${dotfiles_path}"

# local git repo information for dotfiles
dotfiles_work_tree="$HOME"
dotfiles_git_dir="$HOME/.${dotfiles_repo_name}"

# homebrew dependencies required for this shell's core configuration
homebrew_dependencies=(
  # default shell
  "fish"
  # default editor
  "nvim"
  # ls replacement
  "exa"
  # cat replacement
  "ccat"
  # fish shell theme
  "starship"
  # directly interface with github and auto-configure ssh
  "gh"
  # docker is required for our custom docker wrapper
  "docker"
  # gnupg is required for the asdf yarn plugin
  "gpg"
)

# general directories to create
directories=(
  "$HOME/projects"
  "$HOME/tmp"
  "$HOME/tmp/userprofile"
)

# general purpose logging utility
_echo() {
  case "$1" in
  error)
    printf "\\n\\e[1;31m[ ❌ ]\\e[0m %s\\n" "$2"
    ;;
  info)
    printf "\\n\\e[1;32m[ ✅ ]\\e[0m %s\\n" "$2"
    ;;
  warn)
    printf "\\n\\e[1;33m[ ⚠️ ]\\e[0m %s\\n" "$2"
    ;;
  *)
    echo "Improper useage of logger"
    exit 1
    ;;
  esac
}

# skip user interaction in ci
if [[ -z "$CI" ]]; then
  # verify the user knows wtf they're about to do
  echo
  read -p $'\e[1;33m[ ⚠️ ]\e[0m This is a destructive process that will replace your existing dotfiles. Are you sure you want to continue? (Y/n) ' -n 1 -r
  echo

  # abort if the user doesn't consent
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    _echo "info" "Aborting..."
    exit 1
  fi
fi

# validate the current system is running macOS
if [[ ! "$OSTYPE" == "darwin"* ]]; then
  _echo "error" "This script is only compatible with macOS systems."
  exit 1
fi

# validate command line tools are installed
if ! xcode-select -p >/dev/null 2>&1; then
  _echo "error" "This script requires the command line developer tools. Please run xcode-select --install and try again."
  exit 1
fi

# clone dotfiles
# you can read more about this concept here
# https://www.atlassian.com/git/tutorials/dotfiles

_echo "info" "Cloning dotfiles from $dotfiles_https"

# remove conflicting directory if one exists
if [[ -d "$dotfiles_git_dir" ]]; then
  rm -rf "$dotfiles_git_dir"
fi

# clone the dotfiles
if git clone --bare "$dotfiles_https" "$dotfiles_git_dir"; then

  _echo "info" "Checking out dotfiles to $dotfiles_work_tree"

  # checkout the dotfiles to the home directory, override conflicts
  git --git-dir="$dotfiles_git_dir" --work-tree="$dotfiles_work_tree" checkout --force

  # instruct git to ignore untracked files
  git --git-dir="$dotfiles_git_dir" --work-tree="$dotfiles_work_tree" config --local status.showUntrackedFiles no
else
  _echo "error" "Unable to clone dotfiles"
  exit 1
fi

# install asdf
# asdf **highly recommends** that we install with git, so that's what we'll do
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

  # symlink asdf completions to fish config
  if [[ -f $HOME/.asdf/completions/asdf.fish ]]; then
    mkdir -p "$HOME/.config/fish/completions"
    ln -s "$HOME/.asdf/completions/asdf.fish" "$HOME/.config/fish/completions"
  fi

  # temporarially source asdf for purposes of installation
  # shellcheck source=/dev/null
  . "$asdf_dir/asdf.sh"
fi

# asdf configurations
# update asdf and, add nodejs and python plugins, and install versions against .tool-versions
# https://asdf-vm.com/manage/core.html

_echo "info" "Updating asdf"

# update asdf as the given branch in this script may be out of date
if ! asdf update; then
  _echo "error" "Failed to run update command for adsf"
  exit 1
fi

_echo "info" "Adding nodejs plugin to asdf"

# add node.js plugin to asdf
if ! asdf plugin add nodejs; then
  _echo "error" "Unable to add nodejs plugin to adsf"
  exit 1
fi

_echo "info" "Adding yarn plugin to asdf"

# add yarn plugin to asdf
if ! asdf plugin add yarn; then
  _echo "error" "Unable to add yarn plugin to asdf"
  exit 1
fi

_echo "info" "Installing tool verions listed in $asdf_tool_versions"

# install versions listed under .tool-versions
if [[ ! -f "$asdf_tool_versions" ]]; then
  _echo "error" "Unable to locate asdf tool versions at $asdf_tool_versions"
  exit 1
else
  if ! asdf install; then
    _echo "error" "Unable to install asdf tool versions"
    exit 1
  fi
fi

# if homebrew isn't found, attempt to source it
if ! command -v brew >/dev/null 2>&1; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# if homebrew still isn't found, install it
if ! command -v brew >/dev/null 2>&1; then
  _echo "info" "Installing homebrew"

  # install homebrew
  # https://github.com/homebrew/install#install-homebrew-on-macos-or-linux
  if ! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
    _echo "error" "Unable to install homebrew"
    exit 1
  fi

  # source homebrew for purposes of installation
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# skip brewfile install in ci
if [[ -z "$CI" ]]; then
  _echo "info" "Installing packages using Brewfile"

  # homebrew package installation
  if [[ -f "$HOME/.Brewfile" ]]; then
    if ! brew bundle install --global; then
      _echo "error" "Unable to install packages using Brewfile"
      exit 1
    fi
  fi
fi

# install all required homebrew dependencies
for package in "${homebrew_dependencies[@]}"; do
  _echo "info" "Validating required dependency $package is installed"

  if ! command brew list "$package" >/dev/null 2>&1; then
    if ! command brew install "$package"; then
      _echo "error" "Unable to install homebrew package $package"
      exit 1
    fi

    # skip updating the brewfile in ci
    if [[ -z "$CI" ]]; then
      # update Brewfile to include the dependency
      command brew bundle dump --force --global
    fi
  fi
done

# dynamically generated brew source command (as string) to pass to fish
brew_source="eval \$($(which brew) shellenv)"

# install fisher
# https://github.com/jorgebucaran/fisher#installation
fisher_install="${brew_source} && curl -sL https://git.io/fisher | source"
if ! fish -c "$fisher_install"; then
  _echo "error" "Unable to install fisher"
  exit 1
fi

# install fisher plugins if any are listed in the fish config
if [ -f "$HOME/.config/fish/fish_plugins" ]; then
  fisher_update="${brew_source} && fisher update"

  if ! fish -c "$fisher_update"; then
    _echo "error" "Unable to install fisher plugins"
    exit 1
  fi
fi

# skip github key generation and https => ssh protocol switch in ci
if [[ -z "$CI" ]]; then
  # generate Ed25519 key pair by authenticating with GitHub
  if [ ! -f "$HOME/.ssh/id_ed25519.pub" ]; then
    # if currently authenticated with GitHub, sign out
    if gh auth status >/dev/null 2>&1; then

      _echo "info" "Logging out of gh-cli"

      if ! gh auth logout; then
        _echo "error" "Unable to log out of gh-cli"
        exit 1
      fi
    fi

    _echo "info" "Authenticating with GitHub"

    if ! gh auth login --hostname github.com --git-protocol ssh --web; then
      _echo "error" "Unable to authenticate with GitHub"
      exit 1
    fi
  fi

  _echo "info" "Changing dotfiles repo protocol to SSH"

  # change the bare repo's git protocol from https to ssh
  if ! git --git-dir="$dotfiles_git_dir" --work-tree="$dotfiles_work_tree" remote set-url origin "$dotfiles_ssh"; then
    _echo "error" "Unable to change dotfiles repo protocol to SSH"
    exit 1
  fi
fi

# set the default git editor to neovim
if [[ "$(gh config get editor)" != "nvim" ]]; then
  _echo "info" "Changing default git editor to neovim"

  gh config set editor nvim
fi

# install all required python dependencies
for directory in "${directories[@]}"; do
  if [[ ! -d $directory ]]; then
    _echo "info" "Creating directory $directory"

    mkdir -p "$directory"
  fi
done

if ! grep "$(which fish)" /etc/shells >/dev/null 2>&1; then
  _echo "info" "Adding $(which fish) to /etc/shells"

  # add fish to /etc/shells
  which fish | sudo tee -a /etc/shells
fi

_echo "info" "Changing default shell to fish"

# change default shell to fish
chsh -s "$(which fish)"

_echo "info" "Bootstrap complete. Changes will take effect next time you create a terminal session."
