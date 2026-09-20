{ config, lib, pkgs, modulesPath, ...}:

let
  nixos-hardware = (import ../../../npins).nixos-hardware.outPath;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    "${nixos-hardware}/common/cpu/amd"
    "${nixos-hardware}/common/cpu/amd/pstate.nix"
    "${nixos-hardware}/common/gpu/amd"
    "${nixos-hardware}/common/pc"
    "${nixos-hardware}/common/pc/ssd"
  ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;
  boot.kernelParams = [ "amd_iommu=on" ];
  boot.kernelModules = [ "kvm-amd" "coretemp" "zenpower" "sg" ];
  boot.extraModulePackages = [ ];
  boot.extraModprobeConfig = ''
    options kvm ignore_msrs=1 report_ignored_msrs=0
    options kvm_amd nested=1
  '';

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/89341997-7c37-4a6c-a83d-37ee31770a55";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/8ED7-D52D";
      fsType = "vfat";
    };

  fileSystems."/beluga" = 
    { device = "/dev/disk/by-label/beluga";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/14e3060c-1d7c-48c7-b164-51044d9eed54"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp14s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp15s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.usb-modeswitch.enable = true;

  hardware.audio.use-musnix = true;
}
