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
            sops
            fish

            # development
            playwright
            nodejs_22
            python313
            uv
            ruff

            # apps
            aerospace
            stats
            kitty
            obsidian
            alt-tab-macos
            hidden-bar
            sioyek
            switchaudio-osx
          ];

          # Homebrew apps
          homebrew = {

            enable = true;

            caskArgs.no_quarantine = true;
            global.autoUpdate = false;
 
            taps = [
              "sikarugir-app/sikarugir"
              "onkernel/tap" # https://www.onkernel.com/
            ];

            brews = [
              "onkernel/tap/kernel"
              "coreutils"

              {
                name = "jenkins";
                restart_service = "changed";
                link = true;
              }
            ];



            casks = [
              "visual-studio-code"
              "linearmouse"
              "chromium"
              "lulu"
              "alfred"
              "vlc"
              "orbstack"
              "steam"
              "Sikarugir-App/sikarugir/sikarugir" # kegworks
              "caffeine"
              "ollama"
              "ollama-app"
            ];

            # Uncomment to install app store apps using mas-cli.
            # masApps = {
            #   "Session" = 1521432881;
            # };

            onActivation = {
              cleanup = "uninstall";
            };
          };

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          users.knownUsers = [ "teaver" ];
          users.users.teaver.uid = 501;
          users.users.teaver.shell = pkgs.fish;

          # Enable alternative shell support in nix-darwin.
          programs.zsh.enable = true;
          programs.fish.enable = true;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";

          system.primaryUser = "teaver";

          system.configurationRevision = self.rev or self.dirtyRev or null;

          system.stateVersion = 6;

          system.startup.chime = false;
          system.tools.darwin-rebuild.enable = true;

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
                  { app = "/Users/teaver/Applications/Home Manager Apps/Brave Browser.app"; }
                  { app = "${nixAppsDir}/kitty.app"; }
                  { app = "/Applications/Visual Studio Code.app"; }
                  { app = "${nixAppsDir}/Obsidian.app"; }
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

              universalaccess = {
                reduceMotion = true;
                reduceTransparency = true;
              };

              loginwindow.GuestEnabled = false;

              screensaver = {
                askForPassword = true;
                askForPasswordDelay = 0;
              };

              screencapture = {
                target = "clipboard";
                type = "png";
              };

              # menu bar icons
              controlcenter = {
                Bluetooth = false;
                Display = false;
                FocusModes = true;
                Sound = true;
                NowPlaying = false;
              };

              WindowManager = {
                GloballyEnabled = false;
                EnableStandardClickToShowDesktop = false;
              };

              NSGlobalDomain = {
                AKLastIDMSEnvironment = false;
                AKLastLocale = "en_US@rg=plzzzz";
                AppleAntiAliasingThreshold = 4;
                AppleInterfaceStyle = "Dark";
                AppleLanguages = [
                  "en-US"
                ];
                AppleLanguagesSchemaVersion = 5400;
                AppleLocale = "en_US@rg=plzzzz";
                AppleMiniaturizeOnDoubleClick = false;
                ApplePressAndHoldEnabled = false;
                AppleShowAllExtensions = true;
                AppleShowAllFiles = true;
                CGDisableCursorLocationMagnification = true;
                InitialKeyRepeat = 15;
                "KB_DoubleQuoteOption" = "\U201cabc\U201d";
                "KB_SingleQuoteOption" = "\U2018abc\U2019";
                "KB_SpellingLanguage" = {
                  "KB_SpellingLanguageIsAutomatic" = true;
                };
                KeyRepeat = 2;
                NSAutomaticCapitalizationEnabled = true;
                NSAutomaticPeriodSubstitutionEnabled = true;
                NSLinguisticDataAssetsRequestLastInterval = 86400;
                NSLinguisticDataAssetsRequestTime = "2025-08-25 10:16:09 +0000";
                NSLinguisticDataAssetsRequested = [
                  "en"
                  "en_US"
                  "pl"
                  "mul"
                  "mul_Latn"
                ];
                NSLinguisticDataAssetsRequestedByChecker = [
                  "en"
                  "pl"
                ];
                NSPreferredWebServices = {
                  NSWebServicesProviderWebSearch = {
                    NSDefaultDisplayName = "Google";
                    NSProviderIdentifier = "com.google.www";
                  };
                };
                NSSpellCheckerDictionaryContainerTransitionComplete = true;
                NSUserQuotesArray = [
                  "\U201c"
                  "\U201d"
                  "\U2018"
                  "\U2019"
                ];
                NSWindowResizeTime = false;
                NSWindowShouldDragOnGesture = true;
                "com.apple.finder.SyncExtensions" = {
                  collaborationMap = {};
                  dirMap = {};
                };
                "com.apple.mouse.tapBehavior" = true;
                "com.apple.sound.beep.feedback" = false;
                "com.apple.sound.beep.flash" = false;
                "com.apple.sound.beep.volume" = false;
                "com.apple.springing.delay" = 0.5;
                "com.apple.springing.enabled" = true;
                "com.apple.swipescrolldirection" = false;
                "com.apple.trackpad.forceClick" = true;
                "com.apple.trackpad.scaling" = 3;
                "com.apple.trackpad.trackpadCornerClickBehavior" = true;
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

          security.sudo.extraConfig = ''
            teaver ALL=(ALL) NOPASSWD: ALL
          '';

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
              enableRosetta = true;
              autoMigrate = true;
            };
          }
        ];
      };
    };
}
