# === Required Configurations ===

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

# === Custom Configurations ===

# VS Code CLI
code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}

# Catch-all update command for various package managers and utilities
alias update="brew upgrade && brew update && omz update && npm update -g && vim +PluginUpdate +qall"

# Dotfile tracking
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

# Print a quote with a penguin
fortune -s | cowsay -f tux | lolcat --spread 1.0

# Quick start the flylance-app development environment 
alias fly="cd ~/projects/flylance-app && ttab && open -a \"Google Chrome\" http://localhost:3000/ https://github.com/flylance-io/flylance-app/issues && code . && npm run dev"
