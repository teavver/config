# nix:
# curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate

# home-manager:
# nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
# nix-channel --update

# zen:
# flatpak install flathub app.zen_browser.zen
# sudo ln -s /var/lib/flatpak/exports/bin/app.zen_browser.zen /usr/bin/zen

# external:
# zen , jenkins ,

{ config, pkgs, ... }:

{
  home.username = "teaver";
  home.homeDirectory = "/home/teaver";
  home.stateVersion = "25.05";

  nixpkgs.config = {
    allowUnfree = true;
  };

  home.packages = [
    pkgs.firefox
    # pkgs.chromium
    pkgs.obsidian
    pkgs.sioyek
    pkgs.vlc
    pkgs.pavucontrol
    pkgs.vscode
    pkgs.flatpak

    pkgs.fuse3
    pkgs.lxappearance
    pkgs.xclip
    pkgs.xorg.xinput
    pkgs.xorg.xsetroot
    pkgs.lm_sensors
    pkgs.maim
    pkgs.networkmanager
    pkgs.xfce.thunar
    pkgs.python313Packages.py3status
    pkgs.networkmanagerapplet

    pkgs.gh
    pkgs.git
    pkgs.htop
    pkgs.curl
    pkgs.wget
    pkgs.jq
    pkgs.tmux
    pkgs.vim
    pkgs.neovim
    pkgs.fish
    pkgs.fzf
    pkgs.zoxide
    pkgs.just
    pkgs.uv
    pkgs.ruff
    pkgs.nodejs-slim_24
    pkgs.docker
    pkgs.docker-compose

    pkgs.nixfmt-rfc-style
    pkgs.nil

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
    ".tmux.conf".source = dotfiles/tmux.conf;
    # ".gitconfig".source = dotfiles/gitconfig;
    ".config/i3/config".source = dotfiles/i3config;
    ".config/i3status/config".source = dotfiles/i3status;
    ".config/kitty/kitty.conf".source = dotfiles/kitty.conf;
    ".config/nvim/init.vim".source = dotfiles/nvim/init.vim;
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
      vim = "nvim";
      home = "nvim $HOME/.config/home-manager/home.nix";
    };

    functions = {
      code = "test (count $argv) -eq 0; and command code .; or command code $argv[1]";
      rmq = "command docker run -it --rm --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:4-management";
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
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

  programs.home-manager.enable = true;
}

