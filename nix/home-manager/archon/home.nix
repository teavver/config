{
  pkgs,
  lib,
  ...
}:

# pkgmanager: ghostty, vlc, thunar (plugins), opensnitch*, obs-studio, tailscale, docker, sioyek*, heroic*, libfido2
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

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    x11.enable = true;
    size = 16;
  };

  programs.i3status = {
    enable = true;
    general.interval = 2;
    modules = {
      "ipv6".enable = false;
      "battery all".enable = false;
      "ethernet _first_".enable = false;
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
      "cpu_usage" = {
        position = 5;
        settings.format = "%usage";
      };
    };
  };

  services.syncthing.enable = true;

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
      bun
      basedpyright
      typescript-language-server
      marksman
      zls
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
      xcompmgr # transparency
      i3-volume
      playerctl
      mictray
      dunst
      libnotify
      maim
      gnome-themes-extra
      networkmanagerapplet
      tailscale-systray
      gxkb # kb applet
      caffeine-ng # sleep
      pasystray # audio
      # gui
      element-desktop
      virt-manager
      zed-editor-fhs
      obsidian
      transmission_4-qt
      engrampa # archiver
      pavucontrol
      lxappearance
      gimp2
      ulauncher
      # cli
      opencode
      claude-code
      s-tui # stresstest
      # misc
      voxinput # claude
      ydotool # voxinput
      steamtinkerlaunch
      yad # steamtinkerlaunch
      # heroic # 3-17 broken
      inter
      jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
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
    ".ssh/config".source = dotfiles/ssh;
    ".vimrc".source = dotfiles/vimrc;
    ".config/i3/config".source = dotfiles/i3config;
    ".config/ghostty/config".source = dotfiles/ghostty;
    ".config/nvim/init.lua".source = dotfiles/nvim.lua;
    ".obsidian.vimrc".source = dotfiles/obsidian;
  };

  home.activation.obsidianVaultLink = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ln -sf $VERBOSE_ARG \
      ~/.obsidian.vimrc \
      /mnt/sn5000/obsidian/remote/.obsidian.vimrc
  '';

  home.activation.steamPermFix = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # /etc/sudoers.d/10-steam-perm-fix
    # teaver ALL=(root) NOPASSWD: /usr/bin/chown -R teaver\:teaver /mnt/su800/win/steam
    /usr/bin/sudo /usr/bin/chown -R teaver:teaver /mnt/su800/win/steam
  '';

  home.sessionVariables = {
    BROWSER = "zen-twilight"; # ulauncher
    DXVK_FRAME_RATE = "150";
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
        "x-scheme-handler/http" = "zen-twilight.desktop";
        "x-scheme-handler/https" = "zen-twilight.desktop";
        "x-scheme-handler/about" = "zen-twilight.desktop";
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

  gtk = {
    enable = true;

    theme = {
      name = "Adwaita-dark";
      package = pkgs.adwaita-icon-theme;
    };

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    gtk3.extraConfig = {
      gtk-enable-event-sounds = false;
      gtk-enable-input-feedback-sounds = false;
    };
  };

  fonts.fontconfig = {
    enable = true;
    antialiasing = true;
    hinting = "slight";
    subpixelRendering = "none";
  };

  xresources.properties = {
    "Xft.antialias" = 1;
    "Xft.hinting" = 1;
    "Xft.hintstyle" = "hintslight";
    "Xft.rgba" = "none";
    "Xft.lcdfilter" = "lcddefault";
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

  targets.genericLinux.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  programs.home-manager.enable = true;
}
