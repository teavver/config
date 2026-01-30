{ pkgs, ... }:

# external:
# pkgmanager: flatpak, obs-studio, docker, pasystray

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

  # home.file.".icons/default/index.theme".force = true;
  # home.pointerCursor = {
  #   name = "Vanilla-DMZ-AA";
  #   package = pkgs.vanilla-dmz;
  #   # gtk.enable = true;
  #   # x11.enable = true;
  #   size = 16;
  # };

  home.packages =
    systemPackages
    ++ (with pkgs; [
      ruff
      sioyek
      pyright
      vscode
      vlc
      obsidian
      nil
      zig
      spotify
      discord
      zrok
      s-tui

      snapper
      rofi
      i3-volume
      playerctl
      tail-tray
      mictray
      dunst
      xclip
      xsel
      xss-lock
      xsetroot
      xsecurelock
      xautolock
      xorg.xinput
      libnotify
      xdg-utils
      seahorse
      gimp2
      maim
      lm_sensors
      thunar
      tumbler
      thunar-volman
      thunar-archive-plugin
      thunar-media-tags-plugin
      kdePackages.ark
      pavucontrol
      networkmanagerapplet
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
    "obsidian/.obsidian.vimrc".source = dotfiles/obsidian;
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

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
