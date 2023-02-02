# function to update all packages
function update --description "Update all relevant dependencies"
  # update asdf core
  asdf update \
    # update asdf plugins
    && asdf plugin update --all
    # update package definitions and homebrew itself
    && brew update \
    # update all installed packages
    && brew upgrade \
    # update all fisher and all installed plugins
    && fisher update \
    # update all neovim plugins
    && nvim +PlugUpdate +qa
end