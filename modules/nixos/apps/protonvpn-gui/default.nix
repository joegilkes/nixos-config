{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.protonvpn-gui;
in
{
  options.pluskinda.apps.protonvpn-gui = with types; {
    enable = mkBoolOpt false "Whether or not to enable Proton VPN (GUI).";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ protonvpn-gui ]; };
}