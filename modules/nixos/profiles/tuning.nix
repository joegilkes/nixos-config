{ config, lib, ... }:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });

let
  cfg = config.profiles.tuning;
in
{
  options.profiles.tuning = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable the performance tuning profile.";
  };

  config = mkIf cfg.enable {
    programs = {
      liquidctl = enabled;
      diagnostics = enabled;
      sensors = enabled;
    };
  };
}