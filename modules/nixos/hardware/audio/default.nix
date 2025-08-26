{ options, config, pkgs, lib, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.hardware.audio;
  musnixAvailable = builtins.hasAttr "musnix" options;
in
{
  options.pluskinda.hardware.audio = with types; {
    enable = mkBoolOpt false "Whether or not to enable audio support.";
    use-musnix = mkBoolOpt false "Whether or not to enable musnix module.";
    use-musnix-rt = mkBoolOpt false "Whether or not to recompile the kernel with musnix RT tweaks.";
    extra-packages = mkOpt (listOf package) [ ] "Additional packages to install.";
  };

  config = mkIf cfg.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    environment.systemPackages = with pkgs; [
      pulsemixer
      pavucontrol
    ] ++ cfg.extra-packages;

    pluskinda.user.extraGroups = [ "audio" ];

  } // optionalAttrs musnixAvailable {
    musnix = mkIf cfg.use-musnix {
      enable = true;
      rtcqs.enable = true;
      kernel.realtime = cfg.use-musnix-rt;
    };
  };
}