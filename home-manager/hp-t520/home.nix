{ pkgs, ... }:

let
  systemPackages = import ./base-pkgs.nix { inherit pkgs; };
in
{
  imports = [
    ./modules/zsh.nix
    ./modules/git.nix
    ./modules/tmux.nix
  ];

  home.username = "teavkr";
  home.homeDirectory = "/home/teaver";
  home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = "25.11";

  home.packages =
    systemPackages
    ++ (with pkgs; [
      lm_sensors
    ]);

  home.file = {
    ".vimrc".source = dotfiles/vimrc;
    ".config/nvim/init.lua".text = ''vim.cmd("source ~/.vimrc")'';
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  home.sessionVariables = { };

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
