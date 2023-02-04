#!/usr/bin/env bash

# github information
# if this is modified, ~/.config/fish/functions/dotfiles.fish should be updated
github_username="jacksonblankenship"
dotfiles_repo_name="dot"

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
)

# # pip3 dependencies required for this shell's core configuration
# python_dependencies=(
#   "pynvim"
# )

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

# verify the user knows wtf they're about to do
echo
read -p $'\e[1;33m[ ⚠️ ]\e[0m This is a destructive process that will replace your existing dotfiles. Are you sure you want to continue? (Y/n) ' -n 1 -r
echo

# abort if the user doesn't consent
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  _echo "info" "Aborting..."
  exit 1
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

  _echo "warn" "Successfully installed asdf, but it may not be properly configured with fish. Read more under the \"Fish & Git\" documentation. https://asdf-vm.com/guide/getting-started.html#_2-download-asdf"

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
if ! asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git; then
  _echo "error" "Unable to add nodejs plugin to adsf"
  exit 1
fi

# _echo "info" "Adding python plugin to asdf"
#
# # add pythong plugin to asdf
# if ! asdf plugin add python https://github.com/asdf-community/asdf-python; then
#   _echo "error" "Unable to add python plugin to adsf"
#   exit 1
# fi

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

# uninstall homebrew if it currently exists
# https://github.com/homebrew/install#uninstall-homebrew
if command -v brew >/dev/null 2>&1; then

  _echo "info" "Uninstalling pre-existing homebrew formula"

  # shellcheck disable=SC2046
  if ! brew remove --force $(brew list --formula); then
    _echo "error" "Unable to uninstall homebrew formula"
    exit 1
  fi

  _echo "info" "Uninstalling pre-existing homebrew casks"

  # shellcheck disable=SC2046
  if ! brew remove --cask --force $(brew list --cask); then
    _echo "error" "Unable to uninstall homebrew casks"
    exit 1
  fi

  _echo "info" "Uninstalling existing homebrew installation"

  exit 1

  if ! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"; then
    _echo "error" "Unable to uninstall homebrew"
    exit 1
  fi
fi

_echo "info" "Installing homebrew"

# re-install homebrew
# https://github.com/homebrew/install#install-homebrew-on-macos-or-linux
if ! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
  _echo "error" "Unable to install homebrew"
  exit 1
fi

# temporarially source homebrew for purposes of installation
eval "$(/opt/homebrew/bin/brew shellenv)"

_echo "info" "Installing packages using Brewfile"

# homebrew package installation
if [[ -f "$HOME/Brewfile" ]]; then
  if ! brew bundle install; then
    _echo "error" "Unable to install packages using Brewfile"
    exit 1
  fi
fi

# install vim-plug
# https://github.com/junegunn/vim-plug#installation

# TODO: Add this back in or remove it after trying to install neovim + plugins

# if [ ! -f "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" ]; then
#   _echo "info" "Installing vim-plug"
#
#   if ! sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim \
#     --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'; then
#     _echo "error" "Unable to install vim-plug"
#     exit 1
#   fi
# fi

# install all required homebrew dependencies
for package in "${homebrew_dependencies[@]}"; do
  _echo "info" "Validating required dependency $package is installed"

  if ! command brew list "$package" >/dev/null 2>&1; then
    if ! command brew install "$package"; then
      _echo "error" "Unable to install homebrew package $package"
      exit 1
    fi

    # update Brewfile to include the dependency
    command brew bundle dump
  fi
done

# # install all required python dependencies
# for package in "${python_dependencies[@]}"; do
#   _echo "info" "Validating $package is installed"
#
#   if ! command pip3 install "$package"; then
#     _echo "error" "Unable to install pip3 package $package"
#     exit 1
#   fi
# done

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

# set the default git editor to neovim
if [[ "$(gh config get editor)" != "nvim" ]]; then
  _echo "info" "Changing default git editor to neovim"

  gh config set editor nvim
fi

# install all required python dependencies
for directory in "${directories[@]}"; do
  _echo "info" "Creating directory $directory"

  if ! mkdir -p "$directory" >/dev/null 2>&1; then
    _echo "error" "Unable to create directory $directory"
    exit 1
  fi
done

# add fish to /etc/shells
# echo /usr/local/bin/fish | sudo tee -a /etc/shells

# change default shell to fish
# chsh -s /usr/local/bin/fish
