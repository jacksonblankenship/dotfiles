# Install

Before continuing, be sure you've installed macOS command line tools

```sh
xcode-select --install
```

This command will override existing dotfiles and replace them with the dotfiles in this repository.

```sh
# TODO: Fix this link when repo is migrated from "dot" to "dotfiles"
# run the bootstrap script
/bin/bash -c "$(curl -s https://raw.githubusercontent.com/jacksonblankenship/dot/main/.config/dotfiles/bootstrap.sh)" && printf "\033c" && exec fish
```