{
  description = "Plus Kinda";

  inputs = {
     # NixPkgs (nixos-23.05)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    # NixPkgs Unstable (nixos-unstable)
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager (release-23.05)
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Hardware Configuration
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Snowfall Lib
    snowfall-lib.url = "github:snowfallorg/lib/dev";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    # Snowfall Flake
    flake.url = "github:snowfallorg/flake";
    flake.inputs.nixpkgs.follows = "unstable";

    # Flake Hygiene
    flake-checker = {
      url = "github:DeterminateSystems/flake-checker";
      inputs.nixpkgs.follows = "unstable";
    };
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

      ];

      systems.modules.nixos = with inputs; [
        home-manages.nixosModules.home-manager
      ];
    };
}