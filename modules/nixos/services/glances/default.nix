{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.services.glances;
in
{
  options.pluskinda.services.glances = with types; {
    enable = mkBoolOpt false "Whether to enable the Glances web server.";
  };

  config = mkIf cfg.enable {
    systemd.services.glances = {
      enable = true;
      description = "Open-source system cross-platform monitoring tool";
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.glances}/bin/glances -w";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };

    networking.firewall.allowedTCPPorts = [ 61208 ];
    networking.firewall.allowedUDPPorts = [ 61208 ];
  };
}