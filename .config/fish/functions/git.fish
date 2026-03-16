# git wrapper to extend core git functionality
function git --wraps git
  switch $argv[1]
    # Quick stash-like save: stage everything and commit with a skip-ci message
    case wip
      command git add -A
      command git rm $(command git ls-files --deleted) 2> /dev/null
      command git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"
    # Undo the wip commit if it was the most recent one, restoring changes to the working tree
    case unwip
      command git log -n 1 | command grep -q -c "\-\-wip\-\-" && command git reset HEAD~1
    # execute git normally
    case '*'
      command git $argv
  end
end
