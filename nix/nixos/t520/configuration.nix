{
  pkgs,
  lib,
  ...
}:

let
  systemPackages = import ./config/nix/home-manager/base-pkgs.nix { inherit pkgs; };
in
{
  imports = [
    (import ./config/nix/nixos/base-server.nix { user = "t520"; })
    <home-manager/nixos>
    ./gitea.nix
    ./privatebin.nix
    ./vaultwarden.nix
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "systemd.swap=0" ];

  home-manager.backupFileExtension = "bak";
  home-manager.users.t520 =
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
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users.t520 = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "t520";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = [ ];
  };

  environment.systemPackages =
    systemPackages
    ++ (with pkgs; [
      btop
      neovim

      python314
      uv
      ruff
      just

      toybox
      openssl
      vaultwarden
    ]);

  # zram
  swapDevices = lib.mkForce [ ];
  zramSwap.enable = true;

  # services
  # uptime
  services.uptime-kuma = {
    enable = true;
    settings = {
      HOST = "0.0.0.0";
      PORT = "3001";
    };
  };

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
