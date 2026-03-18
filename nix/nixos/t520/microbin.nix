{ ... }:

{
  services.microbin = {
    enable = true;
    settings = {
      MICROBIN_BIND = "0.0.0.0";
      MICROBIN_PORT = 4000;
      MICROBIN_DISABLE_TELEMETRY = true;
      MICROBIN_EDITABLE = false;
      MICROBIN_HIGHLIGHTSYNTAX = true;
      MICROBIN_QR = true;
      MICROBIN_PRIVATE = true;
      MICROBIN_ENCRYPTION_CLIENT_SIDE = true;
      MICROBIN_ENCRYPTION_SERVER_SIDE = true;
      MICROBIN_HASH_IDS = true;
      MICROBIN_ETERNAL_PASTA = true;
      MICROBIN_GC_DAYS = 0;
      MICROBIN_ENABLE_BURN_AFTER = true;
      MICROBIN_DEFAULT_EXPIRY = "never";
    };
  };
}
