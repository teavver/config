{ pkgs, lib, ... }:

# pkgmanager: i3lock, thunar (plugins), opensnitch*, obs-studio, tailscale, docker, sioyek*
# paru hotfix: sudo find /var/lib/pacman/local/ -type f -name "desc" -exec sed -i '/^%INSTALLED_DB%$/,+2d' {} \;

let
  systemPackages = import ./base-pkgs.nix { inherit pkgs; };
in
{
  imports = [
    ./modules/zsh.nix
    ./modules/git.nix
    ./modules/tmux.nix
  ];

  home.username = "teaver";
  home.homeDirectory = "/home/teaver";

  home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = "25.11";

  programs.i3status = {
    enable = true;
    general.interval = 2;
    modules = {
      "ipv6".enable = false;
      "battery all".enable = false;
      "ethernet _first_".enable = false;
      "volume master" = {
        position = 10;
        settings = {
          format = "(%volume)";
          format_muted = "(m)";
          device = "pulse";
        };
      };
      "disk /" = {
        position = -10;
        settings.format = "/ %avail";
      };
      "disk /mnt/sn5000" = {
        position = -9;
        settings.format = "sn5000 %avail";
      };
      "disk /mnt/su800" = {
        position = -8;
        settings.format = "su800 %avail";
      };
    };
  };

  # ppkgs
  home.packages =
    systemPackages
    ++ (with pkgs; [
      just
      uv
      ruff
      pyright
      vscode
      nil
      zig
      deno
      nodejs_24
      basedpyright
      # xorg
      xrandr
      xclip
      xsel
      xauth
      xdotool
      xss-lock
      xsetroot
      xsecurelock
      xautolock
      xset
      xclock
      xinput
      xdpyinfo
      xwininfo
      xdg-utils
      xkb-switch-i3
      # i3 
      i3-volume
      playerctl
      mictray
      dunst
      libnotify
      maim
      gnome-themes-extra
      networkmanagerapplet
      gxkb #kb applet
      caffeine-ng # sleep
      pasystray # audio
      # gui
      discord
      element-desktop
      virt-manager
      zed-editor-fhs
      chromium
      ghostty
      obsidian
      transmission_4-qt
      vlc
      engrampa # archiver
      pavucontrol
      lxappearance
      gimp2
      snapper-gui
      ulauncher
      # cli
      opencode
      claude-code
      claude-monitor
      s-tui # stresstest
      # misc
      voxinput
      ydotool
      gnome.gvfs # samba
      bore-cli # tunnel
      jetbrains-mono
      steamtinkerlaunch
      yad # steamtinkerlaunch
      # heroic-unwrapped
    ]);

  home.file = {
    ".xprofile".text = ''
      xset r rate 200 35
    '';
    ".config/sioyek/prefs_user.config".text = ''
      default_dark_mode 1
      check_for_updates_on_startup 0
      case_sensitive_search 0
    '';
    ".config/ulauncher/settings.json".text = builtins.toJSON {
      hotkey-show-app = "<Primary><Alt><Shift>bracketright";
    };
    ".vimrc".source = dotfiles/vimrc;
    ".config/i3/config".source = dotfiles/i3config;
    ".config/ghostty/config".source = dotfiles/ghostty;
    ".config/nvim/init.lua".text = ''vim.cmd("source ~/.vimrc")'';
    ".obsidian.vimrc".source = dotfiles/obsidian;
  };

  home.activation.obsidianVaultLink = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ln -sf $VERBOSE_ARG \
      ~/.obsidian.vimrc \
      /mnt/sn5000/obsidian/remote/.obsidian.vimrc
  '';

  home.activation.steamPermFix = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # /etc/sudoers.d/10-steam-perm-fix
    # teaver ALL=(root) NOPASSWD: /usr/bin/chown -R teaver\:teaver /mnt/su800/win/steam
    /usr/bin/sudo /usr/bin/chown -R teaver:teaver /mnt/su800/win/steam
  '';

  home.sessionVariables = {
    BROWSER="zen-twilight"; # ulauncher
    # DXVK_FRAME_RATE = "144";
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED   = "1";
    __GL_SYNC_TO_VBLANK = "0";
  };

  xdg = {
    terminal-exec = {
      enable = true;
      settings.default = [ "com.mitchellh.ghostty.desktop" ];
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "zen-twilight.desktop";
        "x-scheme-handler/http"   = "zen-twilight.desktop";
        "x-scheme-handler/https"  = "zen-twilight.desktop";
        "x-scheme-handler/about"  = "zen-twilight.desktop";
        "x-scheme-handler/unknown" = "zen-twilight.desktop";
        "application/pdf" = "zen-twilight.desktop";
        "inode/directory" = "thunar.desktop";
        "text/*" = "nvim.desktop";
        "application/json" = "nvim.desktop";
        "audio/*" = "vlc.desktop";
        "video/*" = "vlc.desktop";
      };
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
  };

  targets.genericLinux = {
    enable = true;
    gpu.nvidia = {
      enable = true;
      version = "595.45.04";
      sha256 = "sha256-zUllSSRsuio7dSkcbBTuxF+dN12d6jEPE0WgGvVOj14=";
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  programs.home-manager.enable = true;
}
