{ config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.services.sunshine;
in
{
  options.pluskinda.services.sunshine = with types; {
    enable = mkBoolOpt false "Whether to enable Sunshine as a user service.";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPortRanges = [{ from = 47984; to = 48010; }];
    networking.firewall.allowedUDPPortRanges = [{ from = 47998; to = 48010; }];

    security.wrappers.sunshine = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_admin+p";
      source = "${pkgs.sunshine}/bin/sunshine";
    };

    systemd.user.services.sunshine = {
      description = "Sunshine self-hosted game stream host for Moonlight";
      startLimitBurst = 5;
      startLimitIntervalSec = 500;
      serviceConfig = {
        ExecStart = "${config.security.wrapperDir}/sunshine";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };

    environment.systemPackages = [ pkgs.pluskinda.sunshinectl ];
  };
}