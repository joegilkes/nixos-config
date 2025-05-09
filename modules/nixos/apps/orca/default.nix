{ config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.apps.orca;
in
{
  options.pluskinda.apps.orca = with types; {
    enable = mkBoolOpt false "Whether or not to enable Orca (quantum chem).";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      qchem.orca
    ];
  };
}