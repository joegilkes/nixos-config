{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.cli-apps.liquidctl;
in
{
  options.pluskinda.cli-apps.liquidctl = with types; {
    enable = mkBoolOpt false "Whether or not to enable liquidctl.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ liquidctl ]; };
}