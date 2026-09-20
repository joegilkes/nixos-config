{ options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
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
      # coolercontrol = enabled;
      liquidctl = enabled;
      diagnostics = enabled;
      sensors = enabled;
    };
  };
}
# Profile enabling hardware monitoring and performance-tuning tools.