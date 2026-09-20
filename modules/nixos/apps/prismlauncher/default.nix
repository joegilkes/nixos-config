{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.programs.prismlauncher;
in
{
  options.programs.prismlauncher = with types; {
    enable = mkBoolOpt false "Whether or not to enable Prism Launcher.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      prismlauncher
    ];
  };
}