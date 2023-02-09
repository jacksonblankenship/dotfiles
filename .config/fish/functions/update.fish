# function to update all packages
function update --description "Update all relevant dependencies" -w update
  echo (set_color green) "[ ✅ ] Updating asdf core" (set_color normal)
  if ! command asdf update
    echo (set_color red) "[ ❌ ] Failed to update asdf core" (set_color normal)
    return 1
  end

  echo (set_color green) "[ ✅ ] Updating asdf plugins" (set_color normal)
  if ! command asdf plugin update --all
    echo (set_color red) "[ ❌ ] Failed to update asdf plugins" (set_color normal)
    return 1
  end

  echo (set_color green) "[ ✅ ] Updating homebrew and package definitions"  (set_color normal)
  if ! command brew update
    echo (set_color red) "[ ❌ ] Failed to update homebrew and package definitions" (set_color normal)
    return 1
  end

  echo (set_color green) "[ ✅ ] Updating installed homebrew packages" (set_color normal)
  if ! command brew upgrade
    echo (set_color red) "[ ❌ ] Failed to update installed homebrew packages" (set_color normal)
    return 1
  end

  echo (set_color green) "[ ✅ ] Updating fisher and all fisher plugins" (set_color normal)
  if ! fisher update
    echo (set_color red) "[ ❌ ] Failed to update fisher and all fisher plugins" (set_color normal)
    return 1
  end

  echo (set_color green) "[ ✅ ] Updating neovim plugins" (set_color normal)
  if ! command nvim +PlugUpdate +qa
    echo (set_color red) "[ ❌ ] Failed to update neovim plugins" (set_color normal)
    return 1
  end
end

