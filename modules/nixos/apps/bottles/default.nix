{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.programs.bottles;
in
{
  options.programs.bottles = with types; {
    enable = mkBoolOpt false "Whether or not to enable Bottles.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ bottles ]; };
}