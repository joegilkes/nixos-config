{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.programs.steam;
in
{
  config = mkIf cfg.enable {
    programs.steam.remotePlay.openFirewall = true;

    hardware.steam-hardware.enable = true;

    environment.systemPackages = with pkgs; [
      steam
      # Nasty fix to make TF2 work for now.
      # Symlinks libtcmalloc_minimal.so.4 from 32-bit gperftools.
      # See https://github.com/ValveSoftware/Source-1-Games/issues/5043
      pkgsi686Linux.gperftools
    ];

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
    };

    # Allow local network game transfers.
    networking.firewall = {
      allowedTCPPorts = [ 27037 27040 ];
      allowedUDPPorts = [ 10400 10401 ];
    };
  };
}