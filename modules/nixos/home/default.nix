{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.home;
in
{
  # imports = with inputs; [
  #   home-manager.nixosModules.home-manager
  # ];

  options.pluskinda.home = with types; {
    file = mkOpt attrs { }
      (mdDoc "A set of files to be managed by home-manager's `home.file`.");
    configFile = mkOpt attrs { }
      (mdDoc "A set of files to be managed by home-manager's `xdg.configFile`.");
    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager.";
  };

  config = {
    pluskinda.home.extraOptions = {
      home.stateVersion = config.system.stateVersion;
      home.file = mkAliasDefinitions options.pluskinda.home.file;
      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions options.pluskinda.home.configFile;
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users.${config.pluskinda.user.name} =
        mkAliasDefinitions options.pluskinda.home.extraOptions;
    };
  };
}