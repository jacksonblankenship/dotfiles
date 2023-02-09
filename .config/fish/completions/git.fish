source $__fish_data_dir/completions/git.fish

function __fish_git_is_wip
  command git -c log.showSignature=false log -n 1 2>/dev/null | grep -q -- "--wip--"
end

complete -f -c git -a wip -n "not __fish_git_is_wip" -d 'Put branch into a work-in-progress state'
complete -f -c git -a unwip -n "__fish_git_is_wip" -d 'Revert branch out of a work-in-progress state'