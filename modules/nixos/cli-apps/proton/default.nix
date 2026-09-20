{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.programs.proton;
in
{
  options.programs.proton = with types; {
    enable = mkBoolOpt false "Whether or not to enable Proton.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      # proton-caller # Removed form nixpkgs due to lack of maintenance
      protonup-qt
    ];
  };
}