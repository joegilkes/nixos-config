{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.tools.diagnostics;
in
{
  options.pluskinda.tools.diagnostics = with types; {
    enable = mkBoolOpt false "Whether or not to enable diagnostic utilities.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lshw
      glxinfo
      pciutils
    ];
  };
}