{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.tools.diagnostics;
  amdPkgs = with pkgs; [ 
    nvtopPackages.amd
    radeontop
    radeon-profile
  ];
  nvidiaPkgs = with pkgs; [ nvtop ];
in
{
  options.pluskinda.tools.diagnostics = with types; {
    enable = mkBoolOpt false "Whether or not to enable diagnostic utilities.";
    gpuType = mkOpt str "none" "GPU type, for installing vendor-specific utilities [none, amd, nvidia]";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lshw
      glxinfo
      pciutils
      inxi
    ] ++ optionals (cfg.gpuType == "amd") amdPkgs ++ optionals (cfg.gpuType == "nvidia") nvidiaPkgs;
  };
}