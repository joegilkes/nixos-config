{ config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.apps.rpcs3;
in
{
  options.pluskinda.apps.rpcs3 = with types; {
    enable = mkBoolOpt false "Whether or not to enable RPCS3.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      rpcs3
    ];
  };
}