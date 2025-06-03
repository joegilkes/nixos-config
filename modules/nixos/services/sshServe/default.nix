# Lix 2.93.0 ssh connection sharing fixed unfortunately broke the nixpkgs sshServe
# module's ForceCommand, see https://git.lix.systems/lix-project/lix/issues/830
# This can be fixed (for now) by replacing the forced command with a custom script,
# see https://discourse.nixos.org/t/wrapper-to-restrict-builder-access-through-ssh-worth-upstreaming/25834/15
{ config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.services.sshServe;
  template = input: command: "    ${lib.escapeShellArg input})\n      ${lib.escapeShellArgs command}\n      ;;";
  buildCommand = commands: pkgs.writeShellApplication {
    name = "nix-serve-forcecommand";
    text = ''
      runCommand() {
        case "$1" in
      ${builtins.concatStringsSep "\n" (builtins.map ({ input, command }: template input command) commands)}
          # some implementations use "exec", emulate this
          "exec "*)
            runCommand "''${1##"exec "}"
            exit
            ;;
          # other commands are prohibited
          *)
            printf "not running unknown command '%s'\\n" "$1" >&2
            exit 1
        esac
      }

      # implementations may pass a command directly, however some implementations pass "bash" as the command to run interactively
      if test -n "''${SSH_ORIGINAL_COMMAND:+x}" && test "$SSH_ORIGINAL_COMMAND" != bash; then
        runCommand "$SSH_ORIGINAL_COMMAND"
      else
        while read -r line; do
          runCommand "$line"
        done
      fi
    '';
    runtimeInputs = [ config.nix.package ];
  };
  command = buildCommand ([ { input = "echo started"; command = [ "echo" "started" ]; } ]
    ++ lib.optional (cfg.protocol == "ssh") { input = "nix-store --serve"; command = [ "nix-store" "--serve" ]; }
    ++ lib.optional (cfg.protocol == "ssh" && cfg.write) { input = "nix-store --serve --write"; command = [ "nix-store" "--serve" "--write" ]; }
    ++ lib.optional (cfg.protocol == "ssh-ng") { input = "nix-daemon --stdio"; command = [ "nix-daemon" "--stdio" ]; }
  );
in
{
  options.pluskinda.services.sshServe = {
    enable = mkBoolOpt false "Whether to enable serving the Nix store as a remote store via SSH.";
    write = mkBoolOpt false "Whether to enable writing to the Nix store as a remote store via SSH. Note: by default, the sshServe user is named nix-ssh and is not a trusted-user. nix-ssh should be added to the {option}`nix.sshServe.trusted` option in most use cases, such as allowing remote building of derivations to anonymous people based on ssh key";
    trusted = mkBoolOpt false "Whether to add the nix-ssh user to the nix.settings.trusted-users option.";
    keys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "ssh-dss AAAAB3NzaC1k... alice@example.org" ];
      description = "A list of SSH public keys allowed to access the binary cache via SSH.";
    };
    protocol = lib.mkOption {
      type = lib.types.enum [
        "ssh"
        "ssh-ng"
      ];
      default = "ssh";
      description = "The specific Nix-over-SSH protocol to use.";
    };
  };

  config = mkIf cfg.enable {
    users.users.nix-ssh = {
      description = "Nix SSH store user";
      isSystemUser = true;
      group = "nix-ssh";
      shell = pkgs.bashInteractive;
    };
    users.groups.nix-ssh = { };

    nix.settings.trusted-users = lib.mkIf cfg.trusted [ "nix-ssh" ];

    services.openssh.enable = true;

    services.openssh.extraConfig = ''
      Match User nix-ssh
        AllowAgentForwarding no
        AllowTcpForwarding no
        PermitTTY no
        PermitTunnel no
        X11Forwarding no
        ForceCommand ${command.out}/bin/nix-serve-forcecommand
      Match All
    '';

    users.users.nix-ssh.openssh.authorizedKeys.keys = cfg.keys;

  };
}