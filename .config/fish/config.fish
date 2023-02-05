# set the fish greeting to null
set --universal fish_greeting

# set userprofile environment variable for tdn
set --export USERPROFILE "$HOME/tmp/userprofile"

# set default editor to nvim
set --export EDITOR nvim

# set default visual to nvim
set --export VISUAL nvim

# initialize asdf
source ~/.asdf/asdf.fish

# initialize homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# configure interactive sessions
if status is-interactive
    # initialize starship theme (only in interactive sessions)
    starship init fish | source
end

