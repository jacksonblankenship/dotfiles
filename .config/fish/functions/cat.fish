# replace boring cat with fun cat
function cat --wraps cat
  if command -q bat
    command bat --plain $argv
  else
    __warn_missing_dep cat bat
    command cat $argv
  end
end
