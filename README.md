# NixOS Configuration

[![npins Checker](https://github.com/joegilkes/nixos-config/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/joegilkes/nixos-config/actions/workflows/main.yml)

* Dependencies pinned with [npins](https://github.com/andir/npins), using a custom update script to set the pinned nixpkgs and select the correct hostname to build at runtime.
* Propagates the currently pinned nixpkgs instance to nix-shell and comma on rebuild.
* Extends nixpkgs' module system with per-program modules and additional options on existing modules.
* Includes custom programs and extended Nix function library.

## Systems

| **System** | **Specs** | **Description** |
| ---------- | --------- | --------------- |
| `timber-hearth` | AMD Ryzen 5 7600X<br/>AMD Radeon RX 7700 XT<br/>32 GB DDR5 @ 6000 MT/s<br/>Latest XanMod kernel  | Main coding/gaming rig, serves as a remote builder and extra binary substituter for the other systems. |
| `giants-deep` | Intel i7-6700K<br/>32 GB DDR4 @ 2133 MT/s<br/>4x Seagate IronWolf Pro 4 TB in RAIDZ2 | NAS and home server running Jellyfin, Calibre-Web, Dawarich, etc. |
| `brittle-hollow` | Dell Latitude 5510 | Old laptop serving as a testbed for potentially breaking config changes before rolling out onto production systems. |
| `attlerock` | Microsoft Surface Pro 2017 | A terrible excuse for a device that can't run the OS it was made for anymore. Realistically only gets used for TTRPG character sheets these days. |
| `interloper` | Raspberry Pi 4B<br/>4 GB memory<br/>32 GB SD card | Authentication server, runs LLDAP and Authelia in front of every publicly exposed subdomain. Has no business really running NixOS since it literally can't update without running out of storage and/or memory, but gets by on emulated aarch64 builds done on `timber-hearth`.


## Rebuilding a system

On a first install, use the `initial_update.sh` script to get the system initialised correctly for updating with npins. Once this has been done, the `update` program can be used as a wrapper around `nixos-rebuild` to select the currently pinned nixpkgs and the correct hostname's configuration. While in this config's directory:

```sh
# Rebuild the current host and switch to the new config.
sudo update

# Build the current host and switch to the new config on next boot.
sudo update boot

# Build the current host and switch, without trying to build on timber-hearth.
sudo update --option builders ""

# Build a different host with error traces.
NIXOS_HOST=giants-deep update build --show-trace

# Build a different host and push its new config to be switched to on next boot.
NIXOS_HOST="interloper" update boot --target-host interloper.home --no-reexec --elevate=sudo --ask-elevate-password
```

All systems default to preferring `timber-hearth` as a builder when `update` is used locally. 

`interloper` gets special treatment - since it often takes years to copy built derivations on its own, it is easier to run the entire build on `timber-hearth` and then copy it over in one, as above. This creates an issue, as `timber-hearth` garbage collects `interloper`'s entire system derivation (including its kernel build) and then needs to rebuild everything. This is resolved by letting `interloper` also be a substituter for `timber-hearth`, so while building `interloper` it can fetch any already existing derivations from there instead of rebuilding them.
