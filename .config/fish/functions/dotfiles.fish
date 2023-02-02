function dotfiles -w dotfiles
  git --git-dir=$HOME/.dot/ --work-tree=$HOME $argv
end