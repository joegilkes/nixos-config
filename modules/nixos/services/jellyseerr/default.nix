{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.services.jellyseerr;
in
{
  options.pluskinda.services.jellyseerr = with types; {
    enable = mkBoolOpt false "Whether to enable Jellyseerr.";
    port = mkOpt port 5055 "Port to run Jellyseerr through";
  };

  config = mkIf cfg.enable {
    services.jellyseerr = {
      enable = true;
      port = cfg.port;
      openFirewall = true;
    };
  };
}