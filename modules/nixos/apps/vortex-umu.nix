{ config, lib, pkgs, ... }:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });

let
  cfg = config.programs.vortex-umu;
in
{
  options.programs.vortex-umu = with types; {
    enable = mkBoolOpt false "Whether or not to enable Vortex, wrapped underneath umu-launcher.";
    pressure-vessel-filesystems-rw = mkOpt (types.listOf types.str) [] "A list of paths to make read-write accessible to the umu-launcher process. This is useful for allowing Vortex to write to game directories that are normally read-only.";
  };

  config = mkIf cfg.enable { 
    environment.systemPackages = with pkgs; [ 
      (vortex-umu.override { 
        pressureVesselFilesystemsRW = cfg.pressure-vessel-filesystems-rw; 
      })
    ]; 
  };
}