{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.programs.heroic-launcher;
in
{
  options.programs.heroic-launcher = with types; {
    enable = mkBoolOpt false "Whether or not to enable Heroic Launcher.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ heroic ]; };
}