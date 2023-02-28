complete -c spt -n "__fish_use_subcommand" -s t -l tick-rate -d 'Set the tick rate (milliseconds): the lower the number the higher the FPS.'
complete -c spt -n "__fish_use_subcommand" -s c -l config -d 'Specify configuration file path.'
complete -c spt -n "__fish_use_subcommand" -l completions -d 'Generates completions for your preferred shell' -r -f -a "bash zsh fish power-shell elvish"
complete -c spt -n "__fish_use_subcommand" -s h -l help -d 'Prints help information'
complete -c spt -n "__fish_use_subcommand" -s V -l version -d 'Prints version information'
complete -c spt -n "__fish_use_subcommand" -f -a "playback" -d 'Interacts with the playback of a device'
complete -c spt -n "__fish_use_subcommand" -f -a "play" -d 'Plays a uri or another spotify item by name'
complete -c spt -n "__fish_use_subcommand" -f -a "list" -d 'Lists devices, liked songs and playlists'
complete -c spt -n "__fish_use_subcommand" -f -a "search" -d 'Searches for tracks, albums and more'
complete -c spt -n "__fish_use_subcommand" -f -a "help" -d 'Prints this message or the help of the given subcommand(s)'
complete -c spt -n "__fish_seen_subcommand_from playback" -s d -l device -d 'Specifies the spotify device to use'
complete -c spt -n "__fish_seen_subcommand_from playback" -s f -l format -d 'Specifies the output format'
complete -c spt -n "__fish_seen_subcommand_from playback" -l transfer -d 'Transfers the playback to new DEVICE'
complete -c spt -n "__fish_seen_subcommand_from playback" -l seek -d 'Jumps SECONDS forwards (+) or backwards (-)'
complete -c spt -n "__fish_seen_subcommand_from playback" -s v -l volume -d 'Sets the volume of a device to VOLUME (1 - 100)'
complete -c spt -n "__fish_seen_subcommand_from playback" -s t -l toggle -d 'Pauses/resumes the playback of a device'
complete -c spt -n "__fish_seen_subcommand_from playback" -s s -l status -d 'Prints out the current status of a device (default)'
complete -c spt -n "__fish_seen_subcommand_from playback" -l share-track -d 'Returns the url to the current track'
complete -c spt -n "__fish_seen_subcommand_from playback" -l share-album -d 'Returns the url to the album of the current track'
complete -c spt -n "__fish_seen_subcommand_from playback" -l like -d 'Likes the current song if possible'
complete -c spt -n "__fish_seen_subcommand_from playback" -l dislike -d 'Dislikes the current song if possible'
complete -c spt -n "__fish_seen_subcommand_from playback" -l shuffle -d 'Toggles shuffle mode'
complete -c spt -n "__fish_seen_subcommand_from playback" -l repeat -d 'Switches between repeat modes'
complete -c spt -n "__fish_seen_subcommand_from playback" -s n -l next -d 'Jumps to the next song'
complete -c spt -n "__fish_seen_subcommand_from playback" -s p -l previous -d 'Jumps to the previous song'
complete -c spt -n "__fish_seen_subcommand_from playback" -s h -l help -d 'Prints help information'
complete -c spt -n "__fish_seen_subcommand_from playback" -s V -l version -d 'Prints version information'
complete -c spt -n "__fish_seen_subcommand_from play" -s d -l device -d 'Specifies the spotify device to use'
complete -c spt -n "__fish_seen_subcommand_from play" -s f -l format -d 'Specifies the output format'
complete -c spt -n "__fish_seen_subcommand_from play" -s u -l uri -d 'Plays the URI'
complete -c spt -n "__fish_seen_subcommand_from play" -s n -l name -d 'Plays the first match with NAME from the specified category'
complete -c spt -n "__fish_seen_subcommand_from play" -s q -l queue -d 'Adds track to queue instead of playing it directly'
complete -c spt -n "__fish_seen_subcommand_from play" -s r -l random -d 'Plays a random track (only works with playlists)'
complete -c spt -n "__fish_seen_subcommand_from play" -s b -l album -d 'Looks for an album'
complete -c spt -n "__fish_seen_subcommand_from play" -s a -l artist -d 'Looks for an artist'
complete -c spt -n "__fish_seen_subcommand_from play" -s t -l track -d 'Looks for a track'
complete -c spt -n "__fish_seen_subcommand_from play" -s w -l show -d 'Looks for a show'
complete -c spt -n "__fish_seen_subcommand_from play" -s p -l playlist -d 'Looks for a playlist'
complete -c spt -n "__fish_seen_subcommand_from play" -s h -l help -d 'Prints help information'
complete -c spt -n "__fish_seen_subcommand_from play" -s V -l version -d 'Prints version information'
complete -c spt -n "__fish_seen_subcommand_from list" -s f -l format -d 'Specifies the output format'
complete -c spt -n "__fish_seen_subcommand_from list" -l limit -d 'Specifies the maximum number of results (1 - 50)'
complete -c spt -n "__fish_seen_subcommand_from list" -s d -l devices -d 'Lists devices'
complete -c spt -n "__fish_seen_subcommand_from list" -s p -l playlists -d 'Lists playlists'
complete -c spt -n "__fish_seen_subcommand_from list" -l liked -d 'Lists liked songs'
complete -c spt -n "__fish_seen_subcommand_from list" -s h -l help -d 'Prints help information'
complete -c spt -n "__fish_seen_subcommand_from list" -s V -l version -d 'Prints version information'
complete -c spt -n "__fish_seen_subcommand_from search" -s f -l format -d 'Specifies the output format'
complete -c spt -n "__fish_seen_subcommand_from search" -l limit -d 'Specifies the maximum number of results (1 - 50)'
complete -c spt -n "__fish_seen_subcommand_from search" -s b -l albums -d 'Looks for albums'
complete -c spt -n "__fish_seen_subcommand_from search" -s a -l artists -d 'Looks for artists'
complete -c spt -n "__fish_seen_subcommand_from search" -s p -l playlists -d 'Looks for playlists'
complete -c spt -n "__fish_seen_subcommand_from search" -s t -l tracks -d 'Looks for tracks'
complete -c spt -n "__fish_seen_subcommand_from search" -s w -l shows -d 'Looks for shows'
complete -c spt -n "__fish_seen_subcommand_from search" -s h -l help -d 'Prints help information'
complete -c spt -n "__fish_seen_subcommand_from search" -s V -l version -d 'Prints version information'
complete -c spt -n "__fish_seen_subcommand_from help" -s h -l help -d 'Prints help information'
complete -c spt -n "__fish_seen_subcommand_from help" -s V -l version -d 'Prints version information'