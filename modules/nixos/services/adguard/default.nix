{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.services.adguard;
in
{
  options.pluskinda.services.adguard = with types; {
    enable = mkBoolOpt false "Whether to enable AdGuard Home.";
    port = mkOpt port 3003 "Port to run the AdGuard Home WebUI through";
  };

  config = mkIf cfg.enable {
    services.adguardhome = {
      enable = true;
      openFirewall = true;
      port = cfg.port;
    };

    networking.firewall.allowedTCPPorts = [ 53 ];
    networking.firewall.allowedUDPPorts = [ 53 ];
  };
}