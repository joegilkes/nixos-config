{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.cli-apps.julia;
in
{
  options.pluskinda.cli-apps.julia = with types; {
    enable = mkBoolOpt false "Whether or not to enable Julia.";
    
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ julia-bin ]; };
}