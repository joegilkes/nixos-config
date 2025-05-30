{ config, lib, pkgs, modulesPath, inputs, ...}:

let
  inherit (inputs) nixos-hardware;

  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  imports = with nixos-hardware.nixosModules; [
    (modulesPath + "/installer/scan/not-detected.nix")
    common-cpu-intel
    common-pc
    common-pc-ssd
  ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelPackages = latestKernelPackage;
  boot.kernelModules = [ "coretemp" ];
  boot.kernelParams = [ "nohibernate" ];
  # boot.extraModulePackages = [ (config.boot.kernelPackages.callPackage ./tbs-driver.nix {}) ];
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/401ebf9b-7cbf-468b-bd99-bd2785702963";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A9CA-8858";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  fileSystems."/mnt/gabbro" = 
    { device = "gabbro";
      fsType = "zfs";
    };

  fileSystems."/mnt/gabbro/backups" = 
    { device = "gabbro/backups";
      fsType = "zfs";
    };

  fileSystems."/mnt/gabbro/media" = 
    { device = "gabbro/media";
      fsType = "zfs";
    };

  fileSystems."/mnt/gabbro/storage" = 
    { device = "gabbro/storage";
      fsType = "zfs";
    };

  fileSystems."/mnt/gabbro/nextcloud" = 
    { device = "gabbro/nextcloud";
      fsType = "zfs";
    };

  fileSystems."/mnt/gabbro/public" = 
    { device = "gabbro/public";
      fsType = "zfs";
    };

  fileSystems."/mnt/keyring" = 
    { device = "/dev/disk/by-label/KEYRING";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/222e077b-3829-4e44-a04c-0d1e2111d0d2"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  networking.hostId = "e4db24ff";
  # networking.interfaces.enp14s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp15s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
