{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.apps.blender;
  amdPkgs = with pkgs; [
    blender-hip
  ];
  nvidiaPkgs = with pkgs; [
    blender
  ];
in
{
  options.pluskinda.apps.blender = with types; {
    enable = mkBoolOpt false "Whether or not to enable Blender.";
    gpuType = mkOpt str "none" "GPU type, for installing vendor-specific utilities [none, amd, nvidia]";
  };

  config =
    mkIf cfg.enable { 
      environment.systemPackages = if (cfg.gpuType == "amd") then amdPkgs else nvidiaPkgs;
    };
}