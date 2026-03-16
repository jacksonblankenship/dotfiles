# Bare-repo git wrapper for managing dotfiles (~/.dotfiles/ is the git dir, $HOME is the work-tree)
function dot
    set -l gitcmd /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME
    set -l current ($gitcmd config --local --get status.showUntrackedFiles 2>/dev/null)

    # Without this, git status would list every untracked file in $HOME
    if test "$current" != no
        $gitcmd config --local status.showUntrackedFiles no
    end

    # Block 'add .' / 'add -A' / 'add --all' to prevent staging the entire home directory
    if set -q argv[1]; and begin [ $argv[1] = 'add' ]; or [ $argv[1] = 'stage' ]; end
        if set -q argv[2]; and begin [ $argv[2] = '.' ]; or [ $argv[2] = '-A' ]; or [ $argv[2] = '--all' ]; end
            printf "'dot %s %s' is not allowed. Please add dotfiles individually or use '-u' instead.\n" $argv[1] $argv[2]
            return 1
        end
    end

    $gitcmd $argv
end
