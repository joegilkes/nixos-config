{  config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.programs.rpcs3;
in
{
  options.programs.rpcs3 = with types; {
    enable = mkBoolOpt false "Whether or not to enable RPCS3.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      rpcs3
    ];
  };
}