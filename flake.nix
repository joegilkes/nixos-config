{
  description = "Plus Kinda";

  inputs = {
     # NixPkgs (nixos-24.11)
    stable.url = "github:nixos/nixpkgs/nixos-25.05";

    # NixPkgs Unstable (nixos-unstable)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # NixPkgs Master
    master.url = "github:nixos/nixpkgs/master";

    blender-fix.url = "github:justinkb/nixpkgs/blender-hip";

    # Replace Nix with Lix https://lix.systems/
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager (release-25-05)
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Hardware Configuration
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Agenix - age encrypted secrets
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    # Musnix - RT kernel tweaks for audio
    musnix.url = "github:musnix/musnix";
    musnix.inputs.nixpkgs.follows = "nixpkgs";

    # Nix Gaming
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-gaming.inputs.nixpkgs.follows = "nixpkgs";

    # Crowdsec
    crowdsec.url = "git+https://codeberg.org/kampka/nix-flake-crowdsec.git";
    crowdsec.inputs.nixpkgs.follows = "nixpkgs";

    # Quantum chemistry programs
    qchem.url = "github:Nix-QChem/NixOS-QChem";
    qchem.inputs.nixpkgs.follows = "nixpkgs";

    # Snowfall Lib
    snowfall-lib.url = "github:snowfallorg/lib";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

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
        qchem.overlays.default
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
      systems.hosts.interloper.modules = with inputs; [ 
        crowdsec.nixosModules.crowdsec
        crowdsec.nixosModules.crowdsec-firewall-bouncer
      ];
      systems.hosts.timber-hearth.modules = with inputs; [ lix-module.nixosModules.default ];
    };
}