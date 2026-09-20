{ options, config, pkgs, lib, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.services.virtualisation;
in
{
  options.services.virtualisation = with types; {
    enable = mkBoolOpt false "Whether or not to allow QEMU/KVM virtualisation.";
  };

  config = mkIf cfg.enable { 
    virtualisation = {
      libvirtd = enabled;
      spiceUSBRedirection = enabled;
    };
    programs.virt-manager = enabled;

    # environment.etc."libvirt/network.conf".text = ''
    #   firewall_backend=iptables
    # '';
    networking.firewall.trustedInterfaces = [ "virbr0" "virbr1" ];

    user.extraGroups = [ "libvirtd" ];
  };
}