{ config, lib, ... }:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });

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
      discord = enabled;
      slack = enabled;
    };
  };
}