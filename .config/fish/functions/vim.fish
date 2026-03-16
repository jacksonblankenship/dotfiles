# replace vim with neovim
function vim --wraps nvim
  if command -q nvim
    command nvim $argv
  else
    __warn_missing_dep vim neovim
    command vim $argv
  end
end
