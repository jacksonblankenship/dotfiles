# Homebrew wrapper that keeps the ~/.Brewfile up-to-date
function brew --wraps brew
  if command brew $argv
    and command brew bundle dump --force --global
      and grep -vE '^vscode|^cask "font-|^tap "homebrew/cask-fonts"' ~/.Brewfile > ~/.Brewfile.tmp
      and mv ~/.Brewfile.tmp ~/.Brewfile
  end
end
