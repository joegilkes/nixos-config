{  config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.programs.pcsx2;
in
{
  options.programs.pcsx2 = with types; {
    enable = mkBoolOpt false "Whether or not to enable PCSX2.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      pcsx2
    ];
  };
}