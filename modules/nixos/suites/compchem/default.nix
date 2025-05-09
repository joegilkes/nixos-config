{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.suites.compchem;
in
{
  options.pluskinda.suites.compchem = with types; {
    enable = mkBoolOpt false "Whether or not to enable computational chemistry apps.";
  };

  config = mkIf cfg.enable {
    pluskinda = {
      apps = {
        orca = enabled;
      };
    };
  };
}