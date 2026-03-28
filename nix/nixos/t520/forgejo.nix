{ ... }:

{
  services.forgejo = {
    enable = true;
    settings = {
      server = {
        DOMAIN = "t520-nixos";
        ROOT_URL = "http://t520-nixos:3000/";
        HTTP_ADDR = "0.0.0.0";
        HTTP_PORT = 3000;
        DISABLE_SSH = false;
        START_SSH_SERVER = true;
        SSH_PORT = 2222;
      };
      service = {
        DISABLE_REGISTRATION = true;
      };
      repository = {
        ENABLE_PUSH_CREATE_USER = true;
      };
    };
  };
}
