{ config, pkgs, ... }:

{
  home.username = "teaver";
  home.homeDirectory = "/Users/teaver";
  home.enableNixpkgsReleaseCheck = false; # Rm after 25.11 release?
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    htop
    nixfmt-rfc-style
  ];

  home.file = {
  };

  home.sessionVariables = {
  };

}
