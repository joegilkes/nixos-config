{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.programs.proton-vpn;
in
{
  options.programs.proton-vpn = with types; {
    enable = mkBoolOpt false "Whether or not to enable Proton VPN.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ proton-vpn ]; };
}