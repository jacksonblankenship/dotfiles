# replace vi with neovim
function vi --wraps nvim
  if command -q nvim
    command nvim $argv
  else
    __warn_missing_dep vi neovim
    command vi $argv
  end
end
