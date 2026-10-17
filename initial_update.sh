#!/usr/bin/env bash
set -euo pipefail

repo_root="$(pwd)"
action="${1:-switch}"
if [[ $# -gt 0 ]]; then
    shift
fi
    
host="${NIXOS_HOST:-$(hostname)}"
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