# set the fish greeting to null
set --universal fish_greeting

# set userprofile environment variable for tdn
set --export USERPROFILE "$HOME/tmp/userprofile"

# set default editor to nvim
set --export EDITOR nvim

# set default visual to nvim
set --export VISUAL nvim

# initialize homebrew
eval (/opt/homebrew/bin/brew shellenv)

# initialize asdf
source "$HOME/.asdf/asdf.fish"

# add local bin to fish path
fish_add_path "$HOME/.local/bin/"

# install fisher if not found
if status is-interactive && ! functions --query fisher
    # install fisher
    curl -sL https://git.io/fisher | source

    # install all plugins listed under .config/fish/fish_plugins
    fisher update
end

# pnpm
set -gx PNPM_HOME "/Users/jacksonblankenship/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end

# pnpm end
# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true

# configure interactive sessions
if status is-interactive
    # give neofetch some breathing room
    printf "\n"

    # show neofetch
    neofetch

    # initialize starship theme (only in interactive sessions)
    starship init fish | source
end

# sst
fish_add_path /Users/jacksonblankenship/.sst/bin
