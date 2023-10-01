{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.tools.diagnostics;
in
{
  options.pluskinda.tools.diagnostics = with types; {
    enable = mkBoolOpt false "Whether or not to enable diagnostic utilities.";
    gpuType = mkOpt str "none" "GPU type, for installing vendor-specific utilities [none, amd, nvidia]"
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lshw
      glxinfo
      pciutils
    ] ++ mkIf cfg.gpuType == "amd" [
      nvtop-amd
      radeontop
      radeon-profile
    ] ++ mkIf cfg.gpuType == "nvidia" [
      nvtop
    ];
  };
}