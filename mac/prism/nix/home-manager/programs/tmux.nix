{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    historyLimit = 100000;

    plugins = with pkgs; [
      tmuxPlugins.fingers
      tmuxPlugins.better-mouse-mode
    ];

    extraConfig = ''
      unbind C-b
      unbind C-t # fzf
      unbind C-r # fzf
      set -g prefix `
      bind-key ` last-window
      bind-key w kill-window
      bind-key e send-prefix

      # tmux-fingers
      set -g @super-fingers-key f

      # start indexing windows from 1
      set-option -g renumber-windows on

      # lagfix
      set -sg escape-time 0

      set -g base-index 1
      setw -g pane-base-index 1

      set -g status-position bottom
      set -g status-bg colour234
      set -g status-fg colour102
      set -g status-left "[#{session_name}] "
      set -g status-right "#{?window_bigger,[#{window_offset_x}#,#{window_offset_y}] ,} %H:%M %d-%b-%y"
      setw -g window-status-current-format '#[bg=colour238] #I#[fg=colour250]:#[fg=colour255]#W#[fg=colour87,bold]#F '
      setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '

      set -g mouse on
      set -g mode-keys vi
      set -g mode-style "fg=default,bg=default,reverse"
      set-option -s set-clipboard off

      # mouse actions (pbcopy)
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-selection -x # disable copy-on-select
      bind-key -T copy-mode-vi MouseDrag2Pane send-keys -X begin-selection # RMB select => copy
      bind-key -T copy-mode-vi MouseDragEnd2Pane send-keys -X copy-pipe-and-cancel "pbcopy"
      unbind-key -T root MouseDown2Pane # Disable MMB paste in root mode

      # mouse actions (xclip)
      # bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-selection -x # disable copy-on-select
      # bind-key -T copy-mode-vi MouseDrag2Pane send-keys -X begin-selection # RMB select => copy
      # bind-key -T copy-mode-vi MouseDragEnd2Pane send-keys -X copy-pipe-and-cancel "xclip -selection clipboard"
      # unbind-key -T root MouseDown2Pane # Disable MMB paste in root mode
    '';
  };
}
