#!/bin/bash - 
tmux new-window -t emerge -d  'eix-sync ; layman -S ; eix-update; emerge -vtuN --deep --keep-going world; emerge @preserved-rebuild; bash' 2> /dev/null || tmux new-session -s emerge -d 'eix-sync ; layman -S ; eix-update; emerge -vtuN --deep --keep-going world; emerge @preserved-rebuild; bash'
