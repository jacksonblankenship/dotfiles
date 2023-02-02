# homebrew wrapper that keeps the brewfile up-to-date
function brew -w brew
  if command brew $argv
    command brew bundle dump --force --file=$HOME/.config/homebrew/Brewfile
  end
end
