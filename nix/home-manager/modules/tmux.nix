{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    prefix = "`";
    baseIndex = 1;
    mouse = true;
    keyMode = "vi";
    escapeTime = 0;
    historyLimit = 10000;
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = fzf-tmux-url;
        extraConfig = ''
          set -g @fzf-url-bind 't'
        '';
      }
    ];
    extraConfig = ''
      set-option -g pane-base-index 1
      set-option -g renumber-windows on
      set-option -g focus-events on
      set-option -g default-terminal "screen-256color"
      set -g status-position top
      set -g status-left "[#{session_name}] "
      set -g status-right ""
      set -g bell-action any
      set -g pane-border-lines heavy
      set -g status-fg colour12
      set -g window-status-current-style "bold"
      set -g status-style bg=default
      set -g mode-style "fg=colour250,bg=colour236"
      set -g allow-passthrough on
      # splits
      bind -n C-M-h split-window -hb
      bind -n C-M-l split-window -h
      bind -n C-M-k split-window -vb
      bind -n C-M-j split-window -v
      bind -n M-h select-pane -L
      bind -n M-l select-pane -R
      bind -n M-k select-pane -U
      bind -n M-j select-pane -D
      unbind C-b
      unbind C-t
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
