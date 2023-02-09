function dotfiles -w dotfiles
  if [ $argv[1] = 'add' ]; or [ $argv[1] = 'stage' ]
    if [ $argv[2] = '.' ]; or [ $argv[2] = '-A' ]; or [ $argv[2] = '--all' ]
      printf "'dot %s %s' is not allowed. Please add dotfiles individually or use '-u' instead.\n" $argv[1] $argv[2]
      return 1
    end
  end

  git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $argv
end