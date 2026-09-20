{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.programs.element;
in
{
  options.programs.element = with types; {
    enable = mkBoolOpt false "Whether or not to enable Element.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ 
      element-desktop
    ];
  };
}