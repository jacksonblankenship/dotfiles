# replace boring ls with fun ls
function ssh --wraps ssh
  kitty +kitten ssh $argv
end