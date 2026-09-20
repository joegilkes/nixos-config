{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.programs.unigine;
in
{
  options.programs.unigine = with types; {
    enable = mkBoolOpt false "Whether or not to enable Unigine benchmarks.";
  };

  config = mkIf cfg.enable { 
    environment.systemPackages = with pkgs; [ 
      unigine-heaven 
    ]; 
  };
}