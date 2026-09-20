{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.programs.nixd;
in
{
  options.programs.nixd = with types; {
    enable = mkBoolOpt false "Whether or not to enable nixd.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ nixd ]; };
}