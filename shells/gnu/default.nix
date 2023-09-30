{ lib, pkgs, stdenv, ... }:

pkgs.mkShell {
  packages = with pkgs; [
    gcc
  ];
  shellHook = ''
    echo --- Development Environment: GNU ---
  '';
}