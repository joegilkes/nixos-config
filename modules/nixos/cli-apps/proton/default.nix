{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.cli-apps.proton;
in
{
  options.pluskinda.cli-apps.proton = with types; {
    enable = mkBoolOpt false "Whether or not to enable Proton.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      proton-caller
      protonup-qt
    ];
  };
}