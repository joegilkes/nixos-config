{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.programs.proton-pass;
in
{
  options.programs.proton-pass = with types; {
    enable = mkBoolOpt false "Whether or not to enable Proton Pass.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      proton-pass
    ];
  };
}