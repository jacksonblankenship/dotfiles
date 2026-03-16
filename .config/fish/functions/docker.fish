# docker wrapper to add some helpful additions
function docker --wraps docker
  if not command -q docker
    __warn_missing_dep docker docker
    return 1
  end
  switch $argv[1]
    # Nuclear cleanup: stop/remove all containers, prune networks, remove all images/volumes
    case die
      # Verify the Docker daemon (Colima) is running before attempting cleanup
      if not command docker info &>/dev/null
        echo (set_color yellow)"docker:"(set_color normal)" Docker is not running. Start Colima first: "(set_color cyan)"colima start"(set_color normal) >&2
        return 1
      end
      set -l containers (command docker ps -aq)
      if test (count $containers) -gt 0
        command docker stop $containers
        command docker rm $containers
      end
      command docker network prune -f
      set -l dangling_images (command docker images --filter dangling=true -qa)
      if test (count $dangling_images) -gt 0
        command docker rmi -f $dangling_images
      end
      set -l dangling_volumes (command docker volume ls --filter dangling=true -q)
      if test (count $dangling_volumes) -gt 0
        command docker volume rm $dangling_volumes
      end
      set -l all_images (command docker images -qa)
      if test (count $all_images) -gt 0
        command docker rmi -f $all_images
      end
    # execute docker normally
    case '*'
      command docker $argv
  end
end
