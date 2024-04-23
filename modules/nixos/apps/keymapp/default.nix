{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.keymapp;
in
{
  options.pluskinda.apps.keymapp = with types; {
    enable = mkBoolOpt false "Whether or not to enable chrome.";
  };

  config =
    mkIf cfg.enable { 
      environment.systemPackages = with pkgs; [ keymapp ]; 

      hardware.keyboard.zsa.enable = true;
    };
}