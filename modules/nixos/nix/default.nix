{  options, config, pkgs, lib, inputs, ... }:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.nix;

  substituters-submodule = types.submodule ({ name, ... }: {
    options = with types; {
      key = mkOpt (nullOr str) null "The trusted public key for this substituter.";
    };
  });
in
{
  options.nix = with types; {
    useLix = mkBoolOpt false "Whether to replace Nix and dependent programs with Lix.";

    default-substituter = {
      url = mkOpt str "https://cache.nixos.org" "The url for the substituter.";
      key = mkOpt str "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "The trusted public key for the substituter.";
    };

    extra-substituters = mkOpt (attrsOf substituters-submodule) { } "Extra substituters to configure.";

    report-changes = mkBoolOpt true "Whether or not to generate a store diff with nvd when activating a new configuration.";
  };

  config = mkIf cfg.enable {
    assertions = mapAttrsToList
      (name: value: {
        assertion = value.key != null;
        message = "nix.extra-substituters.${name}.key must be set";
      })
      cfg.extra-substituters;

    environment.systemPackages = with pkgs; [
      nixos-revision
      nixfmt
      nix-prefetch-git
      nix-output-monitor
      nvd
    ];

    system.activationScripts = mkIf cfg.report-changes {
      report-changes = ''
        PATH=$PATH:${lib.makeBinPath [ pkgs.nvd cfg.package ]}
        nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2)
      '';
    };

    nixpkgs.overlays = mkIf cfg.useLix [ (final: prev: {
      inherit (prev.lixPackageSets.stable)
        nixpkgs-review
        nix-eval-jobs
        nix-fast-build
        colmena;
    }) ];

    nix =
      let users = [ "root" config.user.name ] ++
        optional config.nix.sshServe.enable "nix-ssh" ++
        optional config.services.hydra.enable "hydra";
      in
      {
        package = mkIf cfg.useLix pkgs.lixPackageSets.stable.lix;

        settings = {
          experimental-features = [ "nix-command" ];
          http-connections = 50;
          warn-dirty = false;
          log-lines = 50;
          sandbox = "relaxed";
          auto-optimise-store = true;
          trusted-users = users;
          allowed-users = users;

          substituters =
            [ cfg.default-substituter.url ]
              ++
              (mapAttrsToList (name: value: name) cfg.extra-substituters);
          trusted-public-keys =
            [ cfg.default-substituter.key ]
              ++
              (mapAttrsToList (name: value: value.key) cfg.extra-substituters);

        } // (lib.optionalAttrs config.programs.direnv.enable {
          keep-outputs = true;
          keep-derivations = true;
        });

        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 30d";
        };

      };
  };
}