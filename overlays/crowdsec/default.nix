{ channels, ... }: 

final: prev: {
  inherit (channels.master) crowdsec;
}
