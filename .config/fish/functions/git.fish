# git wrapper to extend core git functionality
function git -w git
  switch $argv[1]
    # put a repo into a "work in progress" state
    case wip
      command git add -A
      command git rm $(command git ls-files --deleted) 2> /dev/null
      command git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"
    # revert a repo out of a "work in progress" state
    case unwip
      command git log -n 1 | command grep -q -c "\-\-wip\-\-" && command git reset HEAD~1
    # execute git normally
    case '*'
      command git $argv
  end
end