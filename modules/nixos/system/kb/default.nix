{ options, config, lib, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.system.kb;
in
{
  options.pluskinda.system.kb = with types; {
    enable = mkBoolOpt false "Whether or not to configure keyboard layout.";
  };

  config = mkIf cfg.enable {
    console = {
      keyMap = "uk";
    };
  };
}