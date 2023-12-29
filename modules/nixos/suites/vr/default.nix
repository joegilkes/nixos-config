{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.suites.vr;
in
{
  options.pluskinda.suites.vr = with types; {
    enable = mkBoolOpt false "Whether or not to enable VR apps.";
  };

  config = mkIf cfg.enable {
    pluskinda = {
      apps = {
        sidequest = enabled;
      };
    };
  };
}