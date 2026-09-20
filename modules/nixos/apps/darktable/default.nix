{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.programs.darktable;
in
{
  options.programs.darktable = with types; {
    enable = mkBoolOpt false "Whether or not to enable Darktable.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ darktable ]; };
}