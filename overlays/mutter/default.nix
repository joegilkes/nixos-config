{ channels, ... }:

self: super: {
  mutter = super.mutter.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      ./d6fb713cd22abeca146a983e7251f1aebc6f2693.patch
    ];
  });
}