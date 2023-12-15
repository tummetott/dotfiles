#!/usr/bin/env sh

theme=$(cat "$BASE16_CONFIG_PATH/theme_name")

if [ "$theme" = 'catppuccin-frappe' ]; then
    text='#a5adce'
    text2='#626880'
    surface='#414559'
elif [ "$theme" = 'catppuccin-latte' ]; then
    text='#6c6f85'
    text2='#6c6f85'
    surface='#ccd0da'
elif [ "$theme" = 'gruvbox-material-dark-medium' ]; then
    text='#928374'
    text2='#928374'
    surface='#32302f'
else
    text='colour7'
    text2='colour20'
    surface='colour18'
fi

# Set the color of the highlighted text in copy-mode
tmux setw -g mode-style 'fg=colour0,bg=colour20'

# Sets the color of the current match
tmux setw -g copy-mode-current-match-style 'fg=colour0,bg=colour16'

# Sets the color of all matches except the current match
tmux setw -g copy-mode-match-style 'fg=colour0,bg=colour20'

# Sets the color of tmux messages
tmux setw -g message-style 'fg=colour4,bg=colour0'

tmux set -g pane-border-style fg='colour19',bg='colour0'
tmux set -g pane-active-border-style fg='colour19',bg='colour0'

# Syntax explanation:
#   #I = window number
#   #W = window name
#   #S = session name
#   #{?CONDITION,PRINT_WHEN_TRUE,PRINT_WHEN_FALSE} = replacement conditional
#   #{!=:FIRST,LAST} returns '1' if FIRST != LAST and returns '0' otherwise

# Set default colors for the line
tmux set -g status-style "fg=${text},bg=colour0"

# All window tabs but the current
tmux setw -g window-status-format "#[\
    bg=colour0,fg=${surface}]#[\
    bg=${surface},fg=${text2},bold] #I #[\
    bg=colour0,fg=${surface}]";

# Current window tab
tmux setw -g window-status-current-format "#[\
    bg=colour0,fg=${surface}]#[\
    bg=${surface},fg=colour4,bold] #I #[\
    bg=colour0,fg=${surface}]";

# Right side shows the executed command, the hostname, the time and the session
tmux set -g status-right "#[\
    bg=colour0,fg=colour1]#{?#{!=:#{selection_present},}, im COPY MODE ,}#[\
    bg=colour0,fg=colour6]#{?window_zoomed_flag, 󰍉 ZOOM ENABLED ,}#[\
    bg=colour0,fg=${surface}]#[\
    bg=${surface},fg=${text}]  #W   #h   %H:%M  󰄷 #S #[\
    bg=colour0,fg=${surface}]"
