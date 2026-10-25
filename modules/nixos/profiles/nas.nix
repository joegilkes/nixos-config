{ config, lib, ... }:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });

let 
  cfg = config.profiles.nas;
in
{
  options.profiles.nas = with types; {
    enable = mkBoolOpt false "Whether or not to enable NAS apps and services.";
  };

  config = mkIf cfg.enable {
    services = {
      flatpak.enable = mkForce false;
      glances = enabled;
      samba = enabled;
      zfs = enabled;
    };

    services = {
      devmon = enabled;
      gvfs = enabled;
      udisks2 = enabled;
    };
  };
}