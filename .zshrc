# Path oh-my-zsh installation.
export ZSH="/Users/jacksonblankenship/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Node version manager configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# === Aliases ===

# Catch-all update command for various package managers and utilities
alias update="brew upgrade && brew update && omz update && npm update -g && vim +PluginUpdate +qall"

# Dotfile tracking
alias dotfile='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# === Just for Fun ===

# Print a quote with a penguin
fortune | cowsay -f tux
