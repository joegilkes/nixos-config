{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.programs.star-citizen;
in
{
  options.programs.star-citizen = with types; {
    enable = mkBoolOpt false "Whether or not to enable Star Citizen.";
    location = mkOpt str "$HOME/MyGames/star-citizen" "Location to install Star Citizen launcher.";
  };

  config = let 
    star-citizen = pkgs.star-citizen.override {
      location = cfg.location;
    };
  in 
    mkIf cfg.enable {
      environment.systemPackages = [ star-citizen ];

      boot.kernel.sysctl = {
        "vm.max_map_count" = 16777216;
        "fs.file-max" = 524288;
      };
    };
}