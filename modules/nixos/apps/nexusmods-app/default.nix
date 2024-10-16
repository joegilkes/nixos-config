{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.apps.nexusmods-app;
in
{
  options.pluskinda.apps.nexusmods-app = with types; {
    enable = mkBoolOpt false "Whether or not to enable the NexusMods.App mod manager.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      nexusmods-app-unfree
    ];
  };
}