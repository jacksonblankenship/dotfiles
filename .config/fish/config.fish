# Set the fish greeting to null
set --universal fish_greeting

# Set default editor to nvim
set --export EDITOR nvim

# Set default visual to nvim
set --export VISUAL nvim

# Initialize Homebrew
eval (/opt/homebrew/bin/brew shellenv)

# Initialize asdf
source "$HOME/.asdf/asdf.fish"

# Add local bin to fish path
fish_add_path "$HOME/.local/bin/"

# Install fisher if not found
if status is-interactive
    if not type -q fisher
        # Install fisher
        curl -sL https://git.io/fisher | source

        # Install all plugins listed under .config/fish/fish_plugins
        fisher update
    end
end

# pnpm
set -gx PNPM_HOME "/Users/jacksonblankenship/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end

# Configure interactive sessions
if status is-interactive
    # Give neofetch some breathing room
    printf "\n"

    # Show neofetch
    neofetch

    # Initialize starship theme (only in interactive sessions)
    starship init fish | source
end