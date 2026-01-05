{ config, pkgs, ... }:

# external:
# flatpak: zen
# pacman: obs-studio

{
  home.username = "teaver";
  home.homeDirectory = "/home/teaver";
  home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    curl
    wget
    tree
    htop
    zoxide
    alacritty
    oh-my-zsh
    fzf
    thunderbird
    uv
    bat
    jq
    sioyek
    ruff
    ripgrep
    vscode
    vlc
    obsidian
    python314
    zig
    tailscale
    claude-code

    i3-volume
    i3lock
    playerctl
    dunst
    xclip
    xsel
    xss-lock
    xsecurelock
    xautolock
    xorg.xinput
    libnotify
    xdg-utils
    gimp2
    maim
    lm_sensors
    thunar
    tumbler
    pavucontrol
    themechanger
    fluent-gtk-theme
    networkmanagerapplet
    nerd-fonts.adwaita-mono
    nerd-fonts.jetbrains-mono
  ];

  home.file = {
    ".vimrc".source = dotfiles/vimrc;
    ".xprofile".source = dotfiles/xprofile;
    ".config/i3/config".source = dotfiles/i3config;
    ".config/ghostty/config".source = dotfiles/ghostty;
    ".config/nvim/init.lua".text = ''vim.cmd("source ~/.vimrc")'';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "docker"
      ];
    };

    shellAliases = {
      python = "python3";
      sw = "home-manager switch -b backup";
    };

    history = {
      size = 10000;
      save = 10000;
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
    };

    initContent = ''
      if command -v tmux &> /dev/null; then
        if [ -z "$TMUX" ]; then
          cd $HOME
          tmux new-session -A -s 1
        fi
      fi

      cd $HOME

      x-paste() {
        local clip
        clip=$(xsel --clipboard --output 2>/dev/null || echo -n "")
        LBUFFER="$LBUFFER$clip"
      }
      zle -N x-paste
      bindkey '^V' x-paste

      bindkey '^H' backward-kill-word
      bindkey '^[[A' history-beginning-search-backward
      bindkey '^K' history-beginning-search-backward
      bindkey '^[[B' history-beginning-search-forward
      bindkey '^J' history-beginning-search-forward

      if command -v zoxide &> /dev/null; then
        eval "$(zoxide init zsh)"
        alias cd='z'
      fi

      code() {
        if [ $# -eq 0 ]; then
          command code .
        else
          command code "$1"
        fi
      }

      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' list-colors ""

      unsetopt BEEP
      PROMPT='%F{cyan}%3~%f $(git_prompt_info)%(?:%F{green}➜ :%F{red}➜ )%f'
    '';
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "teavver";
        email = "jerzyx11@gmail.com";
      };
      diff.renames = "copies";
      push.default = "current";
      http = {
        postBuffer = 524288000;
        lowSpeedLimit = 0;
        lowSpeedTime = 10000;
      };
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

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

  home.sessionVariables = { };

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
