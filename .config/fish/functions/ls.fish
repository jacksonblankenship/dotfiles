# replace boring ls with fun ls
function ls --wraps ls
  if type -f lsd &> /dev/null
    command lsd $argv
  else
    command ls $argv
  end
end