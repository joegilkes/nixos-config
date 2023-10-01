{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.cli-apps.nixd;
in
{
  options.pluskinda.cli-apps.nixd = with types; {
    enable = mkBoolOpt false "Whether or not to enable nixd.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ nixd ]; };
}