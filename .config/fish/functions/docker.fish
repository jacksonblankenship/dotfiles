# docker wrapper to add some helpful additions
function docker --wraps docker
  switch $argv[1]
    # destroy everything docker
    case die
      command docker ps -aq | xargs command docker stop
      command docker ps -aq | xargs command docker rm
      command docker network prune -f
      command docker images --filter dangling=true -qa | xargs command docker rmi -f
      command docker volume ls --filter dangling=true -q | xargs command docker volume rm
      command docker images -qa | xargs command docker rmi -f
    # execute docker normally
    case '*'
      command docker $argv
  end
end
