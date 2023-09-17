{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.suites.creative;
in
{
  options.pluskinda.suites.creative = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable the creative apps suite.";
  };

  config = mkIf cfg.enable {
    pluskinda = {
      apps = {
        blender = enabled;
      };
    };
  };
}