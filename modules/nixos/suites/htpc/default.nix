{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.suites.htpc;
in
{
  options.pluskinda.suites.htpc = with types; {
    enable = mkBoolOpt false "Whether or not to enable HTPC apps and services.";
  };

  config = mkIf cfg.enable {
    pluskinda = {
      apps = {};

      desktop.kodi = enabled;

      services = {
        jellyfin = enabled;
        tvheadend = enabled;
      };
    };
  };
}