{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.programs.rpi;
in
{
  options.programs.rpi = with types; {
    enable = mkBoolOpt false "Whether or not to enable libraspberrypi tools.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ libraspberrypi ]; };
}