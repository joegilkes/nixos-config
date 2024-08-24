{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.jellyfin;
in
{
  options.pluskinda.apps.jellyfin = with types; {
    enable = mkBoolOpt false "Whether or not to enable the Jellyfin client.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ jellyfin-media-player ]; };
}