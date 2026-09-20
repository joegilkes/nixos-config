# NixOS Configuration

[![npins Checker](https://github.com/joegilkes/nixos-config/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/joegilkes/nixos-config/actions/workflows/main.yml)

Dependencies are pinned with [npins](https://github.com/andir/npins), and all
repository modules are imported explicitly.

## Rebuilding a system

After applying the configuration, use the installed `update` command. It
selects the host configuration from the current hostname and evaluates the
pinned Nixpkgs source:

```sh
update switch
```

Set `NIXOS_HOST` when rebuilding a different host, or pass additional
`nixos-rebuild` options after the action:

```sh
NIXOS_HOST=giants-deep update build --show-trace
```

The available hosts are `attlerock`, `brittle-hollow`, `giants-deep`,
`timber-hearth`, and `interloper`.

## Updating dependencies

Use the system-provided `npins` command from the repository root to inspect,
verify, or update pinned sources:

```sh
npins --directory npins show
npins --directory npins verify
npins --directory npins update
```