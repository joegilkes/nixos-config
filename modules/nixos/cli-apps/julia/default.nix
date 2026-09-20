{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.programs.julia;
in
{
  options.programs.julia = with types; {
    enable = mkBoolOpt false "Whether or not to enable Julia.";
    
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ julia-bin ]; };
}