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
    refreshInterval = mkOpt int 2 "WebUI refresh interval, in seconds.";
  };

  config = mkIf cfg.enable {
    systemd.services.glances = {
      enable = true;
      description = "Open-source system cross-platform monitoring tool";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.glances}/bin/glances -p ${toString cfg.port} -t ${toString cfg.refreshInterval} -w";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}