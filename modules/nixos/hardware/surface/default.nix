{ options, config, pkgs, lib, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.hardware.surface;
in
{
  options.pluskinda.hardware.surface = with types; {
    enable = mkBoolOpt false
      "Whether or not to enable additional support for Microsoft Surface devices.";
    useLibcamera = mkBoolOpt false
      "Whether or not to use libcamera (also enables/disables it in pipewire)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; mkMerge [
      [
        libwacom-surface
        iptsd
      ]
      ( mkIf cfg.useLibcamera [
        libcamera
      ])
    ];

    services= {
      iptsd.config.Touchscreen.DisableOnPalm = true;
    };

    environment.etc = mkIf (!cfg.useLibcamera) {
      "wireplumber/wireplumber.conf.d/51-libcamera-disable.conf" = {
        text = ''
        wireplumber.profiles = {
            main = {
                monitor.libcamera = disabled
            }
        }
        '';
        mode = "0444";
      };
    };
  };
}