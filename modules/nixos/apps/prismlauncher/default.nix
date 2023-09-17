{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.apps.prismlauncher;
in
{
  options.pluskinda.apps.prismlauncher = with types; {
    enable = mkBoolOpt false "Whether or not to enable Prism Launcher.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      prismlauncher
    ];
  };
}