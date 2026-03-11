{ config, pkgs, lib, ... }:

let
  systemPackages = import ./config/nix/home-manager/base-pkgs.nix { inherit pkgs; };
in
{
  imports =
    [
      <home-manager/nixos>
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  home-manager.backupFileExtension = "bak";
  home-manager.users.t520 = { pkgs, ... }:
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
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  security.sudo.extraRules = [
    {
      users = [ "t520" ];
      commands = [
        { command = "ALL"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];

  environment.interactiveShellInit = ''
    alias osconf='sudo vim /etc/nixos/configuration.nix'
    alias osw='sudo nixos-rebuild switch'
  '';

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  programs.zsh.enable = true;

  environment.systemPackages = systemPackages ++ (with pkgs; [
    neovim
    python314
    uv
    ruff
    just
    gh
    tmux
  ]);

  # zram
  swapDevices = lib.mkForce [ ];
  zramSwap.enable = true;

  # services
  services.tailscale.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  users.users.t520.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPtILK3rfBotZpjD+VRw4bxdkT+Rt5G6QmINN1LvrJ7N t520@nixos"
  ];

  # disable sleep
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

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
