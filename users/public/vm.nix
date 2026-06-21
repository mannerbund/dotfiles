{
  username,
  pkgs,
  lib,
  ...
}:
{
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
