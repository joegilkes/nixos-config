{ lib, config, ... }:

let
  cfg = config.services.avahi;
in
{
  config = lib.mkIf cfg.enable {
    services.avahi = {
      nssmdns4 = true;
      settings.publish = {
        publish-addresses = true;
        publish-domain = true;
        publish-hinfo = true;
        publish-workstation = true;
        disable-user-service-publishing = false;
      };
    };
  };
}