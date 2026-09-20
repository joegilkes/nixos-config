{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.programs.keymapp;
in
{
  options.programs.keymapp = with types; {
    enable = mkBoolOpt false "Whether or not to enable chrome.";
  };

  config =
    mkIf cfg.enable { 
      environment.systemPackages = with pkgs; [ keymapp ]; 

      hardware.keyboard.zsa.enable = true;
    };
}