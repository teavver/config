{ config, pkgs, ... }:

{
  imports = [
    ./programs/tmux.nix
  ];

  home.username = "teaver";
  home.homeDirectory = "/Users/teaver";
  home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    tmux
    htop
    nixfmt-rfc-style
  ];

  home.file = { };

  home.sessionVariables = { };
}
