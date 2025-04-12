{ config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.apps.pcsx2;
in
{
  options.pluskinda.apps.pcsx2 = with types; {
    enable = mkBoolOpt false "Whether or not to enable PCSX2.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      pcsx2
    ];
  };
}