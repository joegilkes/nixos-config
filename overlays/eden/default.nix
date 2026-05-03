{...}:

final: prev: {
  eden = prev.eden.overrideAttrs (finalAttrs: prevAttrs: {
    version = "0.2.0-rc2";
    src = prev.fetchFromGitea {
      domain = "git.eden-emu.dev";
      owner = "eden-emu";
      repo = "eden";
      tag = "v0.2.0-rc2";
      hash = "sha256-keLkB5qeQch+tM2J6zVh9oQGhP5TuxItqrZRN24apJw=";
    };
    patches = [];
    buildInputs = prevAttrs.buildInputs ++ [ prev.qt6.qtcharts ];
  });
}
