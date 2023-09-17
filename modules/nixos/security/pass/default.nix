{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.security.pass;
in
{
  options.pluskinda.security.pass = with types; {
    enable = mkBoolOpt false "Whether to enable the Pass password manager.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pass
    ];
  };
}