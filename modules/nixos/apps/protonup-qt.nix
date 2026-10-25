{ config, lib, pkgs, ... }:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });

let
  cfg = config.programs.protonup-qt;
in
{
  options.programs.protonup-qt = with types; {
    enable = mkBoolOpt false "Whether or not to enable ProtonUp-Qt.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      protonup-qt
    ];
  };
}