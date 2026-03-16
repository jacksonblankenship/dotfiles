function update
    if not type -q brew
        __warn_missing_dep update brew
        return 1
    end

    echo "Updating Homebrew..."
    brew update

    echo "Upgrading packages..."
    brew upgrade

    if is_macos
        echo "Upgrading casks..."
        brew upgrade --cask
    end

    echo "Cleaning up..."
    brew cleanup

    echo "Running brew doctor..."
    brew doctor

    echo "Done."
end
