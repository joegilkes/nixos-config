{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.slack;
in
{
  options.pluskinda.apps.slack = with types; {
    enable = mkBoolOpt false "Whether or not to enable Bottles.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ slack ]; };
}