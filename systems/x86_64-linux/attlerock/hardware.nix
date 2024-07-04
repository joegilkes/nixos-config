{ config, lib, pkgs, modulesPath, inputs, ... }:

let
  inherit (inputs) nixos-hardware;
in
{
  imports = with nixos-hardware.nixosModules; [ 
    (modulesPath + "/installer/scan/not-detected.nix")
    microsoft-surface-pro-intel
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "pinctrl_sunrisepoint" ];
  boot.initrd.kernelModules = [ "pinctrl_sunrisepoint" ];
  boot.kernelModules = [ "kvm-intel" "soc_button_array" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [ "i915.enable_psr=0" ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/490f3cc2-ea36-4ed5-a5d9-b321379a9d48";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/3C99-BE1F";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/ddb72fe5-683e-4698-8eae-5de5083d8d36"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
