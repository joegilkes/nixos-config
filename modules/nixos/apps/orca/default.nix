{  config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.programs.orca;
in
{
  options.programs.orca = with types; {
    enable = mkBoolOpt false "Whether or not to enable Orca (quantum chem).";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      qchem.orca
    ];
  };
}