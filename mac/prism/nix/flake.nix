{
  # sudo darwin-rebuild switch --flake /etc/nix-darwin#prism

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    mac-app-util.url = "github:hraban/mac-app-util"; # mac app aliases | https://github.com/hraban/mac-app-util
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew"; # homebrew | https://github.com/zhaofengli/nix-homebrew
    home-manager.url = "github:nix-community/home-manager/release-25.05";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      mac-app-util,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      home-manager,
      ...
    }:
    let
      configuration =
        { pkgs, ... }:
        {

          nix.enable = false;

          nixpkgs.config.allowUnfree = true;

          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = with pkgs; [

            # core
            vim
            tmux
            curl
            wget
            git
            gh
            xclip
            bat
            fzf
            coreutils
            sops

            # development
            playwright
            nodejs_22
            python313
            uv
            ruff

            # apps
            aerospace
            stats
            brave
            spotify
            kitty
            obsidian
            alt-tab-macos
            hidden-bar
            bitwarden-desktop
            sioyek
            switchaudio-osx
          ];

          # Homebrew apps
          homebrew = {

            enable = true;

            caskArgs.no_quarantine = true;
            global.autoUpdate = false;

            # https://www.onkernel.com/
            taps = [
              "onkernel/tap"
            ];

            brews = [
              "onkernel/tap/kernel"
              "jenkins"
            ];

            casks = [
              "visual-studio-code"
              "linearmouse"
              "chromium"
              "lulu"
              "alfred"
              "vlc"
              "orbstack"
              "ollama"
              "steam"
              "whisky"
            ];

            # Uncomment to install app store apps using mas-cli.
            # masApps = {
            #   "Session" = 1521432881;
            # };
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
          system.defaults =
            let
              systemAppsDir = "/System/Applications";
              nixAppsDir = "/Applications/Nix Apps";
            in
            {
              LaunchServices = {
                LSQuarantine = false;
              };

              dock = {
                tilesize = 28;
                autohide = true;
                autohide-delay = 0.0;
                autohide-time-modifier = 0.0;
                magnification = false;
                mineffect = "scale";
                show-recents = false;
                wvous-br-corner = 1; # Disable hot corner (bottom right)

                persistent-apps = [
                  { app = "${systemAppsDir}/Mail.app"; }
                  { app = "${systemAppsDir}/Messages.app"; }
                  { app = "${nixAppsDir}/Brave Browser.app"; }
                  { app = "${nixAppsDir}/kitty.app"; }
                  { app = "/Applications/Visual Studio Code.app"; }
                  { app = "${nixAppsDir}/Obsidian.app"; }
                  { app = "${nixAppsDir}/Spotify.app"; }
                  { app = "${nixAppsDir}/Stats.app"; }
                  { app = "${systemAppsDir}/System Settings.app"; }
                  { app = "${systemAppsDir}/Utilities/Activity Monitor.app"; }
                ];

              };

              finder = {
                NewWindowTarget = "Other";
                NewWindowTargetPath = "/Users/teaver/";
                _FXShowPosixPathInTitle = true;
                ShowPathbar = true;
                AppleShowAllExtensions = true;
                ShowStatusBar = true;
                AppleShowAllFiles = true;
                FXPreferredViewStyle = "Nlsv"; # List view
                CreateDesktop = false;
              };

              loginwindow.GuestEnabled = false;

              screensaver.askForPassword = true;
              screensaver.askForPasswordDelay = 0;

              controlcenter.FocusModes = true; # Show in Menu Bar

              WindowManager.GloballyEnabled = false;
              WindowManager.EnableStandardClickToShowDesktop = false;

              NSGlobalDomain = {
                NSWindowResizeTime = 0.0;
                NSWindowShouldDragOnGesture = true;

                KeyRepeat = 2;
                InitialKeyRepeat = 15;

                AppleShowAllFiles = true;
                AppleShowAllExtensions = true;
                ApplePressAndHoldEnabled = false;

                "com.apple.trackpad.scaling" = 3.0;
                "com.apple.mouse.tapBehavior" = 1;
                "com.apple.sound.beep.volume" = 0.0;
                "com.apple.sound.beep.feedback" = 0;
                "com.apple.swipescrolldirection" = false;
                "com.apple.trackpad.trackpadCornerClickBehavior" = 1;
              };

              trackpad = {
                Clicking = true;
                ActuationStrength = 0;
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
      darwinConfigurations."prism" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration

          home-manager.darwinModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }

          mac-app-util.darwinModules.default

          nix-homebrew.darwinModules.nix-homebrew
          {
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
