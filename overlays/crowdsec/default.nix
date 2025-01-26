{ channels, ... }: 

final: prev: {
  inherit (channels.stable) crowdsec;
}
