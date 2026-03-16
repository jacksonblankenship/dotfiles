function brew
    if is_macos
        if not id -u homebrew &>/dev/null
            echo (set_color yellow)"brew:"(set_color normal)" Homebrew should be installed under its own user. Create a 'homebrew' user and install Homebrew on that user only." >&2
            return 1
        end
        # Run as the dedicated 'homebrew' user for isolation on macOS
        sudo -Hu homebrew /opt/homebrew/bin/brew $argv
    else
        # No dedicated user on Linux — pass through directly
        command brew $argv
    end
end
