{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util"; # mac app aliases | https://github.com/hraban/mac-app-util
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew"; # homebrew | https://github.com/zhaofengli/nix-homebrew
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs@{
    self,
    nix-darwin,
    nixpkgs,
    mac-app-util,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    ...
  }:
  let
    configuration = { pkgs, ... }: {

      nix.enable = false;

      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [
        pkgs.vim
        pkgs.tmux
        pkgs.curl
        pkgs.wget
        pkgs.git
        pkgs.gh
        pkgs.aerospace
        pkgs.stats
        pkgs.brave
        pkgs.spotify
        pkgs.kitty
        pkgs.vscode
        pkgs.obsidian
        pkgs.ollama
      ];

      # Homebrew apps
      homebrew = {
        enable = true;

        # Uncomment to install cli packages from Homebrew.
        # brews = [
        #   "mas"
        # ];

        # Uncomment to install cask packages from Homebrew.
        casks = [
          "linearmouse"
          "chromium"
        ];

        # Uncomment to install app store apps using mas-cli.
        # masApps = {
        #   "Session" = 1521432881;
        # };

        # Uncomment to remove any non-specified homebrew packages.
        # onActivation.cleanUp = "zap";

        # Uncomment to automatically update Homebrew and upgrade packages.
        # onActivation.autoUpdate = true;
        # onActivation.upgrade = true;
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.zsh.enable = true;
      # programs.fish.enable = true;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      system.primaryUser = "teaver";

      system.configurationRevision = self.rev or self.dirtyRev or null;

      system.stateVersion = 6;

      # System
      system.defaults = {
        LaunchServices = {
          LSQuarantine = false;
        };

        dock = {
          tilesize = 32;
          autohide  = true;
          autohide-delay = 0.0;
          magnification = false;
          mineffect = "scale";
        };

        # finder.FXPreferredViewStyle = "clmv";
        loginwindow.GuestEnabled  = false;

        NSGlobalDomain = {
          AppleInterfaceStyle = "Dark";

          KeyRepeat = 2;
          InitialKeyRepeat = 15;

          AppleShowAllExtensions = true;
          ApplePressAndHoldEnabled = false;

          "com.apple.mouse.tapBehavior" = 1;
          "com.apple.sound.beep.volume" = 0.0;
          "com.apple.sound.beep.feedback" = 0;
        };

        trackpad = {
          # Clicking = true;
          TrackpadThreeFingerDrag = true;
        };

      };

      system.keyboard = {
        enableKeyMapping = true;
        remapCapsLockToControl = true;
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#prism
    # sudo darwin-rebuild switch --flake /etc/nix-darwin#prism
    darwinConfigurations."prism" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        mac-app-util.darwinModules.default
        nix-homebrew.darwinModules.nix-homebrew {
          nix-homebrew = {
            user = "teaver";
            enable = true;
            # enableRosetta = true;
            autoMigrate = true;
          };
        }
      ];
    };
  };
}
