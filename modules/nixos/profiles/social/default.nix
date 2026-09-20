{ options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.profiles.social;
in
{
  options.profiles.social = with types; {
    enable = mkBoolOpt false "Whether or not to enable social apps.";
  };

  config = mkIf cfg.enable {
    programs = {
      element = enabled;
      evolution = enabled;
      discord = enabled;
      slack = enabled;
    };
  };
}
# Profile enabling communication, collaboration, and social applications.