{ options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
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
      adguard = enabled;
      # calibre-web = enabled;
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
# Profile composing storage and network-attached-service functionality.