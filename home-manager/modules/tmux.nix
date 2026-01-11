{ ... }:

{
  programs.tmux = {
    enable = true;
    prefix = "`";
    baseIndex = 1;
    mouse = true;
    keyMode = "vi";
    escapeTime = 0;
    historyLimit = 10000;
    extraConfig = ''
      set-option -g pane-base-index 1
      set-option -g renumber-windows on
      set-option -g focus-events on
      set-option -g default-terminal "screen-256color"
      set -g status-position bottom
      set -g status-bg colour234
      set -g status-fg colour66
      set -g status-left "[#{session_name}] "
      set -g status-right ""
      set -g bell-action none
      set -g mode-style "fg=colour250,bg=colour236"
      unbind C-b
      unbind C-t
      unbind C-r
      bind-key ` last-window
      bind-key w kill-window
      bind-key e send-prefix
      bind-key l swap-window -t -1\; select-window -t -1
      bind-key r swap-window -t +1\; select-window -t +1
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-selection -x
      bind-key -T copy-mode-vi MouseDrag2Pane send-keys -X begin-selection
      bind-key -T copy-mode-vi MouseDragEnd2Pane send-keys -X copy-pipe-and-cancel "xclip -selection clipboard"
      unbind-key -T root MouseDown2Pane
      bind-key -T copy-mode-vi C-c send-keys -X copy-pipe-and-cancel "xclip -selection clipboard"
    '';
  };
}
