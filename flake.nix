{
  description = "Plus Kinda";

  inputs = {
     # NixPkgs (nixos-24.05)
    stable.url = "github:nixos/nixpkgs/nixos-24.05";

    # NixPkgs Unstable (nixos-unstable)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # NixPkgs Master
    master.url = "github:nixos/nixpkgs/master";

    # Nixpkgs commit for fixing sunshine, see overlay.
    sunshine-fix.url = "github:nixos/nixpkgs/3a9671961fd9481564092656e1ccb5f8fdf2ded4";

    # NexusMods.app latest version.
    nexusmods-latest.url = "github:nixos/nixpkgs/1eee78feeb14691bf478b1ccab9eedc2ecfc6484";

    # Replace Nix with Lix https://lix.systems/
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager (release-23.05)
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Hardware Configuration
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Agenix - age encrypted secrets
    agenix.url = "github:ryantm/agenix";

    # Musnix - RT kernel tweaks for audio
    musnix.url = "github:musnix/musnix";

    # Nix Gaming
    nix-gaming.url = "github:fufexan/nix-gaming";

    # Snowfall Lib
    snowfall-lib.url = "github:snowfallorg/lib";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    # Snowfall Flake
    snowfall-flake.url = "github:snowfallorg/flake";
    snowfall-flake.inputs.nixpkgs.follows = "nixpkgs";

    # nix-index database
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: let 
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;
      src = ./.;

      snowfall = {
        meta = {
          name = "pluskinda";
          title = "Plus Kinda";
        };
        namespace = "pluskinda";
      };
    };
  in 
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
      };

      overlays = with inputs; [
        snowfall-flake.overlays."package/flake"
      ];

      systems.modules.nixos = with inputs; [
        lix-module.nixosModules.default
        musnix.nixosModules.musnix
        home-manager.nixosModules.home-manager
        agenix.nixosModules.default
        nix-index-database.nixosModules.nix-index {
          programs.nix-index.enableZshIntegration = true;
          programs.command-not-found.enable = false;
          programs.nix-index-database.comma.enable = true;
        }
      ];
    };
}