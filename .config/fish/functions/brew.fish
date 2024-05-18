# homebrew wrapper that keeps the ~/.Brewfile up-to-date
function brew --wraps brew
  if command brew $argv
    and command brew bundle dump --force --global
      and sed -i '' '/^vscode\|^cask "font-\|^tap "homebrew\/cask-fonts"/d' ~/.Brewfile
  end
end
