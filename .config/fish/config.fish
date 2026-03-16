# Set default editor and visual
if command -q nvim
    set --export EDITOR nvim
    set --export VISUAL nvim
else
    __warn_missing_dep editor neovim
    set --export EDITOR vi
    set --export VISUAL vi
end

# Homebrew — two paths because dotfiles are shared cross-platform
if test -x /opt/homebrew/bin/brew # macOS ARM
    eval (/opt/homebrew/bin/brew shellenv)
else if test -x /home/linuxbrew/.linuxbrew/bin/brew # Linux
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
else
    __warn_missing_dep brew homebrew "visit https://brew.sh"
end

# mise — manages language runtimes (node, python, etc.); activate hooks shims/paths into the shell
if type -q mise
    mise activate fish | source
else
    __warn_missing_dep mise mise
end

if status is-interactive
    if command -q starship
        starship init fish | source
    else
        __warn_missing_dep starship starship
    end
end
