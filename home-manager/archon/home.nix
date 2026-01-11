{ pkgs, ... }:

# external:
# flatpak: zen
# pkgmanager: obs-studio, docker

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

  # cursor fix
  gtk = {
    enable = true;
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 16;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    x11.enable = true;
    size = 16;
  };

  home.packages =
    systemPackages
    ++ (with pkgs; [
      uv
      ruff
      sioyek
      vscode
      vlc
      obsidian
      python314
      nil
      zig
      thunderbird
      claude-code
      spotify
      discord
      zrok

      i3-volume
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
    ]);
  # ppkgs

  home.file = {
    ".vimrc".source = dotfiles/vimrc;
    ".xprofile".text = ''
      export vblank_mode=0
      export __GL_SYNC_TO_VBLANK=0
      export __GL_MaxFramesAllowed=1
    '';
    ".config/i3/config".source = dotfiles/i3config;
    ".config/ghostty/config".source = dotfiles/ghostty;
    ".config/nvim/init.lua".text = ''vim.cmd("source ~/.vimrc")'';
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  home.sessionVariables = {
    XCURSOR_SIZE = "16";
  };

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
