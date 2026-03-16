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
# 1. Clone via HTTPS (SSH isn't available until dotfiles are checked out)
git clone --bare https://github.com/jacksonblankenship/dotfiles.git $HOME/.dotfiles

# 2. Checkout the files into $HOME
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout

# 3. Hide untracked files (everything else in $HOME)
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no

# 4. Switch remote to SSH (now that .ssh/config is in place)
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME remote set-url origin git@github.com:jacksonblankenship/dotfiles.git
```

If step 2 fails due to existing files, back them up first:

```bash
mkdir -p $HOME/.dotfiles-backup
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout 2>&1 | grep "^\t" | awk '{print $1}' | xargs -I{} mv {} $HOME/.dotfiles-backup/{}
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout
```

## Usage

The `dot` fish function wraps git with the bare repo flags. Use it like git:

```fish
dot status
dot add ~/.config/fish/config.fish
dot commit -m "Update fish config"
dot push
```

> **Note:** `dot add .` and `dot add -A` are blocked to prevent staging your entire home directory.