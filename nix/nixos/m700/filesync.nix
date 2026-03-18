{ pkgs, ... }:

{
  fileSystems."/data" = {
    device = "/dev/disk/by-label/lexar";
    fsType = "ext4";
  };

  # folder sync
  services.syncthing = {
    enable = true;
    user = "m700";
    dataDir = "/data";
    guiAddress = "0.0.0.0:8384";
  };

  # sync webui
  systemd.services.filebrowser = {
    description = "Filebrowser";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.filebrowser}/bin/filebrowser -r /data -a 0.0.0.0 -p 8080 -d /data/.filebrowser.db";
      User = "m700";
    };
  };

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 8080 ];
}
