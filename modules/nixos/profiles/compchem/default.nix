{ options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.profiles.compchem;
in
{
  options.profiles.compchem = with types; {
    enable = mkBoolOpt false "Whether or not to enable computational chemistry apps.";
  };

  config = mkIf cfg.enable {
    programs = {
      orca = enabled;
    };
  };
}
# Profile enabling computational-chemistry applications and dependencies.