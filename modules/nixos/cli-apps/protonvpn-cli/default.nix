{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.protonvpn-cli;
in
{
  options.pluskinda.apps.protonvpn-cli = with types; {
    enable = mkBoolOpt false "Whether or not to enable Proton VPN (CLI).";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ protonvpn-cli ]; };
}