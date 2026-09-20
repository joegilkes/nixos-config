{ options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.profiles.benchmarking;
in
{
  options.profiles.benchmarking = with types; {
    enable = mkBoolOpt false "Whether or not to enable benchmarking apps.";
  };

  config = mkIf cfg.enable {
    programs = {
      unigine = enabled;
        mprime = enabled;
    };
  };
}
# Profile enabling tools and settings used for system benchmarking.