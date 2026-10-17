{...}:

# Lix 2.95 is currently broken since mimalloc was added for 2.96 but
# isn't supported in 2.95. This has been fixed in https://github.com/NixOS/nixpkgs/pull/573942
# but hasn't made it through Hydra yet.
final: prev: {
  lixPackageSets = prev.lixPackageSets.extend (
    _: lprev: {
      lix_2_95 = lprev.lix_2_95.overrideScope (
        _: sprev: {
          lix = sprev.lix.overrideAttrs (old: {
            mesonFlags = prev.lib.remove "-Dmimalloc=disabled" old.mesonFlags;
          });
        }
      );
    }
  );
}