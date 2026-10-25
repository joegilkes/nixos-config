{ config, lib, ... }:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });

let
  cfg = config.services.jellyfin;
  jellyfinUser = config.services.jellyfin.user;
in
{
  config = mkIf cfg.enable {
    services.jellyfin = {
      openFirewall = true;
    };
    users.users.${jellyfinUser}.extraGroups = [ "render" ];
  };
}