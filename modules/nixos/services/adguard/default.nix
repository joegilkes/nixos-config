{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.services.adguard;
in
{
  options.pluskinda.services.adguard = with types; {
    enable = mkBoolOpt false "Whether to enable AdGuard Home.";
  };

  config = mkIf cfg.enable {
    services.adguardhome.enable = true;
  };
}