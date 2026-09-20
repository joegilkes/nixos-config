# Shared flakeless NixOS configuration: pin dependencies, define overlays, and
# import the repository's explicit module tree.
{ config, pkgs, ... }:

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
    ffbtools = final.callPackage ./packages/ffbtools { };
    ffbwrap = final.callPackage ./packages/ffbwrap { };
    nixos-revision = final.callPackage ./packages/nixos-revision { };
    ryujinx = final.callPackage ./packages/ryujinx { };
    sunshinectl = final.callPackage ./packages/sunshinectl { };
    wallpapers = final.callPackage ./packages/wallpapers { };
    update = final.callPackage ./packages/update { };
  };

  overlayArgs = { inherit inputs channels; };
  overlays = [
    (import ((source "qchem") + "/default.nix"))
    packageOverlay
    (import ./overlays/btop overlayArgs)
    (import ./overlays/calibre overlayArgs)
    (import ./overlays/homepage-dashboard overlayArgs)
    (import ./overlays/intel-ocl overlayArgs)
    (import ./overlays/liquidctl overlayArgs)
    (import ./overlays/openldap overlayArgs)
    (import ./overlays/traefik overlayArgs)
    (import ./overlays/star-citizen overlayArgs)
  ];
in
{
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
