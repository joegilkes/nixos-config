{ config, lib, pkgs, ... }:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.programs.gamemode;
in
{
  config = mkIf cfg.enable {
    programs.gamemode.enableRenice = true;
  };
}