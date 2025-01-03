{ pkgs, config, lib, channel, ...}:

{
  services.traefik = {
    dynamicConfigOptions = {
      http = {
        routers = {
          mainRouter = {
            rule = "Host(`wilds.joegilk.es`)";
            tls.certResolver = "letsencrypt";
            service = "glances";
          };
          mailserver-nginx = {
            rule = "Host(`mail.joegilk.es`)";
            # tls.certResolver = "letsencrypt";
            service = "nginx";
          };
        };
        services = {
          glances.loadBalancer.servers = [
                {
                  url = "http://localhost:61208";
                }
              ];
          nginx.loadBalancer.servers = [
            {
              url = "http://localhost:81";
            }
          ];
        };
      };
    };
  };
}