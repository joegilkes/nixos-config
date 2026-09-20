{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.programs.liquidctl;
in
{
  options.programs.liquidctl = with types; {
    enable = mkBoolOpt false "Whether or not to enable liquidctl.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ liquidctl ]; };
}