{ config, lib, pkgs, inputs, ...}:

let 
  hname = config.networking.hostName;
in 
{
  age.secrets = {
    homepage-env = {
      file = ../../../secrets/giants-deep-homepage.age;
      owner = "root";
      group = "users";
      mode = "400";
    };
  };

  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
    environmentFile = config.age.secrets.homepage-env.path;
    settings = {
      title = "NAS Dashboard [${hname}]";
      headerstyle = "clean";
    };
    bookmarks = [{
      dev = [
        { github = [{
            abbr = "GitHub";
            href = "https://github.com/joegilkes";
            icon = "github-light.png";
          }];
        }
        { homepage-docs = [{
            abbr = "HPDocs";
            href = "https://gethomepage.dev/";
            icon = "homepage.png";
          }];
        }
      ];
    }];
    services = [
      {
        media = [
          { 
            Jellyfin = {
              icon = "jellyfin.png";
              href = "http://${hname}.local:8096";
              description = "film/TV streaming";
              widget = {
                type = "jellyfin";
                url = "http://${hname}.local:8096";
                key = "{{HOMEPAGE_VAR_JELLYFIN_API_KEY}}";
              };
            };
          }
        ];
      network = [
        {
          "AdGuard Home" = {
            icon = "";
            href = "http://${hname}.local:3003";
            description = "DNS filter";
            widget = {
              type = "adguard";
              url = "http://${hname}.local:3003";
              username = "{{HOMEPAGE_VAR_ADGUARD_USER}}";
              password = "{{HOMEPAGE_VAR_ADGUARD_PASS}}";
            };
          };
        }
      ];
    }];
    widgets = [
      {
        search = {
          provider = "google";
          target = "_self";
        };
      }
      {
        glances = {
          url = "http://${hname}.local:61208";
          cpu = true;
          label = "CPU Usage";
        };
      }
      {
        glances = {
          url = "http://${hname}.local:61208";
          memory = true;
          label = "Memory Usage";
        };
      }
      {
        glances = {
          url = "http://${hname}.local:61208";
          process = true;
          label = "Top Processes";
        };
      }
      {
        glances = {
          url = "http://${hname}.local:61208";
          "network:enp0s31f6" = true;
          label = "Network Usage";
        };
      }
      {
        glances = {
          url = "http://${hname}.local:61208";
          "fs:/mnt/gabbro/public" = true;
          label = "gabbro/public";
          chart = false;
        };
      }
      {
        glances = {
          url = "http://${hname}.local:61208";
          "fs:/mnt/gabbro/storage" = true;
          label = "gabbro/storage";
          chart = false;
        };
      }
      {
        glances = {
          url = "http://${hname}.local:61208";
          "fs:/mnt/gabbro/backups" = true;
          label = "gabbro/backups";
          chart = false;
        };
      }
      {
        glances = {
          url = "http://${hname}.local:61208";
          "fs:/mnt/gabbro/media" = true;
          label = "gabbro/media";
          chart = false;
        };
      }
    ];
  };
}