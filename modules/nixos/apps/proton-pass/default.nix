{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.apps.proton-pass;
in
{
  options.pluskinda.apps.proton-pass = with types; {
    enable = mkBoolOpt false "Whether or not to enable Proton Pass.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      proton-pass
    ];
  };
}