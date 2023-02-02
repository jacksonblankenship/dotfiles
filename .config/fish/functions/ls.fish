# replace boring ls with fun ls
function ls -w ls
  if type -f exa &> /dev/null
    exa --group-directories-first --icons --git $argv
  else
    command ls $argv
  end
end