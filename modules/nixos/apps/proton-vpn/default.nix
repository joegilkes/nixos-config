{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.proton-vpn;
in
{
  options.pluskinda.apps.proton-vpn = with types; {
    enable = mkBoolOpt false "Whether or not to enable Proton VPN.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ proton-vpn ]; };
}