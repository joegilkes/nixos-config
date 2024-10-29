{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.suites.social;
in
{
  options.pluskinda.suites.social = with types; {
    enable = mkBoolOpt false "Whether or not to enable social apps.";
  };

  config = mkIf cfg.enable {
    pluskinda = {
      apps = {
        evolution = enabled;
        discord = enabled;
        slack = enabled;
      };
    };
  };
}