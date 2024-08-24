{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.services.samba;
in
{
  options.pluskinda.services.samba = with types; {
    enable = mkBoolOpt false "Whether to enable the SMB server.";
    wsdd-enable = mkBoolOpt true "Whether to enable the discoverability of SMB shares on Windows.";
    serverName = mkOpt str "nixsmb" "Name of SMB server";
    privateShareDirs = mkOpt attrs {} "Attribute set of directories to enable as private shares.";
    publicShareDirs = mkOpt attrs {} "Attribute set of directories to enable as public shares.";
  };

  config = mkIf cfg.enable {
    services.samba = {
      enable = true;
      securityType = "user";
      openFirewall = true;

      extraConfig = ''
        workgroup = WORKGROUP
        server string = ${ cfg.serverName }
        netbios name = ${ cfg.serverName }
        security = user 
        #use sendfile = yes
        #max protocol = smb2
        # note: localhost is the ipv6 localhost ::1
        hosts allow = 192.168.0. 127.0.0.1 localhost
        hosts deny = 0.0.0.0/0
        guest account = nobody
        map to guest = bad user
      '';

      shares = (
        mapAttrs (name: value: {
          path = value;
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "joe";
          "force group" = "users";
        }) cfg.publicShareDirs
      ) // (
        mapAttrs (name: value: {
          path = value;
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "joe";
          "force group" = "users";
        }) cfg.privateShareDirs
      );
    };

    services.samba-wsdd = {
      enable = cfg.wsdd-enable;
      openFirewall = cfg.wsdd-enable;
    };

    networking.firewall.enable = true;
    networking.firewall.allowPing = true;
  };
}