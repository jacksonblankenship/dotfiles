# Install

Before continuing, be sure you've installed macOS command line tools

```sh
xcode-select --install
```

This command will override existing dotfiles and replace them with the dotfiles in this repository.

```sh
/bin/bash -c "$(curl -s -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/jacksonblankenship/dotfiles/main/.config/dotfiles/bootstrap.sh)" && exit
```
