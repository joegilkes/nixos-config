{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.programs.direnv;
in
{
  config = mkIf cfg.enable {
    home.extraOptions = {
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv = enabled;
      };
    };
  };
}