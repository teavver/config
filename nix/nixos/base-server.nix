{ user }:

# base config for nixos servers
{
  # misc
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.interactiveShellInit = ''
    alias osconf='sudo -E vim /etc/nixos/configuration.nix'
    alias osw='sudo nixos-rebuild switch'
  '';

  # programs
  programs.zsh.enable = true;
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    extraConfig = ''
      set -g status-position top
    '';
  };

  # ssh + tailscale
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };
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
  users.users.${user}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPtILK3rfBotZpjD+VRw4bxdkT+Rt5G6QmINN1LvrJ7N teaver@archon"
  ];

  # disable sleep
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # pls bro
  security.sudo.extraRules = [
    {
      users = [ user ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
