{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.services.glances;
in
{
  options.pluskinda.services.glances = with types; {
    enable = mkBoolOpt false "Whether to enable the Glances web server.";
    port = mkOpt port 61208 "TCP port to run the Glances web server through";
  };

  config = mkIf cfg.enable {
    systemd.services.glances = {
      enable = true;
      description = "Open-source system cross-platform monitoring tool";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.glances}/bin/glances -p ${toString cfg.port} -w";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}