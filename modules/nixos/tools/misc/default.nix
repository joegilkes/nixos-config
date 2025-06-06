{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.tools.misc;
  gpuType = config.pluskinda.tools.diagnostics.gpuType;

in
{
  options.pluskinda.tools.misc = with types; {
    enable = mkBoolOpt false "Whether or not to enable common utilities.";
  };

  config = mkIf cfg.enable {
    pluskinda.home.configFile."wgetrc".text = "";

    environment.systemPackages = with pkgs; [
      vim
      fzf
      killall
      unzip
      file
      jq
      clac
      wget
      curl
      screen
      eza
      htop
      iotop
      iftop
      strace # system call monitor
      ltrace # library call monitor
      lsof # list open files 
      neofetch
      lshw
      glxinfo
      util-linux
    ] ++ ( if gpuType == "amd" then [ btop-rocm ] else [ btop ] );
  };
}