# Explicit index of every repository NixOS module.
# Keep this list alphabetical so adding a module is straightforward.
{ ... }:

{
  imports = [
    ./home
    ./nix
    ./user

    # GUI Apps
    ./apps/blender.nix
    ./apps/bottles.nix
    ./apps/bs-manager.nix
    ./apps/calibre.nix
    ./apps/chrome.nix
    ./apps/darktable.nix
    ./apps/discord.nix
    ./apps/dolphin.nix
    ./apps/eden.nix
    ./apps/element-desktop.nix
    ./apps/firefox.nix
    ./apps/godot.nix
    ./apps/heroic-launcher.nix
    ./apps/jellyfin-media-player.nix
    ./apps/keymapp.nix
    ./apps/kodi.nix
    ./apps/lutris.nix
    ./apps/mangohud.nix
    ./apps/microsoft-edge.nix
    ./apps/oversteer.nix
    ./apps/pcsx2.nix
    ./apps/pixelorama.nix
    ./apps/prismlauncher.nix
    ./apps/proton-pass.nix
    ./apps/proton-vpn.nix
    ./apps/protonup-qt.nix
    ./apps/r2modman.nix
    ./apps/rpcs3.nix
    ./apps/ryujinx.nix
    ./apps/sidequest.nix
    ./apps/slack.nix
    ./apps/spotify.nix
    ./apps/star-citizen.nix
    ./apps/steam.nix
    ./apps/steamtinkerlaunch.nix
    ./apps/tidal.nix
    ./apps/ultrastardx.nix
    ./apps/unigine-benchmarks.nix
    ./apps/vlc.nix
    ./apps/vscode.nix
    ./apps/winetricks.nix
    ./apps/xournalpp.nix

    # CLI Apps
    ./cli-apps/android-platform-tools.nix
    ./cli-apps/conda.nix
    ./cli-apps/ffbtools.nix
    ./cli-apps/fusee-nano.nix
    ./cli-apps/gamemode.nix
    ./cli-apps/julia.nix
    ./cli-apps/liquidctl.nix
    ./cli-apps/mprime.nix
    ./cli-apps/nixd.nix
    ./cli-apps/orca-qchem.nix
    ./cli-apps/texlive.nix

    # Desktops (display managers and addons)
    ./desktop/addons/electron-support.nix
    ./desktop/addons/wallpaper.nix
    ./desktop/addons/xdg-portal.nix
    ./desktop/gnome.nix
    ./desktop/kodi.nix

    # Hardware
    ./hardware/audio.nix
    ./hardware/fingerprint.nix
    ./hardware/networking.nix
    ./hardware/storage.nix
    ./hardware/surface.nix
    ./hardware/tablet.nix

    # Profiles
    ./profiles/benchmarking.nix
    ./profiles/browsers.nix
    ./profiles/common.nix
    ./profiles/compchem.nix
    ./profiles/creative.nix
    ./profiles/desktop.nix
    ./profiles/development.nix
    ./profiles/emulation.nix
    ./profiles/gamedev.nix
    ./profiles/gaming.nix
    ./profiles/htpc.nix
    ./profiles/media.nix
    ./profiles/nas.nix
    ./profiles/social.nix
    ./profiles/tuning.nix
    ./profiles/vr.nix

    # Security
    ./security/gpg.nix
    ./security/keyring.nix
    ./security/pass.nix

    # Services
    ./services/avahi.nix
    ./services/flatpak.nix
    ./services/glances.nix
    ./services/jellyfin.nix
    ./services/openssh.nix
    ./services/samba.nix
    ./services/sshServe.nix
    ./services/sunshine.nix
    ./services/virtualisation.nix
    ./services/zfs.nix

    # System
    ./system/boot.nix
    ./system/env.nix
    ./system/fhs-bindmounts.nix
    ./system/fonts.nix
    ./system/kb.nix
    ./system/locale.nix
    ./system/time.nix

    # Tools
    ./tools/appimage.nix
    ./tools/diagnostics.nix
    ./tools/git.nix
    ./tools/misc.nix
    ./tools/rpi.nix
    ./tools/sensors.nix
    ./tools/usb-modeswitch.nix
  ];
}
