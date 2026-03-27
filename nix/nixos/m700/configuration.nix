# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

let
  systemPackages = import ./config/nix/home-manager/base-pkgs.nix { inherit pkgs; };
in
{
  imports = [
    (import ./config/nix/nixos/base-server.nix { user = "m700"; })
    <home-manager/nixos>
    ./filesync.nix
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  home-manager.backupFileExtension = "bak";
  home-manager.users.m700 =
    { pkgs, ... }:
    let
      hm = ./config/nix/home-manager;
    in
    {
      imports = [
        "${hm}/modules/git.nix"
        "${hm}/modules/zsh.nix"
      ];
      home.file = {
        ".vimrc".source = "${hm}/dotfiles/vimrc";
        ".config/nvim/init.lua".text = ''vim.cmd("source ~/.vimrc")'';
      };
      home.stateVersion = "25.11";
    };

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "nixos"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.m700 = {
    isNormalUser = true;
    description = "m700";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = [ ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    systemPackages
    ++ (with pkgs; [
      neovim
      btop

      busybox
      btrfs-progs
      btrbk
    ]);

  # services
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
