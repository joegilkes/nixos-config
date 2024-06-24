{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.cli-apps.ffbtools;
in
{
  options.pluskinda.cli-apps.ffbtools = with types; {
    enable = mkBoolOpt false "Whether or not to enable ffbtools.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = [ 
      pkgs.pluskinda.ffbwrap
    ]; 
  };
}