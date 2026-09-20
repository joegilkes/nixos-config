{  options, config, lib, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.system.kb;
in
{
  options.system.kb = with types; {
    enable = mkBoolOpt false "Whether or not to configure keyboard layout.";
  };

  config = mkIf cfg.enable {
    console = {
      keyMap = "uk";
    };
    services.xserver.xkb = {
      layout = "gb";
    };
  };
}