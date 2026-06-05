{
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/niri-desktop.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/flatpak.nix
    ../../modules/nixos/tailscale.nix
    ../../modules/nixos/syncthing.nix
    ../../modules/nixos/kanata.nix
    ../../modules/nixos/onlyoffice.nix
    ../../modules/nixos/fcitx5.nix
    ../../modules/nixos/zsh.nix
  ];

  # Disable TPM (firmware bug causes 90s boot timeout)
  boot.initrd.systemd.tpm2.enable = false;
  systemd.suppressedSystemUnits = [
    "dev-tpm0.device"
    "dev-tpmrm0.device"
    "tpm2.target"
  ];

  # Hostname
  networking.hostName = "home-ws01";

  # Locale configuration
  myLocale = {
    defaultLocale = "en_US.UTF-8";
  };

  # Fix cedilla for Brazilian keyboard users
  i18n.extraLocaleSettings = {
    LC_CTYPE = "pt_BR.UTF-8";
  };

  # Mount additional drive
  fileSystems."/mnt/barracuda" = {
    device = "/dev/disk/by-uuid/35991c62-0cd9-4a34-9e38-aa46f153288f";
    fsType = "ext4";
    options = [ "defaults" ];
  };

  # Mount NAS Samba share
  fileSystems."/mnt/nas" = {
    device = "//192.168.0.10/media";
    fsType = "cifs";
    options = [
      "guest"
      "nofail"
      "uid=1000"
      "gid=100"
      "file_mode=0664"
      "dir_mode=0775"
    ];
  };

  # Define user account
  users.users.bruno = {
    isNormalUser = true;
    description = "Bruno Resende";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "uinput"
    ];
    packages = with pkgs; [
      calibre
      lutris
    ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    mpv
    xwayland-satellite
  ];

  # Fix Dolphin file associations when running KDE apps outside Plasma.
  # https://github.com/NixOS/nixpkgs/issues/409986
  environment.etc."xdg/menus/applications.menu".source = ../../modules/nixos/dolphin.menu;

  # Keep 32-bit graphics support for Steam/Wine games.
  hardware.graphics.enable32Bit = true;

  # Steam
  programs.steam = {
    enable = true;
  };

}
