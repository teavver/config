{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "focmhibpdifbdjacabpgnifhdalgfogg"; } # AutoFill Forms
      { id = "ojfebgpkimhlhcblbalbfjblapadhbol"; } # EditThisCookie (V3)
      { id = "edibdbjcniadpccecjdfdjjppcpchdlm"; } # I still don't care about cookies
      { id = "bcjindcccaagfpapjjmafapmmgkkhgoa"; } # JSON Formatter
      { id = "dhdgffkkebhmkfjojejmpbldmpobfkfo"; } # Tampermonkey
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
      # { id = ""; } #
    ];
    commandLineArgs = [
    ];
  };
}
