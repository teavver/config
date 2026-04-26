{ ... }:
{
  # tailscale funnel --bg --https=10000 http://localhost:4000
  services.microbin = {
    enable = true;
    settings = {
      MICROBIN_BIND = "127.0.0.1";
      MICROBIN_PORT = 4000;
      MICROBIN_HASH_IDS = true;
      MICROBIN_PRIVATE = true;
      MICROBIN_ENABLE_READONLY = false; # buggy
      MICROBIN_ENCRYPTION_SERVER_SIDE = true;
      MICROBIN_ENCRYPTION_CLIENT_SIDE = true;
      MICROBIN_HIGHLIGHTSYNTAX = true;
      MICROBIN_ENABLE_BURN_AFTER = true;
      MICROBIN_ETERNAL_PASTA = true;
      MICROBIN_DEFkAULT_EXPIRY = "never";
      MICROBIN_DISABLE_TELEMETRY = true;
      MICROBIN_DISABLE_UPDATE_CHECKING = true;
      MICROBIN_GC_DAYS = 0;
      MICROBIN_HIDE_FOOTER = true;
      MICROBIN_MAX_FILE_SIZE_UNENCRYPTED_MB = 256;
      MICROBIN_MAX_FILE_SIZE_ENCRYPTED_MB = 256;
    };
  };
}
