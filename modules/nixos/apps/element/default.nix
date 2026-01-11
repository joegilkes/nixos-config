{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.element;
in
{
  options.pluskinda.apps.element = with types; {
    enable = mkBoolOpt false "Whether or not to enable Element.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ 
      element-desktop
    ];
  };
}