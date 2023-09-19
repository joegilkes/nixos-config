{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.protonvpn;
in
{
  options.pluskinda.apps.protonvpn = with types; {
    enable = mkBoolOpt false "Whether or not to enable Proton VPN.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      protonvpn-gui
      protonvpn-cli
     ]; 
  };
}