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
      title = "Dashboard - ${hname}";
      headerstyle = "clean";
      layout = {
        stats = {
          style = "row";
          columns = 4;
        };
        media = {
          style = "columns";
        };
        network = {
          style = "columns";
        };
      };
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
        stats = [
          { 
            "CPU Usage" = {
              widget = {
                type = "glances";
                url = "http://${hname}.local:8096";
                metric = "cpu";
              };
            };
          }
          { 
            "Memory Usage" = {
              widget = {
                type = "glances";
                url = "http://${hname}.local:8096";
                metric = "memory";
              };
            };
          }
          { 
            "Network Usage" = {
              widget = {
                type = "glances";
                url = "http://${hname}.local:8096";
                metric = "network:enp0s31f6";
              };
            };
          }
          { 
            "Top Processes" = {
              widget = {
                type = "glances";
                url = "http://${hname}.local:8096";
                metric = "process";
              };
            };
          }
          { 
            "gabbro/public" = {
              widget = {
                type = "glances";
                url = "http://${hname}.local:8096";
                metric = "fs:/mnt/gabbro/public";
                chart = false;
              };
            };
          }
          { 
            "gabbro/backups" = {
              widget = {
                type = "glances";
                url = "http://${hname}.local:8096";
                metric = "fs:/mnt/gabbro/backups";
                chart = false;
              };
            };
          }
          { 
            "gabbro/media" = {
              widget = {
                type = "glances";
                url = "http://${hname}.local:8096";
                metric = "fs:/mnt/gabbro/media";
                chart = false;
              };
            };
          }
          { 
            "gabbro/storage" = {
              widget = {
                type = "glances";
                url = "http://${hname}.local:8096";
                metric = "fs:/mnt/gabbro/storage";
                chart = false;
              };
            };
          }
        ];
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
            icon = "adguard-home.png";
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
        greeting = {
          text_size = "xl";
          text = "${hname}";
        };
      }
      {
        search = {
          provider = "google";
          target = "_self";
        };
      }
      {
        datetime = {
          text_size = "md";
          format = {
            dateStyle = "short";
            timeStyle = "short";
            hour12 = true;
          };
        };
      }
    ];
  };
}