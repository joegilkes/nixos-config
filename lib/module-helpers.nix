# Shared helper entry point for NixOS modules. It combines the general and
# module-specific helpers and is injected as `moduleHelpers` by configuration.nix.
{ lib }:

(import ./default.nix { inherit lib; inputs = { }; })
// (import ./module { inherit lib; })
