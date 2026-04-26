{
  description = "Home Manager configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/1.20t-1776637807";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      zen-browser,
      llm-agents,
      ...
    }:
    let
      system = "x86_64-linux";
    in
    {
      homeConfigurations."teaver" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          zen-browser.homeModules.twilight
          ./home.nix
        ];
        extraSpecialArgs = {
          flake-pkgs = {
            zen-browser = zen-browser.packages.${system}.default;
            zen-browser-twilight = zen-browser.packages.${system}.twilight;
            llm-agents = llm-agents.packages.${system};
          };
        };
      };
    };
}
