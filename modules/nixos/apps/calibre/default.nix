{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.programs.calibre;
in
{
  options.programs.calibre = with types; {
    enable = mkBoolOpt false "Whether or not to enable Calibre.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ calibre ]; };
}