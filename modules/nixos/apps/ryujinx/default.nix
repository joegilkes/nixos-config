{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.programs.ryujinx;
in
{
  options.programs.ryujinx = with types; {
    enable = mkBoolOpt false "Whether or not to enable Ryujinx.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ ryubing ]; };
}