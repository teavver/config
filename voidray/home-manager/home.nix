# nix:
# curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate

# home-manager:
# nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
# nix-channel --update

# zen:
# flatpak install flathub app.zen_browser.zen
# sudo ln -s /var/lib/flatpak/exports/bin/app.zen_browser.zen /usr/bin/zen

# external:
# zen , jenkins,
# lua-language-server (https://luals.github.io/#install)

# external (dnf):
# docker: https://docs.docker.com/engine/install/fedora/#install-docker-engine

{ config, pkgs, ... }:

{
  home.username = "teaver";
  home.homeDirectory = "/home/teaver";
  home.stateVersion = "25.05";

  nixpkgs.config = {
    allowUnfree = true;
  };

  home.packages = [
    pkgs.font-manager
    pkgs.firefox
    pkgs.chromium
    pkgs.obsidian
    pkgs.sioyek
    pkgs.discord
    pkgs.vlc
    pkgs.pavucontrol
    pkgs.vscode
    pkgs.flatpak
    pkgs.playwright

    pkgs.xev
    pkgs.fuse3
    pkgs.lxappearance
    pkgs.xclip
    pkgs.xorg.xrandr
    pkgs.xorg.xinput
    pkgs.xorg.xsetroot
    pkgs.lm_sensors
    pkgs.maim
    pkgs.networkmanager
    pkgs.xfce.thunar
    pkgs.python313Packages.py3status
    pkgs.networkmanagerapplet
    pkgs.playerctl

    pkgs.gh
    pkgs.git
    pkgs.htop
    pkgs.curl
    pkgs.wget
    pkgs.fd
    pkgs.jq
    pkgs.vim
    pkgs.fzf
    pkgs.zoxide
    pkgs.bat
    pkgs.just
    pkgs.uv
    pkgs.lazygit
    pkgs.nodejs-slim_24
    pkgs.pre-commit
    pkgs.act
    pkgs.rustup
    pkgs.lua
    pkgs.luajitPackages.luarocks

    # lsp stuff
    pkgs.nil
    pkgs.pyright
    pkgs.ruff
    pkgs.marksman
    pkgs.yaml-language-server
    pkgs.vtsls # ts
    pkgs.taplo # toml

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.file = {
    ".vimrc".source = dotfiles/vimrc;
    ".config/i3/config".source = dotfiles/i3config;
    ".config/i3status/config".source = dotfiles/i3status;
    ".config/kitty/kitty.conf".source = dotfiles/kitty.conf;
    ".config/nvim/init.lua".source = dotfiles/nvim.lua;
  };

  programs.fish = {
    enable = true;

    shellInit = ''
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      end
    '';

    interactiveShellInit = ''
      cd $HOME

      if type -q tmux
          if not set -q TMUX
              tmux new-session -A -s 1
          end
      end

      # Keybindings
      bind \cH backward-kill-word
      bind \ck up-or-search
      bind \cj down-or-search

      # Initialize zoxide
      zoxide init fish | source

      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    '';

    shellAbbrs = {
      cd = "z";
    };

    shellAliases = {
      python = "python3";
      home = "nvim $HOME/.config/home-manager/home.nix";
      nv = "nvim $HOME/.config/home-manager/dotfiles/nvim.lua";
      sw = "home-manager switch -b backup";
    };

    functions = {
      code = "test (count $argv) -eq 0; and command code .; or command code $argv[1]";
      zed = "test (count $argv) -eq 0; and command zed .; or command zed $argv[1]";
      rmq = "command docker run -it --rm --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:4-management";
    };
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
    plugins = with pkgs.tmuxPlugins; [ resurrect continuum ];
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
      bind -n C-WheelUpPane run-shell "/bin/sh -c 'kitty @ --to=unix:$(ls -1t /tmp/kitty-main-* | head -n1) set-font-size -- +2'"
      bind -n C-WheelDownPane run-shell "/bin/sh -c 'kitty @ --to=unix:$(ls -1t /tmp/kitty-main-* | head -n1) set-font-size -- -2'"
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
      # start continuum on boot
      set -g @continuum-boot 'on'
    '';
  };

  programs.home-manager.enable = true;
}

