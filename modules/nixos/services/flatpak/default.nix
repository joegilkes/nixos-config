{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.services.flatpak;
in
{
  options.pluskinda.services.flatpak = with types; {
    enable = mkBoolOpt false "Whether to enable Flatpak.";
  };

  config = mkIf cfg.enable {
    services.flatpak.enable = true;
  };
}