{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.blender;
in
{
  options.pluskinda.apps.blender = with types; {
    enable = mkBoolOpt false "Whether or not to enable Blender.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ blender ]; };
}