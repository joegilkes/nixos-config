{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.unigine;
in
{
  options.pluskinda.apps.unigine = with types; {
    enable = mkBoolOpt false "Whether or not to enable Unigine benchmarks.";
  };

  config = mkIf cfg.enable { 
    environment.systemPackages = with pkgs; [ 
      unigine-heaven 
    ]; 
  };
}