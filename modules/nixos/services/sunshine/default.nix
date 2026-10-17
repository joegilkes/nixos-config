{ config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.services.sunshine;
in
{
  config = mkIf cfg.enable {
    services.sunshine.autoStart = false;
    environment.systemPackages = [ pkgs.sunshinectl ];
  };
}