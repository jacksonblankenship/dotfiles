# replace boring cat with fun cat
function cat -w cat
  if type -f ccat &> /dev/null
    ccat $argv
  else
    command cat $argv
  end
end