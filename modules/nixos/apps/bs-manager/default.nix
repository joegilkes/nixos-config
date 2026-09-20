{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.programs.bs-manager;
in
{
  options.programs.bs-manager = with types; {
    enable = mkBoolOpt false "Whether or not to enable BSManager.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ bs-manager ]; };
}