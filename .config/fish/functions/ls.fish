# replace boring ls with fun ls
function ls --wraps ls
  if command -q lsd
    command lsd $argv
  else
    __warn_missing_dep ls lsd
    command ls $argv
  end
end
