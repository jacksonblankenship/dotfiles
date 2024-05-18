# Function to update all packages
function update --description "Update dependencies for asdf, homebrew, fisher, and neovim"

  # Define color codes
  set -l green (set_color green)
  set -l red (set_color red)
  set -l cyan (set_color cyan)
  set -l yellow (set_color yellow)
  set -l normal (set_color normal)

  # Helper function to print status messages
  function print_status
    set_color $argv[2]
    echo "[ $argv[1] ] $argv[3]"
    set_color normal
  end

  # Check if a command exists
  function command_exists
    command -v $argv[1] > /dev/null
  end

  # Check if a Fish function exists
  function function_exists
    functions -q $argv[1]
  end

  # Update asdf core
  if command_exists asdf
    print_status "ℹ️" cyan "Updating asdf core"
    asdf update && print_status "✅" green "Successfully updated asdf core" || print_status "❌" red "Failed to update asdf core"
  else
    print_status "⚠️" yellow "asdf not found, skipping asdf core update"
  end

  # Update asdf plugins
  if command_exists asdf
    print_status "ℹ️" cyan "Updating asdf plugins"
    asdf plugin update --all && print_status "✅" green "Successfully updated asdf plugins" || print_status "❌" red "Failed to update asdf plugins"
  else
    print_status "⚠️" yellow "asdf not found, skipping asdf plugins update"
  end

  # Update homebrew
  if command_exists brew
    print_status "ℹ️" cyan "Updating homebrew and package definitions"
    brew update && print_status "✅" green "Successfully updated homebrew and package definitions" || print_status "❌" red "Failed to update homebrew and package definitions"

    print_status "ℹ️" cyan "Updating installed homebrew packages"
    brew upgrade && print_status "✅" green "Successfully updated installed homebrew packages" || print_status "❌" red "Failed to update installed homebrew packages"

    print_status "ℹ️" cyan "Upgrading homebrew casks"
    brew upgrade --cask --greedy && print_status "✅" green "Successfully upgraded homebrew casks" || print_status "❌" red "Failed to upgrade homebrew casks"
  else
    print_status "⚠️" yellow "Homebrew not found, skipping homebrew updates"
  end

  # Update fisher and plugins
  if function_exists fisher
    print_status "ℹ️" cyan "Updating fisher and all fisher plugins"
    fisher update && print_status "✅" green "Successfully updated fisher and all fisher plugins" || print_status "❌" red "Failed to update fisher and all fisher plugins"
  else
    print_status "⚠️" yellow "Fisher not found, skipping fisher updates"
  end
end
