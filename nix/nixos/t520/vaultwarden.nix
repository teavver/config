{ ... }:

{
  services.vaultwarden = {
    enable = true;
    backupDir = "/var/local/vaultwarden/backup";
    environmentFile = "/var/lib/vaultwarden/vaultwarden.env";
    config = {
      DOMAIN = "https://t520-nixos.long-pleco.ts.net:8443";
      SIGNUPS_ALLOWED = false;
      SHOW_PASSWORD_HINT = false;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
    };
  };

  services.tailscale.permitCertUid = "caddy";

  services.caddy = {
    enable = true;
    virtualHosts."t520-nixos.long-pleco.ts.net:8443" = {
      extraConfig = ''
        tls {
          get_certificate tailscale
        }
        reverse_proxy 127.0.0.1:8222
      '';
    };
  };

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 8443 ];
}
