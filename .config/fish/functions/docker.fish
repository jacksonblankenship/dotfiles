# docker wrapper to add some helpful additions
function docker -w docker
  switch $argv[1]
    # destroy everything docker
    case die
      command docker ps -aq | xargs command docker stop
      command docker ps -aq | xargs command docker rm
      command docker network prune -f
      command docker images --filter dangling=true -qa | xargs command docker rmi -f
      command docker volume ls --filter dangling=true -q | xargs command docker volume rm
      command docker images -qa | xargs command docker rmi -f
    # start the tdn server
    case tdn
      command az acr login -n fiatechcontainerrepository \
        && command docker build -t fiatech/transparency-ui-service -f src/app/TransparencyUIService/Dockerfile-TransparencyUIServiceGRPC . \
        && command docker build -t fiatech/matching-ui-service -f src/app/MatchingGrpc/Dockerfile-MatchingUIServiceGRPC . \
        && command docker-compose --env-file ./src/app/TransparencyUIService/.env.development -f compose/transparencyui/docker-compose.transparency.yaml up
    # execute docker normally
    case '*'
      command docker $argv[1]
  end
end