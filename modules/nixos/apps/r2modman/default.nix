{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.programs.r2modman;
in
{
  options.programs.r2modman = with types; {
    enable = mkBoolOpt false "Whether or not to enable r2modman Mod Manager.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      r2modman
    ];
  };
}