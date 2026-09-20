# Package the repository's flakeless NixOS rebuild wrapper as the `update`
# command, making it available to every system that enables `programs.misc`.
{ pkgs, lib, ... }:

let
  repository = builtins.path {
    path = ../..;
    name = "nixos-config-source";
    filter = path: type:
      let name = builtins.baseNameOf path;
      in name != ".git" && name != "result";
  };
in
pkgs.writeShellApplication {
  name = "update";
  runtimeInputs = with pkgs; [
    nix
    nixos-rebuild
  ];
  text = ''
    set -euo pipefail

    repo_root=${lib.escapeShellArg (toString repository)}
    action="''${1:-switch}"
    if [[ $# -gt 0 ]]; then
      shift
    fi

    host="''${NIXOS_HOST:-$(hostname)}"
    case "$host" in
      attlerock|brittle-hollow|giants-deep|timber-hearth)
        system="x86_64-linux"
        ;;
      interloper)
        system="aarch64-linux"
        ;;
      *)
        printf 'Unsupported NixOS host: %s\n' "$host" >&2
        exit 2
        ;;
    esac

    nixpkgs="$(cd "$repo_root" && nix eval --impure --raw \
      --expr '(import ./npins).nixpkgs.outPath')"

    exec nixos-rebuild "$action" --no-flake \
      -I "nixpkgs=$nixpkgs" \
      -I "nixos-config=$repo_root/systems/$system/$host/default.nix" \
      "$@"
  '';
}
