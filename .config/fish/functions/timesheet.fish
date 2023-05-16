# get client events that occurred today
function timesheet
  if type -f icalBuddy &> /dev/null
    for i in (seq 0 13)
      set day (date -v "-$i"d +%Y-%m-%d)

      # print the date
      printf "\n$day\n\n" 

      # get calendar events
      icalBuddy -ea -nc -b " • " -iep title -ic Calendar eventsFrom:$day to:$day \
        # remove OOO's
        | grep -v "OOO" \
        # remove cancelled events
        | grep -v "Canceled:"

      # get git events from the current repository
      command git log --reflog --format="%s" --author=(command git config --global user.name) --since="$day 00:00:00" --until="$day 23:59:59" \
        # remove any gwip commits
        | sed 's/\--wip-- \[skip ci\]//g' \
        # remove any blank lines left behind by sed
        | awk 'NF' \
        # sort and remove duplicate commit messagesgi
        | sort -u \
        # make the committs a bulletted list
        | sed 's/^/ • /'
    end
  end
end