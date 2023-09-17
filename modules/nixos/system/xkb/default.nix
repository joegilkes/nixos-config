{ options, config, lib, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.system.xkb;
in
{
  options.pluskinda.system.xkb = with types; {
    enable = mkBoolOpt false "Whether or not to configure xkb.";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      layout = "uk";
      xkbVariant = "";
    };
  };
}