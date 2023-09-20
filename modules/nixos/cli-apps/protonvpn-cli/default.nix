{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.cli-apps.protonvpn-cli;
in
{
  options.pluskinda.cli-apps.protonvpn-cli = with types; {
    enable = mkBoolOpt false "Whether or not to enable Proton VPN (CLI).";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ protonvpn-cli ]; };
}