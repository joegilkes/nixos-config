{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.programs.diagnostics;
  amdPkgs = with pkgs; [ 
    nvtopPackages.amd
    radeontop
    radeon-profile
  ];
  nvidiaPkgs = with pkgs; [ nvtop ];
in
{
  options.programs.diagnostics = with types; {
    enable = mkBoolOpt false "Whether or not to enable diagnostic utilities.";
    gpuType = mkOpt str "none" "GPU type, for installing vendor-specific utilities [none, amd, nvidia]";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lshw
      mesa-demos
      pciutils
      inxi
    ] ++ optionals (cfg.gpuType == "amd") amdPkgs ++ optionals (cfg.gpuType == "nvidia") nvidiaPkgs;
  };
}