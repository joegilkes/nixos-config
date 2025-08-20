{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.suites.gamedev;
in
{
  options.pluskinda.suites.gamedev = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable game development configuration.";
  };

  config = mkIf cfg.enable {
    pluskinda = {
      apps = {
        godot = enabled;
        pixelorama = enabled;
      };
    };
  };
}