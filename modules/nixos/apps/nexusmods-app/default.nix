{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.programs.nexusmods-app;
in
{
  options.programs.nexusmods-app = with types; {
    enable = mkBoolOpt false "Whether or not to enable the NexusMods.App mod manager.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      nexusmods-app-unfree
    ];
  };
}