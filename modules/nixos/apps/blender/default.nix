{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.programs.blender;
  amdPkgs = with pkgs; [
    pkgsRocm.blender
  ];
  nvidiaPkgs = with pkgs; [
    pkgsCuda.blender
  ];
in
{
  options.programs.blender = with types; {
    enable = mkBoolOpt false "Whether or not to enable Blender.";
    gpuType = mkOpt str "none" "GPU type, for installing vendor-specific utilities [none, amd, nvidia]";
  };

  config =
    mkIf cfg.enable { 
      environment.systemPackages = if (cfg.gpuType == "amd") then amdPkgs else nvidiaPkgs;
    };
}