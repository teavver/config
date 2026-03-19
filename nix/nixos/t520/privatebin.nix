{ ... }:

{
  services.privatebin = {
    enable = true;
    enableNginx = true;
    settings = {
      main = {
        discussion = false;
        fileupload = true;
        burnafterreadingselected = true;
        httpwarning = false;
      };
      expire.default = "never";
      traffic.limit = 0;
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts."localhost" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 4000;
        }
      ];
    };
  };
}
