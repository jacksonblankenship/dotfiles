# homebrew wrapper that keeps the brewfile up-to-date
function brew --wraps brew
  if command brew $argv
    command brew bundle dump --force --global && sed -i '' '/^vscode/d' ~/.Brewfile
  end
end
