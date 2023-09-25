{ lib, pkgs, stdenv, ... }:

pkgs.mkShell {
  packages = with pkgs; [
    libgcc
  ];
  shellHook = ''
    echo --- Development Environment: GNU ---
    exec zsh
  '';
}