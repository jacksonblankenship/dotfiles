# set the fish greeting to null
set --universal fish_greeting

# set userprofile environment variable for tdn
set --export USERPROFILE "$HOME/tmp/userprofile"

# set default editor to nvim
set --export EDITOR nvim

# set default visual to nvim
set --export VISUAL nvim

# initialize asdf
source "$HOME/.asdf/asdf.fish"

# initialize homebrew
eval (/opt/homebrew/bin/brew shellenv)

# install fisher if not found
if status is-interactive && ! functions --query fisher
    # install fisher
    curl -sL https://git.io/fisher | source

    # install all plugins listed under .config/fish/fish_plugins
    fisher update
end

# configure interactive sessions
if status is-interactive
    # give neofetch some breathing room
    printf "\n"

    # show neofetch
    neofetch

    # initialize starship theme (only in interactive sessions)
    starship init fish | source
end

