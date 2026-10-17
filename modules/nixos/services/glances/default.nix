{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.services.glances;
in
{
  options.services.glances = with types; {
    refreshInterval = mkOpt int 2 "WebUI refresh interval, in seconds.";
  };

  config = mkIf cfg.enable {
    services.glances.extraArgs = [
      "-t" 
      "${toString cfg.refreshInterval}"
      "-w"
    ];
  };
}