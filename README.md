# dotfiles

Bare-repo dotfiles managed with a `dot` wrapper around git. The git directory lives at `~/.dotfiles` and the work tree is `$HOME`.

## Prerequisites

- [Homebrew](https://brew.sh)
- [Fish shell](https://fishshell.com) (`brew install fish`)
- [Starship](https://starship.rs) (`brew install starship`)
- [mise](https://mise.jdx.dev) (`brew install mise`)
- [1Password](https://1password.com) (for SSH agent)

## Fresh Machine Setup

```bash
bash <(curl -s https://raw.githubusercontent.com/jacksonblankenship/dotfiles/main/.config/dotfiles/setup.sh)
```

This will:
1. Clone the repo as a bare repository to `~/.dotfiles`
2. Checkout dotfiles into `$HOME` (conflicting files are backed up to `~/.dotfiles-backup`)
3. Switch the remote from HTTPS to SSH (the 1Password SSH agent config isn't available until after checkout)

## Usage

The `dot` fish function wraps git with the bare repo flags. Use it like git:

```fish
dot status
dot add ~/.config/fish/config.fish
dot commit -m "Update fish config"
dot push
```

> **Note:** `dot add .` and `dot add -A` are blocked to prevent staging your entire home directory.