{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.ryujinx;
in
{
  options.pluskinda.apps.ryujinx = with types; {
    enable = mkBoolOpt false "Whether or not to enable Ryujinx.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ ryubing ]; };
}