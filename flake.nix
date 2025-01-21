{
  description = "Plus Kinda";

  inputs = {
     # NixPkgs (nixos-24.11)
    stable.url = "github:nixos/nixpkgs/nixos-24.11";

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
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager (release-24-11)
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

    # Simple NixOS Mailserver
    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/master";

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
        musnix.nixosModules.musnix
        home-manager.nixosModules.home-manager
        agenix.nixosModules.default
        nix-index-database.nixosModules.nix-index {
          programs.nix-index.enableZshIntegration = true;
          programs.command-not-found.enable = false;
          programs.nix-index-database.comma.enable = true;
        }
      ];
      systems.hosts.attlerock.modules = with inputs; [ lix-module.nixosModules.default ];
      systems.hosts.brittle-hollow.modules = with inputs; [ lix-module.nixosModules.default ];
      systems.hosts.giants-deep.modules = with inputs; [ lix-module.nixosModules.default ];
      systems.hosts.interloper.modules = with inputs; [ simple-nixos-mailserver.nixosModule ];
      systems.hosts.timber-hearth.modules = with inputs; [ lix-module.nixosModules.default ];
    };
}