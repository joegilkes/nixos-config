inputs@{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.cli-apps.flake;
in
{
  options.pluskinda.cli-apps.flake = with types; {
    enable = mkBoolOpt false "Whether or not to enable flake.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      snowfallorg.flake
    ];
  };
}