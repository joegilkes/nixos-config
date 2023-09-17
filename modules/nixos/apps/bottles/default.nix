{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.bottles;
in
{
  options.pluskinda.apps.bottles = with types; {
    enable = mkBoolOpt false "Whether or not to enable Bottles.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ bottles ]; };
}