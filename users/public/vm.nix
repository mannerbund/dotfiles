{
  username,
  pkgs,
  lib,
  ...
}:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = [ "${username}" ];
  users.users.${username}.extraGroups = [ "libvirtd" ];

  virtualisation.libvirtd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;

  environment = {
    systemPackages = [ pkgs.qemu ];
  };

  systemd.services.libvirtd.wantedBy = lib.mkForce [ ];
}
