function __warn_missing_dep
  set -l caller $argv[1]
  set -l package $argv[2]
  set -l install_cmd "brew install $package"
  if set -q argv[3]
    set install_cmd $argv[3]
  end

  # Dynamic global flag (e.g. __docker_dep_warned) so each dep only warns once per shell session
  set -l var_name __"$caller"_dep_warned
  if not set -q $var_name
    set -g $var_name 1
    echo (set_color yellow)"$caller:"(set_color normal)" $package is not installed. Install it with "(set_color cyan)"$install_cmd"(set_color normal) >&2
  end
end
