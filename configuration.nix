# Shared flakeless NixOS configuration: pin dependencies, define overlays, and
# import the repository's explicit module tree.
{ lib, pkgs, ... }:

let
  sources = import ./npins;
  source = name: sources.${name}.outPath;

  channels = {
    nixpkgs = pkgs;
    stable = import (source "stable") {
      inherit (pkgs) system;
      config.allowUnfree = true;
    };
    master = import (source "master") {
      inherit (pkgs) system;
      config.allowUnfree = true;
    };
  };

  inputs = sources // {
    nixpkgs = pkgs;
  };

  packageOverlay = final: _prev: {
    wallpapers = final.callPackage ./packages/wallpapers { };
    ffbtools = final.callPackage ./packages/ffbtools.nix { };
    ffbwrap = final.callPackage ./packages/ffbwrap.nix { };
    sunshinectl = final.callPackage ./packages/sunshinectl.nix { };
    update = final.callPackage ./packages/update.nix { };
  };

  overlayArgs = { inherit inputs channels; };
  overlays = [
    (import ((source "qchem") + "/default.nix"))
    packageOverlay
    (import ./overlays/btop-rocm_package.nix overlayArgs)
    (import ./overlays/homepage-dashboard_background.nix overlayArgs)
    (import ./overlays/intel-ocl_src.nix overlayArgs)
    (import ./overlays/liquidctl_latest.nix overlayArgs)
    (import ./overlays/openldap_platform_check.nix overlayArgs)
    (import ./overlays/star-citizen_package.nix overlayArgs)
  ];
in
{
  nix.nixPath = lib.mkForce [
    "nixpkgs=${source "nixpkgs"}"
    "nixos-config=/etc/nixos/configuration.nix"
  ];

  imports = [
    ./modules/nixos
    "${source "home-manager"}/nixos"
    "${source "agenix"}/modules/age.nix"
    "${source "nix-index-database"}/nixos-module.nix"
    "${source "musnix"}"
    "${source "quadlet-nix"}/nixos-module.nix"
  ];

  _module.args = {
    inherit inputs channels;
    channel = pkgs;
  };

  programs.nix-index.enableZshIntegration = true;
  programs.command-not-found.enable = false;
  programs.nix-index-database.comma.enable = true;

  nixpkgs = {
    config.allowUnfree = true;
    inherit overlays;
  };
}
