{ options, config, pkgs, lib, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.services.traefik;
in
{
  options.pluskinda.services.traefik = with types; {
    enable = mkBoolOpt false "Whether or not to configure Traefik as a reverse proxy.";
  };

  config = mkIf cfg.enable { 
    services.traefik = {
      enable = true;

      staticConfigOptions = {
        entryPoints = {
          web = {
            address = ":80";
            asDefault = true;
            # http.redirections.entrypoint = {
            #   to = "websecure";
            #   scheme = "https";
            # };
          };

          # websecure = {
          #   address = ":443";
          #   asDefault = true;
          #   http.tls.certResolver = "letsencrypt";
          # };
        };

        log = {
          level = "INFO";
          filePath = "${config.services.traefik.dataDir}/traefik.log";
          format = "json";
        };

        # certificatesResolvers.letsencrypt.acme = {
        #   email = "postmaster@YOUR.DOMAIN";
        #   storage = "${config.services.traefik.dataDir}/acme.json";
        #   httpChallenge.entryPoint = "web";
        # };

        api.dashboard = true;
        # Access the Traefik dashboard on <Traefik IP>:8080 of your server
        api.insecure = true;
      };
    };
  };
}