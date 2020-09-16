# uncomment to profile .zshrc performance (also uncomment command at very bottom)
# zmodload zsh/zprof

# path oh-my-zsh installation.
export ZSH="/Users/jacksonblankenship/.oh-my-zsh"

# theme
ZSH_THEME="robbyrussell"

# zsh-nvm configuration
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true

# plugins
plugins=(zsh-nvm git)

# source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# vs code cli
code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}

# catch-all update command for various package managers and utilities
alias update="brew upgrade && brew update && omz update && nvm upgrade && npm update -g && vim +PluginUpdate +qall"

# dotfile tracking
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

# print a quote with a penguin
fortune -s | cowsay -f tux

# uncomment to profile .zshrc performance (also uncomment command at very top)
# zprof
