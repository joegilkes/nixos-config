{ config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;

let 
  cfg = config.pluskinda.services.tvheadend;
  pidFile = "${config.users.users.tvheadend.home}/tvheadend.pid";
in

{
  options.pluskinda.services.tvheadend = {
    enable = mkBoolOpt false "Whether to enable Tvheadend as a service with its own user.";
    httpPort = mkOpt port 9981 "Port to bind HTTP to.";
    htspPort = mkOpt port 9982 "Port to bind HTSP to.";
  };

  config = mkIf cfg.enable {
    users.users.tvheadend = {
      description = "Tvheadend Service user";
      home        = "/var/lib/tvheadend";
      createHome  = true;
      isSystemUser = true;
      group = "tvheadend";
    };
    users.groups.tvheadend = {};

    systemd.services.tvheadend = {
      description = "Tvheadend TV streaming server";
      wantedBy    = [ "multi-user.target" ];
      after       = [ "network.target" ];

      serviceConfig = {
        Type         = "forking";
        PIDFile      = pidFile;
        Restart      = "always";
        RestartSec   = 5;
        User         = "tvheadend";
        Group        = "video";
        ExecStart    = ''
                       ${pkgs.pluskinda.tvheadend}/bin/tvheadend \
                       --http_port ${toString cfg.httpPort} \
                       --htsp_port ${toString cfg.htspPort} \
                       -f \
                       -C \
                       -p ${pidFile} \
                       -u tvheadend \
                       -g video
                       '';
        ExecStop     = "${pkgs.coreutils}/bin/rm ${pidFile}";
      };
    };
  };
}