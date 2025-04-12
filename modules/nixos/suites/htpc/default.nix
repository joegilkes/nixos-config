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

      # Enable for full HTPC experience, needs a GPU and a HDMI CEC adapter to really make sense.
      # desktop.kodi = enabled;

      services = {
        jellyfin = enabled;
        # Only needed when running with a tuner card.
        # tvheadend = enabled;
      };
    };
  };
}