# git wrapper to extend core git functionality
function git --wraps git
  switch $argv[1]
    # put a repo into a "work in progress" state
    case wip
      command git add -A
      command git rm $(command git ls-files --deleted) 2> /dev/null
      command git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"
    # revert a repo out of a "work in progress" state
    case unwip
      command git log -n 1 | command grep -q -c "\-\-wip\-\-" && command git reset HEAD~1
    case standup
      # loop over all dates with committs since the most recent Sunday
      command git log --reflog --format="%cd" --date="short" --since="last month" --author=(command git config --global user.name) \
        # sort and remove duplicate dates
        | sort -u \
        # loop over the dates
        | while read DATE;
          # print out a pretty date header
          echo -e "\n\x1B[34m[ $DATE ]\x1B[0m"
          # get all of the committs for the particular day
          command git log --reflog --format="%s" --author=(command git config --global user.name) --since="$DATE 00:00:00" --until="$DATE 23:59:59" \
            # remove any gwip commits
            | sed 's/\--wip-- \[skip ci\]//g' \
            # remove any blank lines left behind by sed
            | awk 'NF' \
            # sort and remove duplicate commit messages
            | sort -u \
            # make the committs a bulletted list
            | sed 's/^/ • /'
        end
    # execute git normally
    case '*'
      command git $argv
  end
end