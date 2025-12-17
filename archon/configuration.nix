# flatpak:
# flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# flatpak install flathub app.zen_browser.zen

# useful
# https://gitlab.com/nobodyinperson/nixconfig/-/blob/main/modules/fhs.nix?ref_type=heads

{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.blacklistedKernelModules = [ "pcspkr" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "archon";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  services.logind.settings = {
    Login = {
      HandlePowerKey = "suspend"; # hybrid-sleep | suspend-then-hibernate
      HandlePowerKeyLongPress = "poweroff";
    };
  };

  systemd.sleep.extraConfig = ''
    # hibernate after 10m+ sleep
    HibernateDelaySec=10m
  '';

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    trusted-users = [
      "root"
      "teaver"
    ];

    substituters = [
      "https://cache.nixos-cuda.org"
    ];
    trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };

  services.openssh.enable = true;
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*"; # flatpak req
  };

  services.libinput.enable = true;
  services.libinput.mouse.accelProfile = "flat";
  services.libinput.mouse.accelSpeed = "0";

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];

    xkb = {
      layout = "us";
      variant = "";
    };

    displayManager.lightdm.enable = true;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        lxappearance
      ];
    };
  };

  services.displayManager = {
    defaultSession = "none+i3"; # autologin
    autoLogin.enable = true;
    autoLogin.user = "teaver";
  };

  # gpu
  hardware.graphics = {
    enable = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  programs.fish.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  security.sudo.wheelNeedsPassword = false;
  users.users.teaver = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };

  home-manager.backupFileExtension = "bak";
  home-manager.useGlobalPkgs = true;
  home-manager.users.teaver =
    { pkgs, ... }:
    {
      home.stateVersion = "25.11";
      home.file = {
        ".vimrc".source = dotfiles/vimrc;
        ".config/nvim/init.lua".source = dotfiles/nvimrc;
        ".config/i3/config".source = dotfiles/i3config;
        ".config/kitty/kitty.conf".source = dotfiles/kitty;
      };

      programs.fish = {
        enable = true;

        shellInit = ''
          set -U fish_greeting ""
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
        '';

        shellAbbrs = {
          cd = "z";
        };

        shellAliases = {
          sudoe = "sudo -E -s";
          python = "python3";
          conf = "sudo -E nvim /etc/nixos/configuration.nix";
          sw = "sudo nixos-rebuild switch";
        };

        functions = {
          code = "test (count $argv) -eq 0; and command code .; or command code $argv[1]";
          zed = "test (count $argv) -eq 0; and command zed .; or command zed $argv[1]";
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
        '';
      };

    };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;

  # $ nix search pkg
  environment.systemPackages = with pkgs; [
    cudaPackages.cuda_cudart
    cudaPackages.libcublas
    cudaPackages.nvcomp
    cudaPackages.cutlass
    cudaPackages.cuda_cccl
    cudaPackages.cuda_nvcc
    cudaPackages.cuda_nvrtc
    cudaPackages.cudnn

    git
    curl
    wget
    firefox
    chromium
    vim
    killall
    tree
    neovim
    discord
    kitty
    uv
    fd
    jq
    bat
    sioyek
    ruff
    tmux
    htop
    zoxide
    fzf
    ripgrep
    vscode
    vlc
    obsidian
    python314
    zig
    obs-studio
    tailscale
    bolt-launcher
    porsmo
    steam
    steam-unwrapped

    libnotify
    protonup-qt
    mangohud
    i3-volume
    xautolock
    xclip
    xss-lock
    xsecurelock
    pulseaudio
    gimp2
    lm_sensors
    maim
    zlib
    xfce.thunar
    pavucontrol
    unclutter
    volumeicon
    networkmanagerapplet
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "25.11";

}
