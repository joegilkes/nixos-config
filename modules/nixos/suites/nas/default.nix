{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.suites.nas;
in
{
  options.pluskinda.suites.nas = with types; {
    enable = mkBoolOpt false "Whether or not to enable NAS apps.";
  };

  config = mkIf cfg.enable {
    pluskinda = {
      apps = {};

      services = {
        flatpak.enable = mkForce false;
        adguard = enabled;
        glances = enabled;
        jellyfin = enabled;
        tvheadend = enabled;
        samba = enabled;
        zfs = enabled;
      };
    };

    services = {
      devmon = enabled;
      gvfs = enabled;
      udisks2 = enabled;
    };
  };
}