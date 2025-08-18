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

}
