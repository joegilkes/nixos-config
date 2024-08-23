{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.services.zfs;
in
{
  options.pluskinda.services.zfs = with types; {
    enable = mkBoolOpt false "Whether to enable ZFS services.";
  };

  config = mkIf cfg.enable {
    services.zfs = {
      autoScrub = enabled;
      trim = enabled;
    };
  };
}