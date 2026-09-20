{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.programs.sidequest;
in
{
  options.programs.sidequest = with types; {
    enable = mkBoolOpt false "Whether or not to enable Sidequest.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ sidequest ]; };
}