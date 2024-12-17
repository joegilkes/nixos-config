{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.apps.r2modman;
in
{
  options.pluskinda.apps.r2modman = with types; {
    enable = mkBoolOpt false "Whether or not to enable r2modman Mod Manager.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      r2modman
    ];
  };
}