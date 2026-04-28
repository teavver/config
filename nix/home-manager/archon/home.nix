{
  pkgs,
  lib,
  config,
  flake-pkgs,
  ...
}:

# pkgmanager: tailscale, docker, libfido2, ydotool
# sudo pacman -Rns $(pacman -Qdtq)
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

  home.stateVersion = "26.05";

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    x11.enable = true;
    size = 24;
  };

  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        blocks = [
          {
            block = "music";
            player = "vlc";
            format = " {$prev $play $next |mus} ";
            icons_overrides = {
              music_prev = "&lt;";
              music_play = "&gt;";
              music_pause = "#";
              music_next = "&gt;";
            };
          }
          {
            block = "tea_timer";
            format = " T {$time.duration(hms:true) |}";
            increment = 30;
            done_cmd = "notify-send 'Timer Finished'";
          }
          {
            block = "pomodoro";
            notify_cmd = "notify-send '{msg}'";
            blocking_cmd = true;
            pomodoro_format = "{ $completed_pomodoros.eng(w:1).|} $status_icon $time_remaining.duration(hms:true) ";
            break_format = " $status_icon $time_remaining.duration(hms:true) ";
            icons_overrides = {
              pomodoro = "P";
              pomodoro_started = ">";
              pomodoro_paused = "p";
              pomodoro_break = "b";
            };
          }
          {
            block = "disk_space";
            path = "/";
            format = " / $percentage ";
          }
          {
            block = "disk_space";
            path = "/mnt/sn5000";
            format = " sn5000 $percentage ";
          }
          {
            block = "disk_space";
            path = "/mnt/su800";
            format = " su800 $percentage ";
          }
          {
            block = "memory";
            format = " $mem_used.eng(w:4,prefix:Gi,hide_unit:true,hide_prefix:true)/$mem_avail.eng(w:4,prefix:Gi,hide_unit:true,hide_prefix:true) ";
          }
          {
            block = "cpu";
            format = " c$utilization ";
          }
          {
            block = "nvidia_gpu";
            format = " g$utilization ";
          }
          {
            block = "load";
            format = " l$1m ";
          }
          {
            block = "packages";
            package_manager = [
              "pacman"
              "aur"
            ];
            interval = 600;
            format = " p$pacman a$aur ";
            format_singular = " p$pacman a$aur ";
            format_up_to_date = " up ";
            aur_command = "paru -Qua";
          }
          {
            block = "sound";
            format = " {$volume |M} ";
          }
          {
            block = "time";
            format = " $timestamp.datetime(f:'%a %d ~ %R') ";
            interval = 60;
          }
        ];
      };
    };
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        timeout = 10;
        idle_threshold = 120;
      };
      urgency_low = {
        background = "#484e50";
        foreground = "#ffffff";
        timeout = 5;
      };
      home_manager_quiet = {
        summary = "Home Manager";
        urgency = "low";
        timeout = 5;
      };
      pomodoro_break = {
        appname = "notify-send";
        summary = "*Break*";
        timeout = 5;
      };
      play_sound = {
        # 32768 = 50% vol
        script = "${pkgs.writeShellScript "dunst-sound" ''
          ${pkgs.pulseaudio}/bin/paplay --volume=32768 ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/audio-volume-change.oga
        ''}";
      };
    };
  };

  services.syncthing = {
    enable = true;
    settings = {
      gui.useTLS = true;
      options.urAccepted = -1;
    };
  };

  # ppkgs
  home.packages =
    systemPackages
    ++ (with pkgs; [
      vsce
      # dev
      zed-editor
      ghostty
      nap
      just
      just-lsp
      uv
      ruff
      pyright
      basedpyright
      vscode
      nil # nix
      zig
      deno
      nodejs_24
      bun
      typescript-language-server
      marksman
      zls # zig
      ghc # haskell
      fourmolu # hs formatter
      cabal-install # hs
      vscode-langservers-extracted
      lua-language-server
      stylua
      yaml-language-server
      taplo # toml
      bash-language-server
      dockerfile-language-server
      clang-tools
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
      feh # wall
      i3-volume
      autotiling-rs
      playerctl
      mictray
      dunst
      libnotify
      maim
      gnome-themes-extra
      networkmanagerapplet
      gxkb # kb applet
      caffeine-ng # sleep
      pasystray # audio
      # gui
      vlc
      thunar
      thunar-volman
      thunar-archive-plugin
      thunar-media-tags-plugin
      element-desktop
      virt-manager
      (obsidian.override { commandLineArgs = "--force-device-scale-factor=1.3"; })
      obsidian-export
      transmission_4-qt
      engrampa # archiver
      gimp2
      # cli
      s-tui # stresstest
      # misc
      # discord
      systemd-manager-tui
      redshift # nightlight
      libqalculate # rofi
      xmousepasteblock # mmb disable
      smug # tmux
      tmux-sessionizer
      voxinput # VTT llm
      # flake pkgs
      flake-pkgs.llm-agents.opencode
      flake-pkgs.llm-agents.claude-code
      flake-pkgs.llm-agents.codex
      flake-pkgs.llm-agents.gemini-cli
      flake-pkgs.llm-agents.pi
      # pinned flake pkgs
      # ...
      # fonts
      dejavu_fonts
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      nerd-fonts.meslo-lg
      # nvenc obs
      (symlinkJoin {
        name = "obs-studio-wrapped";
        paths = [
          (writeShellScriptBin "obs" ''
            export LD_LIBRARY_PATH=/run/opengl-driver/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
            exec ${obs-studio}/bin/obs "$@"
          '')
          obs-studio
        ];
      })
    ]);

  home.file = {
    ".ssh/config".source = dotfiles/ssh;
    ".vimrc".source = dotfiles/vimrc;
    ".obsidian.vimrc".source = dotfiles/obsidian;
    ".syncthing/sn5000-nosync".text = "/nosync";
  };

  xdg.configFile = {
    "tms/config.toml".text = ''
      search_paths = ["${config.home.homeDirectory}/code"]
    '';
    "i3/config".source = dotfiles/i3config;
    "ghostty/config" = {
      source = dotfiles/ghostty;
      force = true;
    };
    "zsh/.p10k.zsh".source = dotfiles/p10k.zsh;
  };

  home.activation.SN5000symlinks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ln -sf $VERBOSE_ARG \
      ~/.obsidian.vimrc \
      /mnt/sn5000/obsidian/remote/.obsidian.vimrc

    $DRY_RUN_CMD ln -sf $VERBOSE_ARG \
      ~/.syncthing/sn5000-nosync \
      /mnt/sn5000/.stignore
  '';

  home.activation.steamPermFix = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # /etc/sudoers.d/10-steam-perm-fix
    # teaver ALL=(root) NOPASSWD: /usr/bin/chown -R teaver\:teaver /mnt/su800/win/steam
    /usr/bin/sudo /usr/bin/chown -R teaver:teaver /mnt/su800/win/steam
  '';

  home.activation.screenshots = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "$HOME/Pictures/Screenshots"
  '';

  home.sessionVariables = {
    BROWSER = "zen-twilight";
    TERMINAL = "ghostty";

    DXVK_FRAME_RATE = "141";
    WINEUSERSANDBOX = "1";
    WINE_NO_WM_DECORATION = "1";

    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
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
        "application/zip" = "engrampa.desktop";
        "application/gzip" = "engrampa.desktop";
        "application/x-tar" = "engrampa.desktop";
        "application/x-compressed-tar" = "engrampa.desktop";
        "application/x-7z-compressed" = "engrampa.desktop";
      };
    };
    userDirs = {
      enable = true;
      createDirectories = true;
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
      gtk-enable-animations = false;
      gtk-enable-event-sounds = false;
      gtk-enable-input-feedback-sounds = false;
    };
    gtk4.extraConfig = {
      gtk-enable-animations = false;
    };
    gtk4.theme = null;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      enable-animations = false;
    };
  };

  fonts.fontconfig = {
    enable = true;
    antialiasing = true;
    hinting = "slight";
    subpixelRendering = "none";
    defaultFonts = {
      sansSerif = [
        "Noto Sans"
        "Noto Sans CJK JP"
      ];
      serif = [
        "Noto Serif"
        "Noto Serif CJK JP"
      ];
      monospace = [ "MesloLGS Nerd Font" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  programs.zen-browser = {
    enable = true;
    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      DisableSystemAddonUpdate = true;
      PasswordManagerEnabled = false;
      OfferToSaveLoginsDefault = false;
      OfferToSaveLogins = false;
    };
  };

  programs.chromium = {
    enable = true;
    extensions = [
      { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # uBlock Origin Lite
    ];
  };

  programs.rofi = {
    enable = true;
    theme = "solarized";
    extraConfig = {
      terminal = "ghostty";
      show-icons = true;
      matching = "fuzzy";
      sort = true;
      sorting-method = "fzf";
      modi = "combi,drun,window,ssh,calc:qalc";
      combi-modi = "calc:qalc,drun,window,ssh";
      kb-remove-to-eol = "";
      kb-secondary-copy = "";
      kb-mode-complete = "";
      kb-clear-line = "Control+c,Control+l";
      kb-cancel = "Escape";
      kb-select-1 = "Control+1";
      kb-select-2 = "Control+2";
      kb-select-3 = "Control+3";
      kb-select-4 = "Control+4";
      kb-select-5 = "Control+5";
    };
  };

  programs.sioyek = {
    enable = true;
    config = {
      "default_dark_mode" = "1";
      "check_for_updates_on_startup" = "0";
      "case_sensitive_search" = "0";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    initLua = builtins.readFile ./dotfiles/nvim.lua;
  };

  targets.genericLinux.enable = true;
  # nvidia-smi | grep "Driver Version"
  # nix store prefetch-file https://download.nvidia.com/XFree86/Linux-x86_64/<VER>/NVIDIA-Linux-x86_64-<VER>.run
  targets.genericLinux.gpu.nvidia = {
    enable = true;
    version = "595.58.03";
    sha256 = "sha256-jA1Plnt5MsSrVxQnKu6BAzkrCnAskq+lVRdtNiBYKfk=";
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  programs.home-manager.enable = true;
}
