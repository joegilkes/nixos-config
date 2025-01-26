{ inputs, lib, ... }:
let
  crowdsec-pkg-overlay = final: prev: {
    crowdsec = prev.pluskinda.crowdsec;
  };
in
  lib.composeManyExtensions [ 
    inputs.crowdsec.overlays.default
    crowdsec-pkg-overlay
  ]