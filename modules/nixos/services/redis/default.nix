{ lib, config, options, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
{
  config = {
    services.redis.servers."".port = 0;
  };
}