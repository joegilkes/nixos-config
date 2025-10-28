{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.bs-manager;
in
{
  options.pluskinda.apps.bs-manager = with types; {
    enable = mkBoolOpt false "Whether or not to enable BSManager.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ bs-manager ]; };
}