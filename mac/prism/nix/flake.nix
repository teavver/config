{
  # sudo nix run nix-darwin -- switch --flake .
  # sudo nix run nix-darwin/master#darwin-rebuild -- switch
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
            ffmpeg

            # development
            vscode
            playwright
            nodejs_22
            python313
            uv
            ruff
            vsce
            watchexec
            git-filter-repo
            tree

            # apps
            aerospace
            kitty
            obsidian
            hidden-bar
            sioyek
            switchaudio-osx
            keka

            # social
            mailspring
            zoom-us
          ];

          # Homebrew apps
          homebrew = {

            enable = true;

            onActivation = {
              cleanup = "uninstall";
              autoUpdate = false;
              upgrade = false;
            };

            caskArgs.no_quarantine = true;

            taps = [
              "sikarugir-app/sikarugir"
              "onkernel/tap" # https://www.onkernel.com/
            ];

            brews = [
              "onkernel/tap/kernel"
              "rabbitmq"
              "awscli"
              {
                name = "jenkins";
                restart_service = "changed";
                link = true;
              }
            ];

            casks = [
              "docker-desktop"
              "linearmouse"
              "chromium"
              "google-chrome"
              "lulu"
              "alfred"
              "vlc"
              "steam"
              "Sikarugir-App/sikarugir/sikarugir" # kegworks
              "stats"
              "utm"
              "keepingyouawake"
              "github"
              "gpt4all" # installer only: 'open /opt/homebrew/Caskroom/gpt4all/3.10.0/gpt4all-installer-darwin.app'
              "zen@twilight" # 'open /opt/homebrew/Caskroom/zen@twilight/1.16t,20250906110549/Twilight.app'
            ];

            # Uncomment to install app store apps using mas-cli.
            # masApps = {
            #   "Session" = 1521432881;
            # };
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
                  { app = "${nixAppsDir}/Mailspring.app"; }
                  { app = "${systemAppsDir}/Messages.app"; }
                  { app = "/Applications/Twilight.app"; }
                  # { app = "/Users/teaver/Applications/Home Manager Apps/Brave Browser.app"; }
                  { app = "${nixAppsDir}/kitty.app"; }
                  { app = "${nixAppsDir}/Visual Studio Code.app"; }
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

              # universalaccess = {
              #   reduceMotion = true;
              #   reduceTransparency = true;
              # };

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
                AppleInterfaceStyle = "Dark";
                ApplePressAndHoldEnabled = false;
                AppleShowAllExtensions = true;
                AppleShowAllFiles = true;
                InitialKeyRepeat = 15;
                KeyRepeat = 2;
                NSAutomaticCapitalizationEnabled = true;
                NSAutomaticPeriodSubstitutionEnabled = true;
                NSWindowResizeTime = 0.0;
                NSWindowShouldDragOnGesture = true;
                "com.apple.mouse.tapBehavior" = 1;
                "com.apple.sound.beep.feedback" = 0;
                "com.apple.sound.beep.volume" = 0.0;
                "com.apple.springing.delay" = 0.5;
                "com.apple.springing.enabled" = true;
                "com.apple.swipescrolldirection" = false;
                "com.apple.trackpad.forceClick" = true;
                "com.apple.trackpad.scaling" = 3.0;
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
