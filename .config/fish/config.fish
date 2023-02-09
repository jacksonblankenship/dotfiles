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

# initialize homebrew if not in CI (manually handled in ci)
if test -z "$CI"
    eval "$(/opt/homebrew/bin/brew shellenv)"
end


# configure interactive sessions
if status is-interactive
    # give neofetch some breathing room
    echo -e "\n"

    # show neofetch
    neofetch

    # initialize starship theme (only in interactive sessions)
    starship init fish | source
end

