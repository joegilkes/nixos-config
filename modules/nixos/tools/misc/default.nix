{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.programs.misc;
  gpuType = config.programs.diagnostics.gpuType;

in
{
  options.programs.misc = with types; {
    enable = mkBoolOpt false "Whether or not to enable common utilities.";
  };

  config = mkIf cfg.enable {
    home.configFile."wgetrc".text = "";

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
      fastfetch
      lshw
      util-linux
      npins
      update
    ] ++ ( if gpuType == "amd" then [ btop-rocm ] else [ btop ] );
  };
}