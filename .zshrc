source $(brew --prefix)/share/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Plugin variables
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true

# Antigen bundles
antigen bundle git
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle lukechilds/zsh-nvm

# Load the theme.
antigen theme robbyrussell

# Complete antigen configuration
antigen apply

# Source aliases
source $HOME/.aliases

# Print header
fortune -s | cowsay -f tux
