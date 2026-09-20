{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.security.pass;
in
{
  options.security.pass = with types; {
    enable = mkBoolOpt false "Whether to enable the Pass password manager.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pass
    ];
  };
}