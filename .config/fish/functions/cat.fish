# replace boring cat with fun cat
function cat --wraps cat
  if type -f ccat &> /dev/null
    command ccat $argv
  else
    command cat $argv
  end
end