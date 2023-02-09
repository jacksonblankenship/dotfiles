# replace boring ls with fun ls
function ls --wraps ls
  if type -f exa &> /dev/null
    command exa --group-directories-first --icons --git $argv
  else
    command ls $argv
  end
end