{ config, pkgs, ... }:

{

  imports = [
    ./programs/tmux.nix
    ./programs/brave.nix
  ];

  home.username = "teaver";
  home.homeDirectory = "/Users/teaver";
  home.enableNixpkgsReleaseCheck = false; # Change on 25.11 release
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    tmux
    htop
    aerospace

    # vscode
    nixfmt-rfc-style
  ];

  home.file = {
  };

  home.sessionVariables = {
  };

  targets.darwin.defaults = {
    "com.lwouis.alt-tab-macos" = import ./defaults/com.lwouis.alt-tab-macos.nix;
    "com.dwarvesv.minimalbar" = import ./defaults/com.dwarvesv.minimalbar.nix;
    "eu.exelban.Stats" = import ./defaults/eu.exelban.Stats.nix;
    # apple
    "com.apple.Accessibility" = import ./defaults/apple/com.apple.Accessibility.nix;
    "com.apple.AppleMultitouchTrackpad" = import ./defaults/apple/com.apple.AppleMultitouchTrackpad.nix;
  };

}
