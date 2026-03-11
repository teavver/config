{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "teavver";
        email = "jerzyx11@gmail.com";
      };
      diff.renames = "copies";
      push.default = "current";
      http = {
        postBuffer = 524288000;
        lowSpeedLimit = 0;
        lowSpeedTime = 10000;
      };
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
  };
}
