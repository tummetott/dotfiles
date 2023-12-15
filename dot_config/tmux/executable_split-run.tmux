#!/usr/bin/env bash

win=split-run

# Create or select window
if tmux list-windows | grep -q "$win"; then
    pane_pids=$(tmux list-panes -t "$win" -F '#{pane_pid}' | tr '\n' ' ')
    read -r pid1 pid2 <<< "$pane_pids"
    
    if pgrep -P "$pid1" > /dev/null; then
        tmux send-keys -t "$win.1" C-c
    fi
    if pgrep -P "$pid2" > /dev/null; then
        tmux send-keys -t "$win.2" C-c
    fi
    while pgrep -P "$pid1" > /dev/null || pgrep -P "$pid2" > /dev/null; do
        sleep 0.1
    done
    unset pid1 pid2 pane_pids
else
    tmux new-window -n "$win" -c "$TMUX_PATH1"
    tmux split-window -v -c "$TMUX_PATH2"
fi

tmux send-keys -t "$win.1" "$TMUX_CMD1" Enter
tmux send-keys -t "$win.2" "$TMUX_CMD2" Enter
tmux select-window -t "$win"

unset win
