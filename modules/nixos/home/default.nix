{  options, config, pkgs, lib, inputs, ... }:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });
{
  # imports = with inputs; [
  #   home-manager.nixosModules.home-manager
  # ];

  options.home = with types; {
    file = mkOpt attrs { }
      (mdDoc "A set of files to be managed by home-manager's `home.file`.");
    configFile = mkOpt attrs { }
      (mdDoc "A set of files to be managed by home-manager's `xdg.configFile`.");
    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager.";
  };

  config = {
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users.${config.user.name} = mkMerge [
        {
          home.file = config.home.file;
          xdg.enable = true;
          xdg.configFile = config.home.configFile;
        }
        (mkAliasDefinitions options.home.extraOptions)
      ];
    };
  };
}