# Package the repository's flakeless NixOS rebuild wrapper as the `update`
# command, making it available to every system that enables `programs.misc`.
{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "update";
  runtimeInputs = with pkgs; [
    nix
    nixos-rebuild
  ];
  text = ''
    set -euo pipefail

    repo_root="$(pwd -P)"
    if [[ ! -f "$repo_root/npins/default.nix" || ! -d "$repo_root/systems" ]]; then
      printf 'Run update from the root of a NixOS configuration repository.\n' >&2
      exit 2
    fi
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

    host_config="$repo_root/systems/$system/$host/default.nix"
    if [[ ! -f "$host_config" ]]; then
      printf 'No configuration found for host %s in %s.\n' "$host" "$repo_root" >&2
      exit 2
    fi

    nixpkgs="$(cd "$repo_root" && nix eval --impure --raw \
      --expr '(import ./npins).nixpkgs.outPath')"

    exec nixos-rebuild "$action" --no-flake \
      -I "nixpkgs=$nixpkgs" \
      -I "nixos-config=$host_config" \
      "$@"
  '';
}
